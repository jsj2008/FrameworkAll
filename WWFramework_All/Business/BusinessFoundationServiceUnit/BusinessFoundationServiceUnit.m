//
//  BusinessFoundationServiceUnit.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "BusinessFoundationServiceUnit.h"
#import "BusinessFoundationServiceTask.h"
#import "SPTaskDispatcher.h"

@interface BusinessFoundationServiceUnit () <BusinessFoundationServiceStartTaskDelegate, BusinessFoundationServiceStopTaskDelegate>

/*!
 * @brief 任务派发器
 */
@property (nonatomic) SPTaskDispatcher *taskDispatcher;

/*!
 * @brief 启动任务
 */
@property (nonatomic) BusinessFoundationServiceStartTask *startTask;

/*!
 * @brief 结束任务
 */
@property (nonatomic) BusinessFoundationServiceStopTask *stopTask;

@end


@implementation BusinessFoundationServiceUnit

+ (BusinessFoundationServiceUnit *)sharedInstance
{
    static BusinessFoundationServiceUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[BusinessFoundationServiceUnit alloc] init];
            
            instance.taskDispatcher = [[SPTaskDispatcher alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    self.startTask = [[BusinessFoundationServiceStartTask alloc] init];
    
    self.startTask.delegate = self;
    
    [self.taskDispatcher asyncAddTask:self.startTask];
}

- (void)stop
{
    self.stopTask = [[BusinessFoundationServiceStopTask alloc] init];
    
    self.stopTask.delegate = self;
    
    [self.taskDispatcher asyncAddTask:self.stopTask];
}

- (void)businessFoundationServiceStartTaskDidFinish:(BusinessFoundationServiceStartTask *)task
{
    [self.taskDispatcher removeTask:task];
    
    self.startTask = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(businessFoundationServiceUnit:didStartSuccessfully:)])
    {
        [self.delegate businessFoundationServiceUnit:self didStartSuccessfully:YES];
    }
}

- (void)businessFoundationServiceStopTaskDidFinish:(BusinessFoundationServiceStopTask *)task
{
    [self.taskDispatcher removeTask:task];
    
    self.stopTask = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(businessFoundationServiceUnit:didStopSuccessfully:)])
    {
        [self.delegate businessFoundationServiceUnit:self didStopSuccessfully:YES];
    }
}

@end
