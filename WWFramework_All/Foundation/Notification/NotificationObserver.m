//
//  NotificationObserver.m
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "NotificationObserver.h"
#import "NotificationBlockLoader.h"

@implementation NotificationObserver

- (void)notify:(void (^)(id))notification onThread:(NSThread *)thread
{
    NotificationBlockLoader *loader = [[NotificationBlockLoader alloc] initWithBlock:notification observer:self.observer];
    
    NSThread *destinationThread = thread ? thread : self.notifyThread;
    
    if (!destinationThread)
    {
        destinationThread = [NSThread currentThread];
    }
    
    if ([destinationThread isExecuting])
    {
        [loader performSelector:@selector(exeBlock) onThread:destinationThread withObject:nil waitUntilDone:NO];
    }
}

@end
