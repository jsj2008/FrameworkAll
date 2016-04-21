//
//  SPTaskServiceProvider.m
//  FoundationProject
//
//  Created by Baymax on 14-1-3.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "SPTaskServiceProvider.h"
#import "SPTaskDaemonPool.h"
#import "SPTaskFreePool.h"
#import "SPTaskBackgroundPool.h"
#import "SPTaskConfiguration.h"

@implementation SPTaskServiceProvider

+ (SPTaskServiceProvider *)sharedInstance
{
    static SPTaskServiceProvider *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskServiceProvider alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    [[SPTaskDaemonPool sharedInstance] startWithPersistentQueueCount:[SPTaskConfiguration sharedInstance].daemonPoolPersistentQueueCapacity];
    
    [[SPTaskFreePool sharedInstance] start];
    
    [[SPTaskBackgroundPool sharedInstance] start];
}

- (void)stop
{
    [[SPTaskDaemonPool sharedInstance] stop];
    
    [[SPTaskFreePool sharedInstance] stop];
    
    [[SPTaskBackgroundPool sharedInstance] stop];
}

@end
