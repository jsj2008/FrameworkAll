//
//  SPTaskQueue.m
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskQueue.h"
#import "SPTaskConfiguration.h"

@interface SPTaskQueue ()
{
    // 总负载
    NSUInteger _totalLoads;
    
    // 负载限制
    NSUInteger _totalLoadsLimit;
    
    // 同步队列
    dispatch_queue_t _syncQueue;
}

/*!
 * @brief 运行线程
 */
@property (nonatomic) NSThread *runningThread;

/*!
 * @brief 计算任务负载量
 * @param tasks 任务
 * @result 负载量
 */
- (NSUInteger)loadsOfTasks:(NSArray *)tasks;

/*!
 * @brief 激活线程
 * @discussion 空方法，纯粹为了线程切换并激活线程
 */
- (void)triggerThread;

@end


@implementation SPTaskQueue

@synthesize loadsLimit = _totalLoadsLimit;

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
        
        _runMode = SPTaskQueueRunMode_AutoClose;
        
        _runningTasks = [[NSMutableArray alloc] init];
        
        _readyTasks = [[NSMutableArray alloc] init];
        
        _totalLoadsLimit = [SPTaskConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        _isFinished = NO;
        
        _isCancelled = NO;
    }
    
    return self;
}

- (id)initWithRunMode:(SPTaskQueueRunMode)mode
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
        
        _runMode = (mode == SPTaskQueueRunMode_Persistent) ? SPTaskQueueRunMode_Persistent : SPTaskQueueRunMode_AutoClose;
        
        _runningTasks = [[NSMutableArray alloc] init];
        
        _readyTasks = [[NSMutableArray alloc] init];
        
        _totalLoadsLimit = [SPTaskConfiguration sharedInstance].defaultQueueLoadingLimit;
        
        _isFinished = NO;
        
        _isCancelled = NO;
    }
    
    return self;
}

- (NSUInteger)loads
{
    return _totalLoads;
}

- (BOOL)isOverLoaded
{
    return (_totalLoads > _totalLoadsLimit);
}

- (void)run
{
    
    // 内部取消Task时，不要清空它的协议消息代理，可能存在某些特殊的Task在取消时需要发送消息
    
    self.runningThread = [NSThread currentThread];
    
    [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] target:self selector:@selector(cancel) userInfo:nil repeats:NO];
    
    while (!_isCancelled && !_isFinished)
    {
        NSMutableArray *readyTasks = [NSMutableArray array];
        
        NSMutableArray *runTasks = [NSMutableArray array];
        
        NSMutableArray *finishTasks = [NSMutableArray array];
        
        dispatch_sync(_syncQueue, ^{
            
            for (SPTask *task in _readyTasks)
            {
                if (task.runStatus == SPTaskRunStatus_Prepare)
                {
                    [readyTasks addObject:task];
                }
            }
            
            [_runningTasks addObjectsFromArray:_readyTasks];
            
            [_readyTasks removeAllObjects];
        });
        
        for (SPTask *task in readyTasks)
        {
            [task main];
        }
        
        [readyTasks removeAllObjects];
        
        dispatch_sync(_syncQueue, ^{
            
            for (SPTask *task in _runningTasks)
            {
                if (task.runStatus == SPTaskRunStatus_Finish)
                {
                    [finishTasks addObject:task];
                }
                else if (task.runStatus == SPTaskRunStatus_Running)
                {
                    [runTasks addObject:task];
                }
                else if (task.runStatus == SPTaskRunStatus_Prepare)
                {
                    [readyTasks addObject:task];
                }
            }
            
            [_readyTasks addObjectsFromArray:readyTasks];
            
            [_runningTasks removeAllObjects];
            
            [_runningTasks addObjectsFromArray:runTasks];
            
            _isFinished = (_runMode == SPTaskQueueRunMode_Persistent) ? NO : ([_runningTasks count] + [_readyTasks count] == 0);
        });
        
        for (SPTask *task in finishTasks)
        {
            [task cancel];
        }
        
        _totalLoads = [self loadsOfTasks:runTasks];
        
        
        if (_isFinished)
        {
            break;
        }
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    _isFinished = YES;
    
    _totalLoads = 0;
    
    __block NSArray *runningTasks = nil;
    
    dispatch_sync(_syncQueue, ^{
        
        runningTasks = [NSArray arrayWithArray:_runningTasks];
    });
    
    for (SPTask *task in runningTasks)
    {
        [task cancel];
    }
    
    dispatch_sync(_syncQueue, ^{
        
        [_runningTasks removeAllObjects];
        
        [_readyTasks removeAllObjects];
    });
    
    if (self.owner && [self.owner respondsToSelector:@selector(SPTaskQueueDidFinish:)])
    {
        [self.owner SPTaskQueueDidFinish:self];
    }
}

- (void)cancel
{
    _isCancelled = YES;
    
    if ([self.runningThread isExecuting])
    {
        [self performSelector:@selector(triggerThread) onThread:self.runningThread withObject:nil waitUntilDone:NO];
    }
}

- (BOOL)addTasks:(NSArray<SPTask *> *)tasks
{
    if (![tasks count])
    {
        return YES;
    }
    
    __block BOOL success = NO;
    
    dispatch_sync(_syncQueue, ^{
        
        if (!_isFinished && !_isCancelled)
        {
            [_readyTasks addObjectsFromArray:tasks];
            
            success = YES;
        }
    });
    
    if ([self.runningThread isExecuting])
    {
        [self performSelector:@selector(triggerThread) onThread:self.runningThread withObject:nil waitUntilDone:NO];
    }
    
    return success;
}

- (NSUInteger)loadsOfTasks:(NSArray *)tasks
{
    NSUInteger sum = 0;
    
    for (SPTask *task in tasks)
    {
        sum += [task totalLoadSize];
    }
    
    return sum;
}

- (void)triggerThread
{
    
}

@end
