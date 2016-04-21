//
//  HTTPCookieStorage.m
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPCookieStorage.h"
#import "StringComponent.h"
#import "NSString+CharacterHandle.h"

/*!
 * @brief cookie的默认路径，当Set-Cookie和Set-Cookie2中未指定路径时使用本值
 */
static NSString * const DefaultCookiePath = @"/";

/*!
 * @brief cookie的默认端口，当Set-Cookie和Set-Cookie2中未指定端口时使用本值
 */
static NSString * const DefaultCookiePortString = @"-1";

/*!
 * @brief cookie检索时的账户键
 */
static NSString * const DefaultCookieAccountKey = @"account";

/*!
 * @brief cookie检索时的时间键
 */
static NSString * const DefaultCookieDateKey = @"date";


@interface HTTPCookieStorage ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
}

/*!
 * @brief 当前cookie字典
 */
@property (nonatomic, retain) NSMutableDictionary *currentCookies;

@end


@implementation HTTPCookieStorage

@synthesize currentCookies;

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

+ (HTTPCookieStorage *)sharedInstance
{
    static HTTPCookieStorage *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPCookieStorage alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    dispatch_sync(_syncQueue, ^{
        
        self.currentCookies = [NSMutableDictionary dictionary];
    });
}

- (void)stop
{
    dispatch_sync(_syncQueue, ^{
        
        self.currentCookies = nil;
    });
}

