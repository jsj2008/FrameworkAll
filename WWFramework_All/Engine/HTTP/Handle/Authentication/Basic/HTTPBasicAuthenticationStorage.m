//
//  HTTPBasicAuthenticationStorage.m
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPBasicAuthenticationStorage.h"

@interface HTTPBasicAuthenticationStorage ()
{
    NSMutableDictionary *_creditials;
    
    dispatch_queue_t _syncQueue;
}

- (NSString *)cacheIndexOfHost:(NSString *)host account:(HTTPAccount *)account;

@end


@implementation HTTPBasicAuthenticationStorage

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _creditials = [[NSMutableDictionary alloc] init];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

+ (HTTPBasicAuthenticationStorage *)sharedInstance
{
    static HTTPBasicAuthenticationStorage *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPBasicAuthenticationStorage alloc] init];
        }
    });
    
    return instance;
}

- (void)saveCreditial:(HTTPBasicCreditial *)creditial forAuthenticationHeaderField:(NSString *)headerField ofHost:(NSString *)host account:(HTTPAccount *)account
{
    NSString *index = [self cacheIndexOfHost:host account:account];
    
    if (index && creditial && headerField)
    {
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *creditials = [_creditials objectForKey:index];
            
            if ([creditials count])
            {
                [creditials setObject:creditial forKey:headerField];
            }
            else
            {
                creditials = [NSMutableDictionary dictionaryWithObject:creditial forKey:headerField];
                
                [_creditials setObject:creditials forKey:index];
            }
        });
    }
}

- (HTTPBasicCreditial *)creditialForAuthenticationHeaderField:(NSString *)headerField ofHost:(NSString *)host account:(HTTPAccount *)account
{
    __block HTTPBasicCreditial *creditial = nil;
    
    NSString *index = [self cacheIndexOfHost:host account:account];
    
    if (index && headerField)
    {
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *creditials = [_creditials objectForKey:index];
            
            creditial = [creditials objectForKey:headerField];
        });
    }
    
    return creditial;
}

- (NSDictionary<NSString *,HTTPBasicCreditial *> *)creditialsOfHost:(NSString *)host account:(HTTPAccount *)account
{
    NSMutableDictionary *creditials = [NSMutableDictionary dictionary];
    
    NSString *index = [self cacheIndexOfHost:host account:account];
    
    if (index)
    {
        dispatch_sync(_syncQueue, ^{
            
            [creditials addEntriesFromDictionary:[_creditials objectForKey:index]];
        });
    }
    
    return [creditials count] ? creditials : nil;
}

- (NSString *)cacheIndexOfHost:(NSString *)host account:(HTTPAccount *)account
{
    return [NSString stringWithFormat:@"%@%@%@%d", host, account.accountId, account.password, account.accountType];
}

@end
