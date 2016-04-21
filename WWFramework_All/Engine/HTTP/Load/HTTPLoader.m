//
//  HTTPLoader.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPLoader.h"
#import "HTTPCachingResponseLoader.h"
#import "DataOutputStream.h"

@interface HTTPLoader ()

@property (nonatomic) HTTPRequest *currentRequest;

@property (nonatomic) HTTPTransaction *transaction;

@property (nonatomic) HTTPCachedResponse *cachedResponse;

@property (nonatomic) HTTPResponse *response;

- (void)finishWithCode:(HTTPLoadCode)code;

@end


@implementation HTTPLoader

- (id)init
{
    if (self = [super init])
    {
        self.defaultCachePrivate = YES;
    }
    
    return self;
}

- (id)initWithRequest:(HTTPRequest *)request
{
    if (self = [super init])
    {
        self.currentRequest = [request copy];
        
        self.defaultCachePrivate = YES;
    }
    
    return self;
}

- (void)run
{
    if (self.cacheLoadEnable)
    {
        HTTPCachingResponseLoader *cacheLoader = [[HTTPCachingResponseLoader alloc] init];
        
        cacheLoader.account = self.account;
        
        cacheLoader.request = self.currentRequest;
        
        cacheLoader.defaultPrivateAccount = self.defaultCachePrivate;
        
        self.cachedResponse = [cacheLoader response];
        
        if (self.cachedResponse)
        {
            if (self.cachedResponse.expireDate && [self.cachedResponse.expireDate timeIntervalSinceNow] >= 0)
            {
                self.response = self.cachedResponse.response;
                
                if (self.customOutputStream && [self.response.bodyStream isKindOfClass:[DataOutputStream class]])
                {
                    NSData *data = [(DataOutputStream *)self.response.bodyStream data];
                    
                    [self.customOutputStream writeData:data];
                }
                
                [self finishWithCode:HTTPLoadCode_OK];
                
                return;
            }
            
            NSMutableDictionary *requestHeaderFields = [NSMutableDictionary dictionaryWithDictionary:self.currentRequest.headerFields];
            
            NSDictionary *cachedResponseHeaderFields = [self.cachedResponse.response.URLResponse allHeaderFields];
            
            NSString *lastModifiedString = [cachedResponseHeaderFields objectForKey:@"Last-Modified"];
            
            if (lastModifiedString)
            {
                [requestHeaderFields setObject:lastModifiedString forKey:@"If-Modified-Since"];
            }
            
            NSString *Etag = [cachedResponseHeaderFields objectForKey:@"ETag"];
            
            if (Etag)
            {
                [requestHeaderFields setObject:Etag forKey:@"If-None-Match"];
            }
            
            self.currentRequest.headerFields = requestHeaderFields;
        }
    }
    
    self.transaction = [[HTTPTransaction alloc] initWithRequest:self.currentRequest];
    
    self.transaction.delegate = self;
    
    [self.transaction run];
}

- (void)cancel
{
    self.transaction.delegate = nil;
    
    [self.transaction cancel];
    
    self.transaction = nil;
}

- (void)finishWithCode:(HTTPLoadCode)code
{
    HTTPResponse *finishResponse = self.response;
    
    [self cancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPLoader:didFinishWithCode:response:)])
    {
        [self.delegate HTTPLoader:self didFinishWithCode:code response:finishResponse];
    }
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didFinishWithCode:(HTTPTransactionCode)code
{
    HTTPLoadCode loadCode = [HTTPLoadCodeSwitcher HTTPLoadCodeOfHTTPTransactionCode:code withReferencedURLResponse:self.response.URLResponse];
    
    if (code == HTTPTransactionCode_OK)
    {
        if (!self.customOutputStream)
        {
            NSInteger statusCode = [self.response.URLResponse statusCode];
            
            HTTPCachingResponseLoader *cacheLoader = [[HTTPCachingResponseLoader alloc] init];
            
            cacheLoader.account = self.account;
            
            cacheLoader.request = self.currentRequest;
            
            cacheLoader.defaultPrivateAccount = self.defaultCachePrivate;
            
            if (statusCode == 301 || statusCode == 302 || statusCode == 305)
            {
                self.response.bodyStream = nil;
                
                HTTPCachedResponse *newCachedResponse = [[HTTPCachedResponse alloc] init];
                
                newCachedResponse.response = self.response;
                
                newCachedResponse.expireDate = [self.response.URLResponse expireDate];
                
                [cacheLoader saveResponse:newCachedResponse];
            }
            else if (statusCode == 303)
            {
                [cacheLoader removeResponse];
            }
            else if (statusCode == 304)
            {
                NSDate *expireDate = [self.response.URLResponse expireDate];
                
                if (expireDate)
                {
                    self.cachedResponse.expireDate = expireDate;
                }
                
                self.response = self.cachedResponse.response;
                
                [cacheLoader saveResponse:self.cachedResponse];
                
                loadCode = HTTPLoadCode_OK;
            }
            else if (statusCode == 307)
            {
                if ([self.response.URLResponse expireDate])
                {
                    self.response.bodyStream = nil;
                    
                    HTTPCachedResponse *newCachedResponse = [[HTTPCachedResponse alloc] init];
                    
                    newCachedResponse.response = self.response;
                    
                    newCachedResponse.expireDate = [self.response.URLResponse expireDate];
                    
                    [cacheLoader saveResponse:newCachedResponse];
                }
                else
                {
                    [cacheLoader removeResponse];
                }
            }
            else if (statusCode == 200)
            {
                BOOL passLocalAuthentication = YES;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPLoader:canPassLocalAuthenticationWithResponse:)])
                {
                    passLocalAuthentication = [self.delegate HTTPLoader:self canPassLocalAuthenticationWithResponse:self.response];
                }
                
                if (passLocalAuthentication)
                {
                    HTTPCachedResponse *newCachedResponse = [[HTTPCachedResponse alloc] init];
                    
                    newCachedResponse.response = self.response;
                    
                    newCachedResponse.expireDate = [self.response.URLResponse expireDate];
                    
                    [cacheLoader saveResponse:newCachedResponse];
                }
                else
                {
                    loadCode = HTTPLoadCode_AuthenticationFailed;
                }
            }
        }
    }
    else
    {
        self.response.bodyStream = nil;
    }
    
    [self finishWithCode:loadCode];
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse
{
    self.response = [[HTTPResponse alloc] init];
    
    self.response.URLResponse = URLResponse;
    
    NSInteger statusCode = [URLResponse statusCode];
    
    if (statusCode == 301 || statusCode == 302 || statusCode == 305)
    {
        
    }
    else if (statusCode == 303)
    {
        
    }
    else if (statusCode == 304)
    {
        
    }
    else if (statusCode == 307)
    {
        
    }
    else
    {
        self.response.bodyStream = self.customOutputStream ? self.customOutputStream : [[DataOutputStream alloc] init];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPLoader:didReceiveURLResponse:)])
    {
        [self.delegate HTTPLoader:self didReceiveURLResponse:URLResponse];
    }
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didReceiveResponseBodyData:(NSData *)data
{
    [self.response.bodyStream writeData:data];
    
    if (!self.customOutputStream && self.delegate && [self.delegate respondsToSelector:@selector(HTTPLoader:didReceiveResponseBodySize:)])
    {
        [self.delegate HTTPLoader:self didReceiveResponseBodySize:[(DataOutputStream *)self.response.bodyStream dataSize]];
    }
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPLoader:didSendRequestBodyData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPLoader:self didSendRequestBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

@end
