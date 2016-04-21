//
//  NotificationObservingSet.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "NotificationObservingSet.h"

@implementation NotificationObservingSet

- (id)init
{
    if (self = [super init])
    {
        self.observers = [NSMutableArray array];
    }
    
    return self;
}

- (void)notify:(void (^)(id))notification onThread:(NSThread *)thread
{
    for (NotificationObserver *observer in self.observers)
    {
        [observer notify:notification onThread:thread];
    }
}

@end
