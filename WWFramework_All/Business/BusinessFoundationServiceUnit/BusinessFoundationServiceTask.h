//
//  BusinessFoundationServiceTask.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "FoundationTask.h"

@protocol BusinessFoundationServiceStartTaskDelegate;


/*********************************************************
 
    @class
        BusinessFoundationServiceStartTask
 
    @abstract
        基础业务服务启动任务
 
    @discussion
        本任务用于启动基础业务（不包含框架、基本引擎等基础功能）
 
 *********************************************************/

@interface BusinessFoundationServiceStartTask : FoundationTask

@end


/*********************************************************
 
    @protocol
        BusinessFoundationServiceStartTaskDelegate
 
    @abstract
        基础业务服务启动任务的代理协议
 
 *********************************************************/

@protocol BusinessFoundationServiceStartTaskDelegate <NSObject>

/*!
 * @brief 任务结束
 * @param task 任务
 */
- (void)businessFoundationServiceStartTaskDidFinish:(BusinessFoundationServiceStartTask *)task;

@end


@protocol BusinessFoundationServiceStopTaskDelegate;


/*********************************************************
 
    @class
        BusinessFoundationServiceStopTask
 
    @abstract
        基础业务服务关闭任务
 
    @discussion
        本任务用于关闭基础业务（不包含框架、基本引擎等基础功能）
 
 *********************************************************/

@interface BusinessFoundationServiceStopTask : FoundationTask

@end


/*********************************************************
 
    @protocol
        BusinessFoundationServiceStopTaskDelegate
 
    @abstract
        基础业务服务关闭任务的代理协议
 
 *********************************************************/

@protocol BusinessFoundationServiceStopTaskDelegate <NSObject>

/*!
 * @brief 任务结束
 * @param task 任务
 */
- (void)businessFoundationServiceStopTaskDidFinish:(BusinessFoundationServiceStopTask *)task;

@end
