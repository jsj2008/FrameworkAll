//
//  SPTaskPool.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskPool.h"

@implementation SPTaskPool

- (void)dealloc
{
    [self stop];
    
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
        
        _taskQueues = [[NSMutableArray alloc] initWithCapacity:3];
        
        self.poolCapacity = 3;
    }
    
    return self;
}

- (void)start
{
    _stop = NO;
}

- (void)stop
{
    _stop = YES;
    
    dispatch_sync(_syncQueue, ^{
        
        for (SPTaskQueue *queue in _taskQueues)
        {
            queue.owner = nil;
            
            [queue cancel];
        }
        
        [_taskQueues removeAllObjects];
    });
}

- (void)stopTaskQueue:(SPTaskQueue *)queue
{
    if (!_stop)
    {
        dispatch_sync(_syncQueue, ^{
            
            if ([_taskQueues containsObject:queue])
            {
                queue.owner = nil;
                
                [queue cancel];
                
                [_taskQueues removeObject:queue];
            }
        });
    }
}

- (NSUInteger)currentPoolVolume
{
    __block NSUInteger volume = 0;
    
    dispatch_sync(_syncQueue, ^{
        
        volume = [_taskQueues count];
    });
    
    return volume;
}

- (BOOL)addTasks:(NSArray<SPTask *> *)tasks
{
    return NO;
}

- (BOOL)isOverLoaded
{
    __block BOOL isOverLoaded = NO;
    
    dispatch_sync(_syncQueue, ^{
        
        NSUInteger overLoadCount = 0;
        
        for (SPTaskQueue *queue in _taskQueues)
        {
            if ([queue isOverLoaded])
            {
                overLoadCount ++;
            }
        }
        
        isOverLoaded = (overLoadCount == [_taskQueues count]);
    });
    
    return isOverLoaded;
}

- (void)SPTaskQueueDidFinish:(SPTaskQueue *)queue
{
    dispatch_sync(_syncQueue, ^{
        
        if ([_taskQueues containsObject:queue])
        {
            queue.owner = nil;
            
            [_taskQueues removeObject:queue];
        }
    });
}

@end


NSString * const SPTaskPoolThreadDictionaryKey_Identifier = @"task_pool_identifier";
