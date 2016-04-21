//
//  ResourceLoadTask.m
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "ResourceLoadTask.h"
#import "HTTPResourceRequest.h"

@interface ResourceLoadTask ()

@property (nonatomic) HTTPGetLoadHandle *HTTPHandle;

- (void)finishWithCode:(ResourceLoadCode)code content:(NSData *)content;

@end


@implementation ResourceLoadTask

@synthesize request = _request;

- (id)initWithRequest:(ResourceRequest *)request
{
    if (self = [super init])
    {
        _request = request;
    }
    
    return self;
}

- (void)run
{
    NSURL *URL = _request.URL;
    
    if ([URL isFileURL])
    {
        NSData *content = [NSData dataWithContentsOfFile:[URL path]];
        
        [self finishWithCode:ResourceLoadCode_OK content:content];
    }
    else if (([URL.scheme isEqualToString:@"http"] || [URL.scheme isEqualToString:@"https"]) && [_request isKindOfClass:[HTTPResourceRequest class]])
    {
        HTTPResourceRequest *request = (HTTPResourceRequest *)_request;
        
        HTTPGetLoadHandle *handle = [[HTTPGetLoadHandle alloc] initWithURL:request.URL];
        
        handle.account = request.account;
        
        handle.cachePolicy = request.cachePolicy;
        
        handle.timeout = request.timeout;
        
        handle.authenticator = [request.authenticationGenerator authenticator];
        
        handle.delegate = self;
        
        self.HTTPHandle = handle;
        
        [self.HTTPHandle run];
    }
    else
    {
        [self finishWithCode:ResourceLoadCode_InvalidRequest content:nil];
    }
}

- (void)cancel
{
    self.HTTPHandle.delegate = nil;
    
    [self.HTTPHandle cancel];
    
    self.HTTPHandle = nil;
    
    [super cancel];
}

- (void)HTTPGetLoadHandle:(HTTPGetLoadHandle *)handle didFinishWithCode:(HTTPLoadCode)code URLResponse:(NSHTTPURLResponse *)response data:(NSData *)data
{
    if (code == HTTPLoadCode_OK)
    {
        [self finishWithCode:ResourceLoadCode_OK content:data];
    }
    else
    {
        [self finishWithCode:ResourceLoadCode_HTTPLoadFail content:nil];
    }
}

- (void)finishWithCode:(ResourceLoadCode)code content:(NSData *)content
{
    [self cancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resourceLoadTask:didFinishLoadingWithCode:content:)])
    {
        [self.delegate resourceLoadTask:self didFinishLoadingWithCode:code content:content];
    }
}

@end
