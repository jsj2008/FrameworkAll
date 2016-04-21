//
//  SPTaskDaemonPool.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskDaemonPool.h"
#import "SPTaskConfiguration.h"

@interface SPTaskDaemonPool ()

/*!
 * @brief 队列按负载排序（升序）
 * @param queues 原始队列
 * @result 排序后的队列
 */
- (NSArray *)sortedQueuesByLoadSizeOfQueues:(NSArray *)queues;

@end


@implementation SPTaskDaemonPool

- (id)init
{
    if (self = [super init])
    {
        self.poolCapacity = [SPTaskConfiguration sharedInstance].daemonPoolCapacity;
    }
    
    return self;
}

+ (SPTaskDaemonPool *)sharedInstance
{
    static SPTaskDaemonPool *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SPTaskDaemonPool alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    _stop = NO;
}

- (void)startWithPersistentQueueCount:(NSUInteger)count
{
    [self start];
    
    dispatch_sync(_syncQueue, ^{
        
        NSUInteger queueCount = MIN(count, self.poolCapacity);
        
        for (int i = 0; i < queueCount; i ++)
        {
            SPTaskQueue *queue = [[SPTaskQueue alloc] initWithRunMode:SPTaskQueueRunMode_Persistent];
            
            queue.owner = self;
            
            [_taskQueues addObject:queue];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSThread *thread = [NSThread currentThread];
                
                [thread.threadDictionary setObject:SPTaskDaemonPoolThreadIdentifier forKey:SPTaskPoolThreadDictionaryKey_Identifier];
                
                [queue run];
            });
        }
    });
}

- (BOOL)addTasks:(NSArray<SPTask *> *)tasks
{
    if (_stop)
    {
        return NO;
    }
    
    __block BOOL success = NO;
    
    dispatch_sync(_syncQueue, ^{
        
        NSMutableArray *notOverLoadedQueues = [NSMutableArray array];
        
        for (SPTaskQueue *queue in _taskQueues)
        {
            if (![queue isOverLoaded])
            {
                [notOverLoadedQueues addObject:queue];
            }
        }
        
        // 有未超负荷的队列，在其中负载最轻的队列上添加task
        if ([notOverLoadedQueues count])
        {
            NSArray *sortedQueues = [self sortedQueuesByLoadSizeOfQueues:notOverLoadedQueues];
            
            for (SPTaskQueue *queue in sortedQueues)
            {
                if ((success = [queue addTasks:tasks]))
                {
                    break;
                }
            }
        }
        
        if (!success)
        {
            // 队列未满，创建新队列添加task
            if ([_taskQueues count] < self.poolCapacity)
            {
                SPTaskQueue *queue = [[SPTaskQueue alloc] init];
                
                queue.owner = self;
                
                success = [queue addTasks:tasks];
                
                [_taskQueues addObject:queue];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSThread *thread = [NSThread currentThread];
                    
                    [thread.threadDictionary setObject:SPTaskDaemonPoolThreadIdentifier forKey:SPTaskPoolThreadDictionaryKey_Identifier];
                    
                    [queue run];
                });
            }
            // 队列已满，强行在超负荷的队列中添加task
            else
            {
                NSArray *sortedQueues = [self sortedQueuesByLoadSizeOfQueues:_taskQueues];
                
                for (SPTaskQueue *queue in sortedQueues)
                {
                    if ((success = [queue addTasks:tasks]))
                    {
                        break;
                    }
                }
            }
        }
        
        // 一般来说，到本步仍无法添加成功的，是因为所有的队列正在执行结束工作，此时可以创建新队列添加task，即使超过队列容量，队列容量也会很快恢复
        if (!success)
        {
            SPTaskQueue *queue = [[SPTaskQueue alloc] init];
            
            queue.owner = self;
            
            success = [queue addTasks:tasks];
            
            [_taskQueues addObject:queue];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSThread *thread = [NSThread currentThread];
                
                [thread.threadDictionary setObject:SPTaskDaemonPoolThreadIdentifier forKey:SPTaskPoolThreadDictionaryKey_Identifier];
                
                [queue run];
            });
        }
    });
    
    return success;
}

- (NSArray *)sortedQueuesByLoadSizeOfQueues:(NSArray *)queues
{
    return [queues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        SPTaskQueue *queue1 = obj1;
        SPTaskQueue *queue2 = obj2;
        
        if ([queue1 loads] < [queue2 loads])
        {
            return NSOrderedAscending;
        }
        else if ([queue1 loads] > [queue2 loads])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
}

@end


NSString * const SPTaskDaemonPoolThreadIdentifier = @"daemon_pool";
