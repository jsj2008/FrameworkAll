//
//  HTTPCookieAuthentication.m
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPCookieLoader.h"
#import "HTTPCookie.h"
#import "HTTPCookieStorage.h"
#import "StringComponent.h"
#import "DateFormat.h"

@implementation HTTPCookieLoader

- (void)saveCookieForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account withURLResponse:(NSHTTPURLResponse *)URLResponse
{
    NSString *cookieString = nil;
    
    BOOL isVersion1 = NO;
    
    NSDictionary *headerFields = [URLResponse allHeaderFields];
    
    cookieString = [headerFields objectForKey:@"Set-Cookie2"];
    
    if (!cookieString)
    {
        cookieString = [headerFields objectForKey:@"Set-Cookie"];
    }
    else
    {
        isVersion1 = YES;
    }
    
    if (cookieString && request && account)
    {
        NSDictionary *components = [cookieString KVedComponentsBySeparator:@";"];
        
        NSMutableDictionary *mcomponents = [NSMutableDictionary dictionaryWithDictionary:components];
        
        [mcomponents removeObjectsForKeys:[NSArray arrayWithObjects:@"expires", @"domain", @"path", @"secure", @"Version", @"Comment", @"CommentURL", @"Discard",@"Domain", @"Max-Age", @"Path", @"Port", @"Secure", nil]];
        
        if ([mcomponents count])
        {
            NSMutableArray *cookies = [NSMutableArray array];
            
            for (NSString *key in [mcomponents allKeys])
            {
                HTTPCookie *cookie = [[HTTPCookie alloc] init];
                
                cookie.properties = components;
                
                cookie.isVersion1 = isVersion1;
                
                cookie.name = key;
                
                cookie.value = [mcomponents objectForKey:key];
                
                [cookies addObject:cookie];
            }
            
            NSDate *responseDate = [NSDate dateWithFormatString:[headerFields objectForKey:@"Date"] byType:DateFormatType_HTTPHeaderDate];
            
            if (!responseDate)
            {
                responseDate = [NSDate date];
            }
            
            unsigned long long maxAge = 0;
            
            NSDate *expireDate = [NSDate dateWithFormatString:[components objectForKey:@"expires"] byType:DateFormatType_HTTPCookieDate];
            
            if (expireDate)
            {
                NSTimeInterval timeInterval = [expireDate timeIntervalSinceDate:responseDate];
                
                maxAge = MAX(timeInterval, 0);
                
                if (maxAge > 0)
                {
                    for (HTTPCookie *cookie in cookies)
                    {
                        cookie.startDate = responseDate;
                        
                        cookie.maxAge = maxAge;
                    }
                }
            }
            
            if (maxAge == 0)
            {
                NSString *maxAgeString = [components objectForKey:@"Max-Age"];
                
                if (maxAgeString)
                {
                    maxAge = [maxAgeString longLongValue];
                    
                    if (maxAge > 0)
                    {
                        for (HTTPCookie *cookie in cookies)
                        {
                            cookie.startDate = responseDate;
                            
                            cookie.maxAge = maxAge;
                        }
                    }
                }
            }
            
            if (maxAge == 0)
            {
                maxAge = ULLONG_MAX;
                
                for (HTTPCookie *cookie in cookies)
                {
                    cookie.startDate = responseDate;
                    
                    cookie.maxAge = maxAge;
                }
            }
            
            [[HTTPCookieStorage sharedInstance] saveCookies:cookies forURL:request.URL ofAccount:account atDate:responseDate];
        }
    }
}

- (NSString *)cookieStringForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account
{
    NSArray *cookies = [[HTTPCookieStorage sharedInstance] cookiesForURL:request.URL ofAccount:account];
    
    NSMutableString *cookieString = [NSMutableString string];
    
    BOOL isHTTPsURL = [[request.URL scheme] isEqualToString:@"https"];
    
    BOOL currentVersion1 = NO;
    
    for (HTTPCookie *cookie in cookies)
    {
        if ([[NSDate date] timeIntervalSinceDate:cookie.startDate] > cookie.maxAge)
        {
            continue;
        }
        
        if ([cookie.properties objectForKey:@"Secure"] && !isHTTPsURL)
        {
            continue;
        }
        
        BOOL isVersion1 = cookie.isVersion1;
        
        if (!currentVersion1)
        {
            if (isVersion1)
            {
                currentVersion1 = YES;
                
                [cookieString setString:@"$Version=\"1\""];
            }
        }
        
        if (currentVersion1 && isVersion1)
        {
            [cookieString appendFormat:@";%@=%@", cookie.name, cookie.value];
            
            NSString *path = [cookie.properties objectForKey:@"Path"];
            
            if (path)
            {
                [cookieString appendFormat:@";$Path=%@", path];
            }
            
            NSString *domain = [cookie.properties objectForKey:@"Domain"];
            
            if (domain)
            {
                [cookieString appendFormat:@";$Domain=%@", domain];
            }
            
            NSString *portString = [cookie.properties objectForKey:@"Port"];
            
            if (portString)
            {
                [cookieString appendFormat:@";$Port=%@", portString];
            }
        }
        else if (!currentVersion1 && !isVersion1)
        {
            [cookieString appendFormat:@";%@=%@", cookie.name, cookie.value];
        }
    }
    
    return cookieString;
}

@end
