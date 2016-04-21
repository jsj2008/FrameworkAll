//
//  TaskingTask.m
//  FoundationProject
//
//  Created by user on 13-12-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TaskingTask.h"
#import "NotificationBlockLoader.h"

@interface TaskingTask ()
{
    BOOL _isFinished;
}

- (void)innerRunTasks:(NSArray *)tasks;

- (void)innerRemoveTasks:(NSArray *)tasks;

- (void)innerCancelTasks:(NSArray *)tasks;

@end


@implementation TaskingTask

- (void)run
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskingTaskDidStart:)])
        {
            [self.delegate taskingTaskDidStart:self];
        }
    }];
}

- (void)cancel
{
    _isFinished = YES;
    
    [super cancel];
}

- (void)innerRunTasks:(NSArray *)tasks
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskingTask:didAddTasks:)])
        {
            [self.delegate taskingTask:self didAddTasks:tasks];
        }
    }];
    
    for (FoundationTask *task in tasks)
    {
        [self.dispatcher syncAddTask:task];
    }
}

- (void)innerRemoveTasks:(NSArray *)tasks
{
    for (FoundationTask *task in tasks)
    {
        [self.dispatcher removeTask:task];
    }
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskingTask:didRemoveTasks:)])
        {
            [self.delegate taskingTask:self didRemoveTasks:tasks];
        }
    }];
}

- (void)innerCancelTasks:(NSArray *)tasks
{
    for (FoundationTask *task in tasks)
    {
        [self.dispatcher cancelTask:task];
    }
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskingTask:didCancelTasks:)])
        {
            [self.delegate taskingTask:self didCancelTasks:tasks];
        }
    }];
}

- (BOOL)addTasks:(NSArray<SPTask *> *)tasks
{
    if (![tasks count])
    {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_isFinished && [[self runningThread] isExecuting])
    {
        [self performSelector:@selector(innerRunTasks:) onThread:[self runningThread] withObject:tasks waitUntilDone:NO];
        
        success = YES;
    }
    
    return success;
}

- (void)removeTasks:(NSArray<SPTask *> *)tasks
{
    if (![tasks count])
    {
        return;
    }
    
    if (!_isFinished && [[self runningThread] isExecuting])
    {
        [self performSelector:@selector(innerRemoveTasks:) onThread:[self runningThread] withObject:tasks waitUntilDone:NO];
    }
}

- (void)cancelTasks:(NSArray<SPTask *> *)tasks
{
    if (![tasks count])
    {
        return;
    }
    
    if (!_isFinished && [[self runningThread] isExecuting])
    {
        [self performSelector:@selector(innerCancelTasks:) onThread:[self runningThread] withObject:tasks waitUntilDone:NO];
    }
}

@end
