//
//  HTTPAuthentication.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPAuthenticator.h"
#import "HTTPRequest.h"
#import "HTTPResponse.h"
#import "HTTPCookieLoader.h"

@interface HTTPAuthenticator ()
{
    // 已认证次数
    NSUInteger _authenticatedTimes;
}

/*!
 * @brief cookie加载器
 */
@property (nonatomic) HTTPCookieLoader *cookieLoader;

@end


@implementation HTTPAuthenticator

- (id)init
{
    if (self = [super init])
    {
        self.authenticatedTimes = 1;
        
        self.cookieEnable = !([NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy == NSHTTPCookieAcceptPolicyNever);
    }
    
    return self;
}

- (void)start
{
    for (HTTPAuthentication *authentication in self.authentications)
    {
        authentication.request = self.request;
    }
    
    if (self.cookieEnable)
    {
        self.cookieLoader = [[HTTPCookieLoader alloc] init];
    }
}

- (NSDictionary<NSString *,NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse
{
    NSMutableDictionary *authenticatorHeaderFields = nil;
    
    if (_authenticatedTimes >= self.authenticatedTimes)
    {
        ;
    }
    else
    {
        _authenticatedTimes ++;
        
        authenticatorHeaderFields = [NSMutableDictionary dictionary];
        
        for (HTTPAuthentication *authentication in self.authentications)
        {
            NSDictionary *authenticationHeaderFields = [authentication authenticationHeaderFieldsToChallengeURLResponse:URLResponse];
            
            [authenticatorHeaderFields addEntriesFromDictionary:authenticationHeaderFields];
        }
    }
    
    return [authenticatorHeaderFields count] ? authenticatorHeaderFields : nil;
}

- (BOOL)canResponsePassLocalAuthencation:(HTTPResponse *)response
{
    BOOL can = YES;
    
    for (HTTPAuthentication *authentication in self.authentications)
    {
        can = [authentication canResponsePassLocalAuthencation:response];
        
        if (!can)
        {
            break;
        }
    }
    
    return can;
}

- (void)addAuthenticationHeaderFieldsToRequest
{
    for (HTTPAuthentication *authentication in self.authentications)
    {
        [authentication addAuthenticationHeaderFieldsToRequest];
    }
    
    if (self.cookieLoader && ![self.request.headerFields objectForKey:@"Cookie"])
    {
        NSString *cookieString = [self.cookieLoader cookieStringForRequest:self.request ofAccount:self.account];
        
        if (cookieString)
        {
            NSMutableDictionary *headerFields = [NSMutableDictionary dictionaryWithDictionary:self.request.headerFields];
            
            [headerFields setObject:cookieString forKey:@"Cookie"];
            
            self.request.headerFields = headerFields;
        }
    }
}

- (void)saveCookieFromURLResponse:(NSHTTPURLResponse *)URLResponse
{
    if (self.cookieLoader)
    {
        [self.cookieLoader saveCookieForRequest:self.request ofAccount:self.account withURLResponse:URLResponse];
    }
}

@end
