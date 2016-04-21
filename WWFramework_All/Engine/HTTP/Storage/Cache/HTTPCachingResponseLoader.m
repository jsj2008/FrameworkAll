//
//  HTTPCachingResponseLoader.m
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPCachingResponseLoader.h"
#import "HTTPCache.h"

@implementation HTTPCachingResponseLoader

- (id)init
{
    if (self = [super init])
    {
        self.defaultPrivateAccount = YES;
    }
    
    return self;
}

- (void)saveResponse:(HTTPCachedResponse *)response
{
    NSString *cacheControl = [[response.response.URLResponse allHeaderFields] objectForKey:@"Cache-Control"];
    
    if (([cacheControl rangeOfString:@"no-store"].location != NSNotFound) || ([cacheControl rangeOfString:@"no-cache"].location != NSNotFound))
    {
        ;
    }
    else
    {
        BOOL private = YES;
        
        if ([cacheControl rangeOfString:@"public"].location != NSNotFound)
        {
            private = NO;
        }
        else if ([cacheControl rangeOfString:@"private"].location != NSNotFound)
        {
            private = YES;
        }
        else
        {
            private = self.defaultPrivateAccount;
        }
        
        if (private)
        {
            [[HTTPCache sharedInstance] saveResponse:response forRequest:self.request ofAccount:self.account];
        }
        else
        {
            [[HTTPCache sharedInstance] saveResponse:response forRequest:self.request ofAccount:[HTTPAccount publicCacheAccount]];
        }
    }
}

- (void)removeResponse
{
    [[HTTPCache sharedInstance] removeResponseForRequest:self.request ofAccount:self.account];
}

- (HTTPCachedResponse *)response
{
    HTTPCachedResponse *response = [[HTTPCache sharedInstance] responseForRequest:self.request ofAccount:self.account];
    
    if (!response)
    {
        response = [[HTTPCache sharedInstance] responseForRequest:self.request ofAccount:[HTTPAccount publicCacheAccount]];
    }
    
    return response;
}

@end