- (void)saveCookies:(NSArray<HTTPCookie *> *)cookies forURL:(NSURL *)URL ofAccount:(HTTPAccount *)account atDate:(NSDate *)date
{
    NSString *identifier = [account identifier];
    
    if ([cookies count] && identifier && date)
    {
        dispatch_sync(_syncQueue, ^{
            
            if (!self.currentCookies)
            {
                return;
            }
            
            for (HTTPCookie *cookie in cookies)
            {
                if ([cookie.properties count])
                {
                    NSString *domain = [cookie.properties objectForKey:@"domain"];
                    
                    if (!domain)
                    {
                        domain = [cookie.properties objectForKey:@"Domain"];
                    }
                    
                    if (!domain)
                    {
                        domain = [URL host];
                    }
                    
                    if (domain)
                    {
                        // 这里必须实时为domain中的cookie更新账户时间，在切换账户时此时间有用
                        
                        NSMutableDictionary *domainCookies = [self.currentCookies objectForKey:domain];
                        
                        NSString *accountIdentifier = [domainCookies objectForKey:DefaultCookieAccountKey];
                        
                        NSDate *accountDate = [domainCookies objectForKey:DefaultCookieDateKey];
                        
                        if (domainCookies && ![accountIdentifier isEqualToString:identifier] && ([accountDate timeIntervalSinceDate:date] < 0))
                        {
                            // 当当前domain的cookie失效时，同时认为当前domain更高层级的domain的cookie也失效
                            
                            NSMutableArray *domains = [NSMutableArray array];
                            
                            NSMutableString *copyedDomain = [NSMutableString stringWithString:domain];
                            
                            NSRange dotRange = [copyedDomain rangeOfString:@"."];
                            
                            while ((dotRange.location != NSNotFound) && ([copyedDomain length]))
                            {
                                [domains addObject:[NSString stringWithString:copyedDomain]];
                                
                                [copyedDomain deleteCharactersInRange:NSMakeRange(0, dotRange.location + 1)];
                            }
                            
                            [self.currentCookies removeObjectsForKeys:domains];
                            
                            domainCookies = nil;
                        }
                        
                        if (!domainCookies)
                        {
                            domainCookies = [NSMutableDictionary dictionary];
                            
                            if (identifier)
                            {
                                [domainCookies setObject:identifier forKey:DefaultCookieAccountKey];
                            }
                            
                            [self.currentCookies setObject:domainCookies forKey:domain];
                        }
                        
                        [domainCookies setObject:date forKey:DefaultCookieDateKey];
                        
                        NSString *path = [cookie.properties objectForKey:@"path"];
                        
                        if (!path)
                        {
                            path = [cookie.properties objectForKey:@"Path"];
                        }
                        
                        if (!path)
                        {
                            path = DefaultCookiePath;
                        }
                        
                        NSMutableDictionary *pathCookies = [domainCookies objectForKey:path];
                        
                        if (!pathCookies)
                        {
                            pathCookies = [NSMutableDictionary dictionary];
                            
                            [domainCookies setObject:pathCookies forKey:path];
                        }
                        
                        NSArray *portStringList = [[(NSString *)[cookie.properties objectForKey:@"Port"] stringByDeletingBothPrefixAndSuffixQuotationMarks] componentsSeparatedByString:@","];
                        
                        if (![portStringList count])
                        {
                            portStringList = [NSArray arrayWithObject:DefaultCookiePortString];
                        }
                        
                        for (NSString *portString in portStringList)
                        {
                            NSMutableDictionary *portCookies = [pathCookies objectForKey:portString];
                            
                            if (!portCookies)
                            {
                                portCookies = [NSMutableDictionary dictionary];
                                
                                [pathCookies setObject:portCookies forKey:portString];
                            }
                            
                            NSString *name = cookie.name;
                            
                            if ([name length])
                            {
                                HTTPCookie *namedCookie = [portCookies objectForKey:name];
                                
                                // 这里需要比较cookie起始时间（考虑服务器响应延迟问题）
                                if (namedCookie)
                                {
                                    if ([cookie.startDate timeIntervalSinceDate:namedCookie.startDate] > 0)
                                    {
                                        [portCookies setObject:cookie forKey:name];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        });
    }
}

- (NSArray<HTTPCookie *> *)cookiesForURL:(NSURL *)URL ofAccount:(HTTPAccount *)account
{
    NSMutableArray *cookies = [NSMutableArray array];
    
    NSString *URLHost = [URL host];
    
    NSString *URLPath = [URL path];
    
    if (![URLPath length])
    {
        URLPath = DefaultCookiePath;
    }
    
    NSNumber *URLPortNumber = [URL port];
    
    NSString *URLPortString = nil;
    
    if (URLPortNumber)
    {
        URLPortString = [URLPortNumber stringValue];
    }
    else
    {
        URLPortString = DefaultCookiePortString;
    }
    
    NSString *identifier = [account identifier];
    
    if (URLHost && identifier)
    {
        NSDate *currentDate = [NSDate date];
        
        dispatch_sync(_syncQueue, ^{
            
            if (!self.currentCookies)
            {
                return;
            }
            
            // 获取cookie时，当前domain和当前domain更高层级的domain均有效
            
            // 获取cookie时，检查cookie有效期，删除过期的cookie
            
            NSMutableArray *domains = [NSMutableArray array];
            
            NSMutableString *copyedHost = [NSMutableString stringWithString:URLHost];
            
            NSRange dotRange = [copyedHost rangeOfString:@"."];
            
            while ((dotRange.location != NSNotFound) && ([copyedHost length]))
            {
                [domains addObject:[NSString stringWithString:copyedHost]];
                
                [copyedHost deleteCharactersInRange:NSMakeRange(0, dotRange.location + 1)];
            }
            
            NSMutableArray *unavailableCookieDomains = [NSMutableArray array];
            
            for (NSString *domain in domains)
            {
                NSMutableDictionary *domainCookies = [self.currentCookies objectForKey:domain];
                
                NSString *accountIdentifier = [domainCookies objectForKey:DefaultCookieAccountKey];
                
                if (domainCookies && ![accountIdentifier isEqualToString:identifier])
                {
                    continue;
                }
                
                NSMutableArray *unavailableCookiePaths = [NSMutableArray array];
                
                for (NSString *path in [domainCookies allKeys])
                {
                    if ([URLPath rangeOfString:path].location != NSNotFound)
                    {
                        NSMutableDictionary *pathCookies = [domainCookies objectForKey:path];
                        
                        NSMutableArray *unavailableCookiePorts = [NSMutableArray array];
                        
                        for (NSString *portString in [pathCookies allKeys])
                        {
                            if ([portString isEqualToString:URLPortString])
                            {
                                NSMutableDictionary *portCookies = [pathCookies objectForKey:portString];
                                
                                NSMutableArray *expiredCookieNames = [NSMutableArray array];
                                
                                for (NSString *name in portCookies)
                                {
                                    HTTPCookie *cookie = [portCookies objectForKey:name];
                                    
                                    if ([currentDate timeIntervalSinceDate:cookie.startDate] <= cookie.maxAge)
                                    {
                                        [cookies addObject:cookie];
                                    }
                                    else
                                    {
                                        [expiredCookieNames addObject:name];
                                    }
                                }
                                
                                if ([expiredCookieNames count])
                                {
                                    [portCookies removeObjectsForKeys:expiredCookieNames];
                                }
                                
                                if (![portCookies count])
                                {
                                    [unavailableCookiePorts addObject:portString];
                                }
                            }
                        }
                        
                        if ([unavailableCookiePorts count])
                        {
                            [pathCookies removeObjectsForKeys:unavailableCookiePorts];
                        }
                        
                        if (![pathCookies count])
                        {
                            [unavailableCookiePaths addObject:path];
                        }
                    }
                }
                
                if ([unavailableCookiePaths count])
                {
                    [domainCookies removeObjectsForKeys:unavailableCookiePaths];
                }
                
                if (![domainCookies count])
                {
                    [unavailableCookieDomains addObject:domain];
                }
            }
            
            if ([unavailableCookieDomains count])
            {
                [self.currentCookies removeObjectsForKeys:unavailableCookieDomains];
            }
        });
    }
    
    return cookies;
}

@end
