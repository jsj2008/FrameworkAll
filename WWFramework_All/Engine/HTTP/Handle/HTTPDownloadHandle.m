//
//  HTTPDownloadHandle.m
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPDownloadHandle.h"

@interface HTTPDownloadHandle ()

@property (nonatomic) NSURL *originalURL;

@property (nonatomic) HTTPDownloadRequest *currentRequest;

@property (nonatomic) HTTPAccount *HTTPAccount;

@property (nonatomic) HTTPDownloader *loader;

@property (nonatomic) BOOL shouldRestartLoad;

- (void)finishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response;

@end


@implementation HTTPDownloadHandle

- (id)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        self.originalURL = URL;
        
        self.currentRequest = [[HTTPDownloadRequest alloc] init];
        
        self.currentRequest.URL = URL;
        
        self.currentRequest.method = @"GET";
        
        self.timeout = 600;
    }
    
    return self;
}

- (void)run
{
    self.shouldRestartLoad = NO;
    
    if (!self.currentRequest.headerFields)
    {
        self.currentRequest.headerFields = self.headerFields;
    }
    
    self.currentRequest.timeout = self.timeout;
    
    self.currentRequest.savingPath = self.resourceSavingPath;
    
    self.currentRequest.referenceSize = self.referencedResourceSize;
    
    self.HTTPAccount = [[HTTPAccount alloc] initWithAccount:self.account];
    
    self.authenticator.request = self.currentRequest;
    
    [self.authenticator start];
    
    [self.authenticator addAuthenticationHeaderFieldsToRequest];
    
    HTTPDownloader *downloader = [[HTTPDownloader alloc] initWithRequest:self.currentRequest];
    
    downloader.account = self.HTTPAccount;
    
    downloader.resumeEnable = self.resumeEnable;
    
    downloader.delegate = self;
    
    self.loader = downloader;
    
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
    if (code == HTTPLoadCode_OK || code == HTTPLoadCode_Status)
    {
        NSInteger statusCode = [response.URLResponse statusCode];
        
        if (statusCode == 301 || statusCode == 302 || statusCode == 303 || statusCode == 305 || statusCode == 307)
        {
            NSString *redirectedURLString = [[response.URLResponse allHeaderFields] objectForKey:@"Location"];
            
            self.currentRequest.URL = [NSURL URLWithString:redirectedURLString];
        }
        else if (statusCode == 401 || statusCode == 407)
        {
            NSMutableDictionary *requestHeaderFields = [NSMutableDictionary dictionaryWithDictionary:self.currentRequest.headerFields];
            
            NSDictionary *authenticationHeaderFields = [self.authenticator authenticationHeaderFieldsToChallengeURLResponse:response.URLResponse];
            
            if ([authenticationHeaderFields count])
            {
                [requestHeaderFields addEntriesFromDictionary:authenticationHeaderFields];
                
                self.currentRequest.headerFields = requestHeaderFields;
            }
        }
    }
    
    [self cancel];
    
    if (self.shouldRestartLoad)
    {
        [self run];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadHandle:didFinishWithCode:URLResponse:dataPath:)])
        {
            NSHTTPURLResponse *URLResponse = response.URLResponse;
            
            NSString *filePath = [response.bodyStream isKindOfClass:[FileOutputStream class]] ? [(FileOutputStream *)response.bodyStream filePath] : nil;
            
            [self.delegate HTTPDownloadHandle:self didFinishWithCode:code URLResponse:URLResponse dataPath:filePath];
        }
    }
}

- (void)HTTPDownloader:(HTTPDownloader *)downloader didFinishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response
{
    [self finishWithCode:code response:response];
}

- (void)HTTPDownloader:(HTTPDownloader *)downloader didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse
{
    [self.authenticator saveCookieFromURLResponse:URLResponse];
    
    NSInteger statusCode = [URLResponse statusCode];
    
    if (statusCode == 301 || statusCode == 302 || statusCode == 303 || statusCode == 305 || statusCode == 307 || statusCode == 401 || statusCode == 407)
    {
        self.shouldRestartLoad = YES;
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadHandle:didReceiveURLResponse:)])
        {
            [self.delegate HTTPDownloadHandle:self didReceiveURLResponse:URLResponse];
        }
    }
}

- (void)HTTPDownloader:(HTTPDownloader *)downloader didReceiveResponseBodySize:(unsigned long long)size
{
    if (!self.shouldRestartLoad)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadHandle:didDownloadResourceSize:)])
        {
            [self.delegate HTTPDownloadHandle:self didDownloadResourceSize:size];
        }
    }
}

- (BOOL)HTTPDownloader:(HTTPDownloader *)downloader canPassLocalAuthenticationWithResponse:(HTTPResponse *)response
{
    return self.authenticator ? [self.authenticator canResponsePassLocalAuthencation:response] : YES;
}

@end
