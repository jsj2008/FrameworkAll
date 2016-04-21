//
//  Task.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTask.h"
#import "SPTaskQueue.h"
#import "SPTaskBlockLoader.h"

@interface SPTask ()

/*!
 * @brief 运行线程
 */
@property (nonatomic) NSThread *mainThread;

@end


@implementation SPTask

- (id)init
{
    if (self = [super init])
    {
        self.loadSize = 0;
        
        self.runStatus = SPTaskRunStatus_Prepare;
        
        self.dispatcher = [[SPTaskDispatcher alloc] init];
    }
    
    return self;
}

- (NSThread *)runningThread
{
    return self.mainThread;
}

- (NSUInteger)totalLoadSize
{
    return (self.loadSize + [self.dispatcher syncTaskLoads]);
}

- (void)main
{
    self.runStatus = SPTaskRunStatus_Running;
    
    self.mainThread = [NSThread currentThread];
    
    [self run];
}

- (void)run
{
    
}

- (void)cancel
{
    [self.dispatcher cancel];
    
    self.dispatcher = nil;
    
    self.runStatus = SPTaskRunStatus_Finish;
}

- (void)notify:(void (^)(void))notification
{
    [self notify:notification onThread:self.notifyThread];
}

- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread
{
    if (!thread)
    {
        notification();
    }
    else if ([thread isExecuting])
    {
        SPTaskBlockLoader *blockLoader = [[SPTaskBlockLoader alloc] initWithBlock:notification];
        
        [blockLoader performSelector:@selector(exeBlock) onThread:thread withObject:nil waitUntilDone:NO];
    }
}

@end
