//
//  HTTPDownloader.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPDownloader.h"
#import "HTTPTempResource.h"
#import "HTTPTempResourceResponse.h"

@interface HTTPDownloader ()

@property (nonatomic) HTTPDownloadRequest *originalRequest;

@property (nonatomic) HTTPDownloadRequest *currentRequest;

@property (nonatomic) HTTPTransaction *transaction;

@property (nonatomic) HTTPTempResourceResponse *tempResourceResponse;

@property (nonatomic) HTTPResponse *response;

@property (nonatomic) NSFileManager *fm;

- (void)finishWithCode:(HTTPLoadCode)code;

- (BOOL)isResource:(NSString *)resourcePath overWithURLResponse:(NSHTTPURLResponse *)URLResponse;

@end


@implementation HTTPDownloader

- (id)initWithRequest:(HTTPDownloadRequest *)request
{
    if (self = [super init])
    {
        self.originalRequest = request;
        
        self.currentRequest = [request copy];
        
        self.fm = [[NSFileManager alloc] init];
    }
    
    return self;
}

- (void)run
{
    if (!self.currentRequest.savingPath)
    {
        [self finishWithCode:HTTPLoadCode_InvalidDownload];
        
        return;
    }
    
    if (self.resumeEnable && [self.fm fileExistsAtPath:self.currentRequest.savingPath])
    {
        self.tempResourceResponse = [[HTTPTempResource sharedInstance] responseForDownloadRequest:self.currentRequest ofAccount:self.account];
        
        if (self.tempResourceResponse)
        {
            NSInteger statusCode = [self.tempResourceResponse.URLResponse statusCode];
            
            if (statusCode == 200 || statusCode == 206)
            {
                if (self.tempResourceResponse.expireDate && [self.tempResourceResponse.expireDate timeIntervalSinceNow] >= 0)
                {
                    if ([self isResource:self.currentRequest.savingPath overWithURLResponse:self.tempResourceResponse.URLResponse])
                    {
                        self.response = [[HTTPResponse alloc] init];
                        
                        self.response.URLResponse = self.tempResourceResponse.URLResponse;
                        
                        self.response.bodyStream = [[FileOutputStream alloc] initWithFilePath:self.currentRequest.savingPath];
                        
                        [self finishWithCode:HTTPLoadCode_OK];
                        
                        return;
                    }
                }
                else
                {
                    NSMutableDictionary *requestHeaderFields = [NSMutableDictionary dictionaryWithDictionary:self.currentRequest.headerFields];
                    
                    NSDictionary *cachedResponseHeaderFields = [self.tempResourceResponse.URLResponse allHeaderFields];
                    
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
                    
                    [requestHeaderFields setObject:[NSString stringWithFormat:@"bytes=%lld-", [[self.fm attributesOfItemAtPath:self.currentRequest.savingPath error:nil] fileSize]] forKey:@"Range"];
                    
                    self.currentRequest.headerFields = requestHeaderFields;
                }
            }
        }
        else
        {
            [self.fm removeItemAtPath:self.currentRequest.savingPath error:nil];
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didFinishWithCode:response:)])
    {
        [self.delegate HTTPDownloader:self didFinishWithCode:code response:finishResponse];
    }
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didFinishWithCode:(HTTPTransactionCode)code
{
    HTTPLoadCode loadCode = [HTTPLoadCodeSwitcher HTTPLoadCodeOfHTTPTransactionCode:code withReferencedURLResponse:self.response.URLResponse];
    
    if (code == HTTPTransactionCode_OK)
    {
        NSInteger statusCode = [self.response.URLResponse statusCode];
        
        if (statusCode == 301 || statusCode == 302 || statusCode == 305)
        {
            self.response.bodyStream = nil;
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
        else if (statusCode == 200)
        {
            if (![self isResource:self.currentRequest.savingPath overWithURLResponse:self.response.URLResponse])
            {
                loadCode = HTTPLoadCode_Unknown;
                
                self.response.bodyStream = nil;
            }
        }
        else if (statusCode == 206)
        {
            if ([self isResource:self.currentRequest.savingPath overWithURLResponse:self.response.URLResponse])
            {
                loadCode = HTTPLoadCode_OK;
            }
            else
            {
                self.response.bodyStream = nil;
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
        HTTPTempResourceResponse *newTempResourceResponse = [[HTTPTempResourceResponse alloc] init];
        
        newTempResourceResponse.URLResponse = self.response.URLResponse;
        
        newTempResourceResponse.expireDate = [self.response.URLResponse expireDate];
        
        [[HTTPTempResource sharedInstance] saveResponse:newTempResourceResponse forDownloadRequest:self.currentRequest ofAccount:self.account];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
        }
    }
    else if (statusCode == 303)
    {
        [[HTTPTempResource sharedInstance] removeResponseForDownloadRequest:self.currentRequest ofAccount:self.account];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
        }
    }
    else if (statusCode == 304)
    {
        NSDate *expireDate = [self.response.URLResponse expireDate];
        
        if (expireDate)
        {
            self.tempResourceResponse.expireDate = expireDate;
        }
        
        self.response.URLResponse = self.tempResourceResponse.URLResponse;
        
        [[HTTPTempResource sharedInstance] saveResponse:self.tempResourceResponse forDownloadRequest:self.currentRequest ofAccount:self.account];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
        }
    }
    else if (statusCode == 307)
    {
        if ([self.response.URLResponse expireDate])
        {
            HTTPTempResourceResponse *newTempResourceResponse = [[HTTPTempResourceResponse alloc] init];
            
            newTempResourceResponse.URLResponse = self.response.URLResponse;
            
            newTempResourceResponse.expireDate = [self.response.URLResponse expireDate];
            
            [[HTTPTempResource sharedInstance] saveResponse:newTempResourceResponse forDownloadRequest:self.currentRequest ofAccount:self.account];
        }
        else
        {
            [[HTTPTempResource sharedInstance] removeResponseForDownloadRequest:self.currentRequest ofAccount:self.account];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
        }
    }
    else if (statusCode == 200 || statusCode == 206)
    {
        BOOL passLocalAuthentication = YES;
        
        self.response.bodyStream = [[FileOutputStream alloc] initWithFilePath:self.currentRequest.savingPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:canPassLocalAuthenticationWithResponse:)])
        {
            passLocalAuthentication = [self.delegate HTTPDownloader:self canPassLocalAuthenticationWithResponse:self.response];
        }
        
        if (passLocalAuthentication)
        {
            HTTPTempResourceResponse *newTempResourceResponse = [[HTTPTempResourceResponse alloc] init];
            
            newTempResourceResponse.URLResponse = self.response.URLResponse;
            
            newTempResourceResponse.expireDate = [self.response.URLResponse expireDate];
            
            [[HTTPTempResource sharedInstance] saveResponse:newTempResourceResponse forDownloadRequest:self.currentRequest ofAccount:self.account];
            
            if (statusCode == 200)
            {
                [(FileOutputStream *)self.response.bodyStream resetOutput];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
            {
                [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
            }
        }
        else
        {
            self.response.bodyStream = nil;
            
            [self finishWithCode:HTTPLoadCode_AuthenticationFailed];
        }
    }
    else
    {
        self.response.bodyStream = [[FileOutputStream alloc] initWithFilePath:self.currentRequest.savingPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloader:self didReceiveURLResponse:URLResponse];
        }
    }
}

- (void)HTTPTransaction:(HTTPTransaction *)transaction didReceiveResponseBodyData:(NSData *)data
{
    [self.response.bodyStream writeData:data];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloader:didReceiveResponseBodySize:)])
    {
        [self.delegate HTTPDownloader:self didReceiveResponseBodySize:[(FileOutputStream *)self.response.bodyStream fileSize]];
    }
}

- (BOOL)isResource:(NSString *)resourcePath overWithURLResponse:(NSHTTPURLResponse *)URLResponse
{
    unsigned long long totalSize = [URLResponse rawContentLength];
    
    if (totalSize == 0)
    {
        totalSize = self.currentRequest.referenceSize;
    }
    
    return (totalSize > 0) ? ([[self.fm attributesOfItemAtPath:resourcePath error:nil] fileSize] >= totalSize) : YES;
}

@end
