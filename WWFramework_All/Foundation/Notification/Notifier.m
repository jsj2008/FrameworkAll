//
//  Notifier.m
//  FoundationProject
//
//  Created by Baymax on 13-12-25.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "Notifier.h"
#import "VoidBlockLoader.h"

@implementation Notifier

+ (void)notify:(void (^)())notification
{
    [Notifier notify:notification onThread:[NSThread currentThread]];
}

+ (void)notify:(void (^)())notification onThread:(NSThread *)thread
{
    VoidBlockLoader *loader = [[VoidBlockLoader alloc] initWithBlock:notification];
    
    NSThread *notifyingThread = thread ? thread : [NSThread currentThread];
    
    if ([notifyingThread isExecuting])
    {
        [loader performSelector:@selector(exeBlock) onThread:notifyingThread withObject:nil waitUntilDone:NO];
    }
}

@end
