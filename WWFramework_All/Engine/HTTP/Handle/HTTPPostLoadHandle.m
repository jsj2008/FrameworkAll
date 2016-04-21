//
//  HTTPPostLoadHandle.m
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPPostLoadHandle.h"
#import "DataOutputStream.h"

@interface HTTPPostLoadHandle ()

@property (nonatomic) NSURL *originalURL;

@property (nonatomic) HTTPRequest *currentRequest;

@property (nonatomic) HTTPAccount *HTTPAccount;

@property (nonatomic) HTTPLoader *loader;

- (void)finishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response;

@end


@implementation HTTPPostLoadHandle

- (id)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        self.originalURL = URL;
        
        self.currentRequest = [[HTTPRequest alloc] init];
        
        self.currentRequest.URL = URL;
        
        self.currentRequest.method = @"POST";
        
        self.timeout = 60;
    }
    
    return self;
}

- (void)run
{
    if (!self.currentRequest.headerFields)
    {
        self.currentRequest.headerFields = self.headerFields;
    }
    
    self.currentRequest.timeout = self.timeout;
    
    self.currentRequest.bodyStream = self.inputStream;
    
    [self.currentRequest.bodyStream resetInput];
    
    self.HTTPAccount = [[HTTPAccount alloc] initWithAccount:self.account];
    
    self.authenticator.request = self.currentRequest;
    
    [self.authenticator start];
    
    [self.authenticator addAuthenticationHeaderFieldsToRequest];
    
    HTTPLoader *postLoader = [[HTTPLoader alloc] initWithRequest:self.currentRequest];
    
    postLoader.account = self.HTTPAccount;
    
    postLoader.delegate = self;
    
    postLoader.defaultCachePrivate = YES;
    
    self.loader = postLoader;
    
    [self.loader run];
}

- (void)cancel
{
    self.loader.delegate = nil;
    
    [self.loader cancel];
    
    self.loader = nil;
}

- (void)finishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response
{
    BOOL shouldRestartLoad = NO;
    
    if (code == HTTPLoadCode_OK || code == HTTPLoadCode_Status)
    {
        NSInteger statusCode = [response.URLResponse statusCode];
        
        if (statusCode == 301 || statusCode == 302 || statusCode == 303 || statusCode == 305 || statusCode == 307)
        {
            NSString *redirectedURLString = [[response.URLResponse allHeaderFields] objectForKey:@"Location"];
            
            self.currentRequest.URL = [NSURL URLWithString:redirectedURLString];
            
            shouldRestartLoad = YES;
        }
        else if (statusCode == 401 || statusCode == 407)
        {
            NSMutableDictionary *requestHeaderFields = [NSMutableDictionary dictionaryWithDictionary:self.currentRequest.headerFields];
            
            NSDictionary *authenticationHeaderFields = [self.authenticator authenticationHeaderFieldsToChallengeURLResponse:response.URLResponse];
            
            if ([authenticationHeaderFields count])
            {
                [requestHeaderFields addEntriesFromDictionary:authenticationHeaderFields];
                
                self.currentRequest.headerFields = requestHeaderFields;
                
                shouldRestartLoad = YES;
            }
        }
    }
    
    [self cancel];
    
    if (shouldRestartLoad)
    {
        [self run];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPPostLoadHandle:didFinishWithCode:URLResponse:data:)])
        {
            NSHTTPURLResponse *URLResponse = response.URLResponse;
            
            NSData *data = [response.bodyStream isKindOfClass:[DataOutputStream class]] ? [(DataOutputStream *)response.bodyStream data] : nil;
            
            [self.delegate HTTPPostLoadHandle:self didFinishWithCode:code URLResponse:URLResponse data:data];
        }
    }
}

- (void)HTTPLoader:(HTTPLoader *)loader didFinishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response
{
    [self finishWithCode:code response:response];
}

- (void)HTTPLoader:(HTTPLoader *)loader didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPPostLoadHandle:didPostData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPPostLoadHandle:self didPostData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (BOOL)HTTPLoader:(HTTPLoader *)loader canPassLocalAuthenticationWithResponse:(HTTPResponse *)response
{
    return self.authenticator ? [self.authenticator canResponsePassLocalAuthencation:response] : YES;
}

- (void)HTTPLoader:(HTTPLoader *)loader didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse
{
    [self.authenticator saveCookieFromURLResponse:URLResponse];
}

@end
