//
//  SPTaskConfiguration.m
//  FoundationProject
//
//  Created by Baymax on 13-12-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskConfiguration.h"

@implementation SPTaskConfiguration

- (id)init
{
    if (self = [super init])
    {
        self.daemonPoolCapacity = 5;
        
        self.daemonPoolPersistentQueueCapacity = 2;
        
        self.freePoolCapacity = 20;
        
        self.backgroundPoolCapacity = 10;
        
        self.defaultQueueLoadingLimit = 20;
    }
    
    return self;
}

+ (SPTaskConfiguration *)sharedInstance
{
    static SPTaskConfiguration *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskConfiguration alloc] init];
        }
    });
    
    return instance;
}

@end
