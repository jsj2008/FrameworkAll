//
//  SPTaskDispatcher.h
//  Task
//
//  Created by Baymax on 13-10-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTask, SPTaskDependence, SPTaskDaemonPool, SPTaskFreePool, SPTaskBackgroundPool;


/*********************************************************
 
    @enum
        SPTaskAsyncRunMode
 
    @abstract
        Task异步运行方式
 
 *********************************************************/

typedef enum
{
    SPTaskAsyncRunMode_Daemon          = 1,  // 在守护池中运行，接受负载调度
    SPTaskAsyncRunMode_ExclusiveThread = 2,  // 独享线程
    SPTaskAsyncRunMode_Background      = 3   // 后台运行
}SPTaskAsyncRunMode;


#pragma mark - SPTaskDispatcher

/**********************************************************
 
    @class
        SPTaskDispatcher
 
    @abstract
        Task调度器，负责Task的派发和调度
 
    @discussion
        1，调度器内置了默认的异步任务池（全局单例），允许调用者更改
        2，调度器支持控制异步任务的并发量，当前需运行的异步任务超过并发量时，后加入的异步任务将自动进入FIFO队列等待执行，调度器会在并发量回归时自动从FIFO队列中选择异步任务并执行
        3，调度器支持任务依赖，只有在当前任务的前提任务都结束时，当前任务才能执行
 
 **********************************************************/

@interface SPTaskDispatcher : NSObject
{
    // 同步执行的Task队列
    NSMutableArray *_syncTasks;
    
    // 异步执行的Task队列
    NSMutableArray *_asyncTasks;
}

/*!
 * @brief 异步任务的并发量，默认为100
 * @discussion 并发量至少为1
 */
@property (nonatomic) NSUInteger asyncTaskCapacity;

/*!
 * @brief 配置守护池
 * @discussion 默认使用全局守护池
 * @param pool 守护池
 */
- (void)setDaemonTaskPool:(SPTaskDaemonPool *)pool;

/*!
 * @brief 配置自由池
 * @discussion 默认使用全局自由池
 * @param pool 自由池
 */
- (void)setFreeTaskPool:(SPTaskFreePool *)pool;

/*!
 * @brief 配置后台池
 * @discussion 默认使用全局后台池
 * @param pool 后台池
 */
- (void)setBackgroundTaskPool:(SPTaskBackgroundPool *)pool;

/*!
 * @brief 所有正在执行的同步任务
 * @result 所有正在执行的同步任务，若无同步任务执行，返回nil
 */
- (NSArray<SPTask *> *)allSyncTasks;

/*!
 * @brief 所有正在执行的异步任务
 * @result 所有正在执行的异步任务，若无异步任务执行，返回nil
 */
- (NSArray<SPTask *> *)allAsyncTasks;

/*!
 * @brief 所有正在执行的同步任务的负载总量
 * @result 同步任务负载量
 */
- (NSUInteger)syncTaskLoads;

/*!
 * @brief 同步添加并执行任务
 * @discussion 任务将被立即执行，等价于syncAddTask:onNextRunLoop:方法设置不在下个runloop执行
 * @param task 待执行的任务
 */
- (void)syncAddTask:(SPTask *)task;

/*!
 * @brief 同步添加并执行任务，允许配置是否在下个runloop执行
 * @param task 待执行的任务
 * @param on 是否在下个runloop执行
 */
- (void)syncAddTask:(SPTask *)task onNextRunLoop:(BOOL)on;

/*!
 * @brief 异步添加并执行任务，采用TaskAsyncRunMode_Daemon模式，接受任务调度
 * @discussion 任务将被调度到最适合的线程中执行，不排除被调度回当前线程执行的可能；若任务未指定通知线程，将使用当前线程作为通知线程
 * @param task 待执行的任务
 * @result 是否成功启动异步执行
 */
- (BOOL)asyncAddTask:(SPTask *)task;

/*!
 * @brief 异步添加并执行任务，接受任务调度
 * @discussion 任务将被调度到最适合的线程中执行，不排除被调度回当前线程执行的可能；若任务未指定通知线程，将使用当前线程作为通知线程
 * @param task 待执行的任务
 * @param mode 任务异步运行模式
 * @result 是否成功启动异步执行
 */
- (BOOL)asyncAddTask:(SPTask *)task inMode:(SPTaskAsyncRunMode)mode;

/*!
 * @brief 添加任务依赖关系
 * @discussion 添加操作将合并已存在的依赖关系
 * @param dependence 任务依赖
 */
- (void)addAsyncTaskDependence:(SPTaskDependence *)dependence;

/*!
 * @brief 解除任务依赖关系
 * @param dependence 指定的任务依赖关系，可以与添加时的任务依赖关系不同
 */
- (void)removeAsyncTaskDependence:(SPTaskDependence *)dependence;

/*!
 * @brief 解除任务依赖关系
 * @discussion 解除依赖关系将移除任务的所有前提任务
 * @param task 任务
 */
- (void)removeAsyncTaskDependenceOfTask:(SPTask *)task;

/*!
 * @brief 从队列中移除任务
 * @param task 待删除的任务
 */
- (void)removeTask:(SPTask *)task;

/*!
 * @brief 取消并移除所有队列中的任务
 * @discussion 任务取消并非立即生效，将通过队列调度完成取消操作
 */
- (void)cancel;

/*!
 * @brief 从队列中取消并移除任务
 * @param task 待取消的任务
 */
- (void)cancelTask:(SPTask *)task;

@end


#pragma mark - SPTaskQueuedDispatchContext

/*********************************************************
 
    @class
        SPTaskQueuedDispatchContext
 
    @abstract
        SPTaskDispatcher中使用的task队列上下文
 
 *********************************************************/

@interface SPTaskQueuedDispatchContext : NSObject

@end


#pragma mark - SPTaskDependence

/*********************************************************
 
    @class
        SPTaskDependence
 
    @abstract
        Task依赖关系
 
    @discussion
        Task依赖关系只能应用于异步任务之间，同步任务之间的依赖关系是无效的
 
 *********************************************************/

@interface SPTaskDependence : NSObject

/*!
 * @brief Task任务
 */
@property (nonatomic) SPTask *task;

/*!
 * @brief 被依赖的Task任务
 */
@property (nonatomic) NSMutableArray<SPTask *> *dependedOnTasks;

@end
