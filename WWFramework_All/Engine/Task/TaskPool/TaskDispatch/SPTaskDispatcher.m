//
//  SPTaskDispatcher.m
//  Task
//
//  Created by Baymax on 13-10-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskDispatcher.h"
#import "SPTask.h"
#import "SPTaskDaemonPool.h"
#import "SPTaskFreePool.h"
#import "SPTaskBackgroundPool.h"

#pragma mark - SPTaskQueuedDispatchContext

@interface SPTaskQueuedDispatchContext ()

/*!
 * @brief task
 */
@property (nonatomic) SPTask *task;

/*!
 * @brief 运行模式
 */
@property (nonatomic) SPTaskAsyncRunMode mode;

@end


@implementation SPTaskQueuedDispatchContext

@end


#pragma mark - SPTaskDependence

@implementation SPTaskDependence

@end


#pragma mark - SPTaskDispatcher

@interface SPTaskDispatcher ()
{
    // 异步执行的Task等待队列
    NSMutableArray *_asyncQueuedTaskContexts;
    
    // 异步执行的Task依赖关系
    NSMutableArray *_asyncTaskDependences;
}

/*!
 * @brief 当前任务守护池
 */
@property (nonatomic) SPTaskDaemonPool *currentDaemonTaskPool;

/*!
 * @brief 当前任务自由池
 */
@property (nonatomic) SPTaskFreePool *currentFreeTaskPool;

/*!
 * @brief 当前任务后台池
 */
@property (nonatomic) SPTaskBackgroundPool *currentBackgroundTaskPool;

/*!
 * @brief 按指定模式添加异步任务到任务池并执行
 * @param task 异步任务
 * @param mode 指定模式
 * @result 添加是否成功
 */
- (BOOL)asyncAddTask:(SPTask *)task toTaskPoolInMode:(SPTaskAsyncRunMode)mode;

/*!
 * @brief 运行等候队列中的任务
 */
- (void)runQueuedTasks;

/*!
 * @brief 异步任务是否准备就绪
 * @param task 异步任务
 * @result 依赖解除时返回YES，未解除时返回NO
 */
- (BOOL)isAsyncTaskPreparedToRun:(SPTask *)task;

@end


@implementation SPTaskDispatcher

- (id)init
{
    if (self = [super init])
    {
        _syncTasks = [[NSMutableArray alloc] init];
        
        _asyncTasks = [[NSMutableArray alloc] init];
        
        _asyncQueuedTaskContexts = [[NSMutableArray alloc] init];
        
        _asyncTaskDependences = [[NSMutableArray alloc] init];
        
        self.asyncTaskCapacity = 100;
        
        self.currentDaemonTaskPool = [SPTaskDaemonPool sharedInstance];
        
        self.currentFreeTaskPool = [SPTaskFreePool sharedInstance];
        
        self.currentBackgroundTaskPool = [SPTaskBackgroundPool sharedInstance];
    }
    
    return self;
}

- (void)setDaemonTaskPool:(SPTaskDaemonPool *)pool
{
    self.currentDaemonTaskPool = pool;
}

- (void)setFreeTaskPool:(SPTaskFreePool *)pool
{
    self.currentFreeTaskPool = pool;
}

- (void)setBackgroundTaskPool:(SPTaskBackgroundPool *)pool
{
    self.currentBackgroundTaskPool = pool;
}

- (NSArray<SPTask *> *)allSyncTasks
{
    return [_syncTasks count] ? [NSArray arrayWithArray:_syncTasks] : nil;
}

- (NSArray<SPTask *> *)allAsyncTasks
{
    NSMutableArray *tasks = [NSMutableArray array];
    
    [tasks addObjectsFromArray:_asyncTasks];
    
    for (SPTaskQueuedDispatchContext *context in _asyncQueuedTaskContexts)
    {
        SPTask *task = context.task;
        
        if (task)
        {
            [tasks addObject:task];
        }
    }
    
    return [tasks count] ? tasks : nil;
}

- (NSUInteger)syncTaskLoads
{
    NSUInteger loads = 0;
    
    for (SPTask *task in _syncTasks)
    {
        loads += [task totalLoadSize];
    }
    
    return loads;
}

