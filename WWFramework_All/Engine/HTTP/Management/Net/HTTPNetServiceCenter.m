//
//  HTTPNetServiceCenter.m
//  Application
//
//  Created by Baymax on 14-2-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPNetServiceCenter.h"
#import "HTTPTransaction.h"

@interface HTTPNetServiceCenter ()
{
    BOOL _stop;
    
    BOOL _serviceAvailable;
    
    NSMutableArray *_transactions;
    
    dispatch_queue_t _syncQueue;
}

@end


@implementation HTTPNetServiceCenter

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _transactions = [[NSMutableArray alloc] init];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

+ (HTTPNetServiceCenter *)sharedInstance
{
    static HTTPNetServiceCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPNetServiceCenter alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    _stop = NO;
}

- (void)stop
{
    _stop = YES;
}

- (void)updateNetService
{
    if (_stop)
    {
        return;
    }
    
    BOOL serviceAvailable = YES;
    
    if (self.serviceCheckOperation)
    {
        serviceAvailable = self.serviceCheckOperation();
    }
    
    _serviceAvailable = serviceAvailable;
    
    if (!_serviceAvailable)
    {
        dispatch_sync(_syncQueue, ^{
            
            for (HTTPTransaction *transaction in _transactions)
            {
                [transaction finishByNetServiceUnavailable];
            }
            
            [_transactions removeAllObjects];
        });
    }
}

- (BOOL)addTransaction:(HTTPTransaction *)transaction
{
    BOOL success = NO;
    
    if (!_stop)
    {
        dispatch_sync(_syncQueue, ^{
            
            [_transactions addObject:transaction];
        });
        
        success = YES;
    }
    
    return success;
}

- (void)removeTransaction:(HTTPTransaction *)transaction
{
    dispatch_sync(_syncQueue, ^{
        
        [_transactions removeObject:transaction];
    });
}

@end