- (void)syncAddTask:(SPTask *)task
{
    [self syncAddTask:task onNextRunLoop:NO];
}

- (void)syncAddTask:(SPTask *)task onNextRunLoop:(BOOL)on
{
    if (task)
    {
        [_syncTasks addObject:task];
        
        if (on)
        {
            [task performSelector:@selector(main) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        }
        else
        {
            [task main];
        }
    }
}

- (BOOL)asyncAddTask:(SPTask *)task
{
    return [self asyncAddTask:task inMode:SPTaskAsyncRunMode_Daemon];
}

- (BOOL)asyncAddTask:(SPTask *)task inMode:(SPTaskAsyncRunMode)mode
{
    if (!task)
    {
        return YES;
    }
    
    BOOL success = YES;
    
    if (!task.notifyThread)
    {
        task.notifyThread = [NSThread currentThread];
    }
    
    if ([_asyncTasks count] < self.asyncTaskCapacity && [self isAsyncTaskPreparedToRun:task])
    {
        success = [self asyncAddTask:task toTaskPoolInMode:mode];
        
        if (success)
        {
            [_asyncTasks addObject:task];
        }
    }
    else
    {
        SPTaskQueuedDispatchContext *context = [[SPTaskQueuedDispatchContext alloc] init];
        
        context.task = task;
        
        context.mode = mode;
        
        [_asyncQueuedTaskContexts addObject:context];
        
        success = YES;
    }
    
    return success;
}

- (void)addAsyncTaskDependence:(SPTaskDependence *)dependence
{
    BOOL dependenceExist = NO;
    
    for (SPTaskDependence *existingDependence in _asyncTaskDependences)
    {
        if (existingDependence.task == dependence.task)
        {
            [existingDependence.dependedOnTasks addObjectsFromArray:dependence.dependedOnTasks];
            
            dependenceExist = YES;
            
            break;
        }
    }
    
    if (!dependenceExist)
    {
        SPTaskDependence *newDependence = [[SPTaskDependence alloc] init];
        
        newDependence.task = dependence.task;
        
        newDependence.dependedOnTasks = [NSMutableArray arrayWithArray:dependence.dependedOnTasks];
        
        [_asyncTaskDependences addObject:newDependence];
    }
}

- (void)removeAsyncTaskDependence:(SPTaskDependence *)dependence
{
    NSMutableArray *toRemoveDependences = [NSMutableArray array];
    
    for (SPTaskDependence *selfDependence in _asyncTaskDependences)
    {
        if (dependence.task == selfDependence.task)
        {
            [selfDependence.dependedOnTasks removeObjectsInArray:dependence.dependedOnTasks];
            
            if (![selfDependence.dependedOnTasks count])
            {
                [toRemoveDependences addObject:selfDependence];
            }
        }
    }
    
    [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
}

- (void)removeAsyncTaskDependenceOfTask:(SPTask *)task
{
    NSMutableArray *toRemoveDependences = [NSMutableArray array];
    
    for (SPTaskDependence *dependence in _asyncTaskDependences)
    {
        if (dependence.task == task)
        {
            [toRemoveDependences addObject:dependence];
        }
    }
    
    [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
}

- (void)removeTask:(SPTask *)task
{
    if (task)
    {
        if ([_syncTasks containsObject:task])
        {
            task.delegate = nil;
            
            [_syncTasks removeObject:task];
        }
        else if ([_asyncTasks containsObject:task])
        {
            task.delegate = nil;
            
            [_asyncTasks removeObject:task];
            
            if ([_asyncTaskDependences count])
            {
                NSMutableArray *toRemoveDependences = [NSMutableArray array];
                
                for (SPTaskDependence *dependence in _asyncTaskDependences)
                {
                    if (dependence.task == task)
                    {
                        [toRemoveDependences addObject:dependence];
                    }
                    
                    [dependence.dependedOnTasks removeObject:task];
                    
                    if ([dependence.dependedOnTasks count] == 0)
                    {
                        [toRemoveDependences addObject:dependence];
                    }
                }
                
                [_asyncTaskDependences removeObjectsInArray:toRemoveDependences];
            }
            
            [self runQueuedTasks];
        }
    }
}

- (void)cancel
{
    for (SPTask *task in _syncTasks)
    {
        task.delegate = nil;
        
        [task cancel];
    }
    
    [_syncTasks removeAllObjects];
    
    for (SPTask *task in _asyncTasks)
    {
        task.delegate = nil;
        
        // 对于异步任务，这里设置结束标记非常重要，可以帮助task尽快从taskqueue中移除（若未设置结束标记，cancel操作将被放在taskqueue线程中所有未执行的selector之后执行）
        // 若不设置此标记，存在漏洞：在task还未在taskqueue中run之前执行cancel操作，cancel操作将无效
        task.runStatus = SPTaskRunStatus_Finish;
        
        if ([[task runningThread] isExecuting])
        {
            [task performSelector:@selector(cancel) onThread:[task runningThread] withObject:nil waitUntilDone:NO];
        }
    }
    
    [_asyncTasks removeAllObjects];
    
    [_asyncQueuedTaskContexts removeAllObjects];
    
    [_asyncTaskDependences removeAllObjects];
}

- (void)cancelTask:(SPTask *)task
{
    if ([_syncTasks containsObject:task])
    {
        task.delegate = nil;
        
        [task cancel];
    }
    
    if ([_asyncTasks containsObject:task])
    {
        task.delegate = nil;
        
        // 对于异步任务，这里设置结束标记非常重要，可以帮助task尽快从taskqueue中移除（若未设置结束标记，cancel操作将被放在taskqueue线程中所有未执行的selector之后执行）
        // 若不设置此标记，存在漏洞：在task还未在taskqueue中run之前执行cancel操作，cancel操作将无效
        task.runStatus = SPTaskRunStatus_Finish;
        
        if ([[task runningThread] isExecuting])
        {
            [task performSelector:@selector(cancel) onThread:[task runningThread] withObject:nil waitUntilDone:NO];
        }
    }
    
    [self removeTask:task];
}

- (BOOL)asyncAddTask:(SPTask *)task toTaskPoolInMode:(SPTaskAsyncRunMode)mode
{
    BOOL success = YES;
    
    switch (mode)
    {
        case SPTaskAsyncRunMode_Daemon:
        {
            success = [self.currentDaemonTaskPool addTasks:[NSArray arrayWithObject:task]];
            
            break;
        }
            
        case SPTaskAsyncRunMode_ExclusiveThread:
        {
            success = [self.currentFreeTaskPool addTasks:[NSArray arrayWithObject:task]];
            
            break;
        }
            
        case SPTaskAsyncRunMode_Background:
        {
            success = [self.currentBackgroundTaskPool addTasks:[NSArray arrayWithObject:task]];
            
            break;
        }
            
        default:
            break;
    }
    
    return success;
}

- (void)runQueuedTasks
{
    if (([_asyncQueuedTaskContexts count] && [_asyncTasks count] < self.asyncTaskCapacity))
    {
        NSMutableArray *toRemoveContexts = [NSMutableArray array];
        
        for (SPTaskQueuedDispatchContext *context in _asyncQueuedTaskContexts)
        {
            SPTask *task = context.task;
            
            if ([self isAsyncTaskPreparedToRun:task])
            {
                if ([self asyncAddTask:task toTaskPoolInMode:context.mode])
                {
                    [_asyncTasks addObject:task];
                }
                
                [toRemoveContexts addObject:context];
            }
            
            if ([_asyncTasks count] >= self.asyncTaskCapacity)
            {
                break;
            }
        }
        
        [_asyncQueuedTaskContexts removeObjectsInArray:toRemoveContexts];
    }
}

- (BOOL)isAsyncTaskPreparedToRun:(SPTask *)task
{
    BOOL prepared = YES;
    
    for (SPTaskDependence *dependence in _asyncTaskDependences)
    {
        if (dependence.task == task)
        {
            prepared = NO;
            
            break;
        }
    }
    
    return prepared;
}

@end
