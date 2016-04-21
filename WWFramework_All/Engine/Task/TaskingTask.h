//
//  TaskingTask.h
//  FoundationProject
//
//  Created by user on 13-12-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationTask.h"

/*********************************************************
 
    @class
        TaskingTask
 
    @abstract
        可动态添加并执行子任务的任务
 
    @discussion
        1，不同于普通的任务仅支持在内部派发子任务，本对象还支持在外部向本任务追加子任务。被追加的子任务不会向本对象发送任何消息，仍然遵循普通的任务消息通知模式向自己的delegate对象发送消息，因此追加的子任务完成时需要手动调用本对象删除该子任务，否则子任务将一直被本对象保留直至本对象结束
        2，所有外部调用的接口都是有延迟的操作（会自动切换到本任务所在线程），可能出现本任务即将结束，却仍能添加子任务的情况，因此一旦取消本任务后，不要再执行添加子任务的操作
        3，本任务是一个不会自行结束的任务，必须通过外部取消和销毁，一旦执行了取消操作，便认为本任务结束
        4，子任务的操作需要使用本任务的线程，必须在子任务运行起来后（接收到taskingTaskDidStart:消息）后才能保证正确执行对子任务的操作
        5，本任务工作的实质，是给其它任务的执行提供一个公共的线程
        6，在父类中有获取运行线程的接口，通过perform到运行线程也可以实现使用本任务线程的效果，但是需要注意的是，当取消本任务时，若还有其他任务在同一线程执行时，取消操作并不会终止已经被perform但还未得到执行的selector（取消操作最终也是perform到运行线程执行的，将被排在其他selector之后执行），而通过添加子任务来实现共用线程，当执行取消操作时，本任务将尽快结束并将未执行的子任务移除
 
 *********************************************************/

@interface TaskingTask : FoundationTask

/*!
 * @brief 添加子任务
 * @param tasks 子任务
 * @result 本任务未结束时返回YES，结束时返回NO。参数tasks为空时返回YES
 */
- (BOOL)addTasks:(NSArray<SPTask *> *)tasks;

/*!
 * @brief 删除子任务
 * @param tasks 子任务，由FoundationTask对象构成
 */
- (void)removeTasks:(NSArray<SPTask *> *)tasks;

/*!
 * @brief 取消子任务
 * @param tasks 子任务，由FoundationTask对象构成
 */
- (void)cancelTasks:(NSArray<SPTask *> *)tasks;

@end


/*********************************************************
 
    @protocol
        TaskingTaskDelegate
 
    @abstract
        TaskingTask代理协议
 
 *********************************************************/


@protocol TaskingTaskDelegate <NSObject>

/*!
 * @brief 任务启动
 * @param taskingTask tasking任务
 */
- (void)taskingTaskDidStart:(TaskingTask *)taskingTask;

/*!
 * @brief 任务已添加
 * @param taskingTask tasking任务
 * @param tasks 被添加的任务
 */
- (void)taskingTask:(TaskingTask *)taskingTask didAddTasks:(NSArray<SPTask *> *)tasks;

/*!
 * @brief 任务已移除
 * @param taskingTask tasking任务
 * @param tasks 被移除的任务
 */
- (void)taskingTask:(TaskingTask *)taskingTask didRemoveTasks:(NSArray<SPTask *> *)tasks;

/*!
 * @brief 任务已取消
 * @param taskingTask tasking任务
 * @param tasks 被取消的任务
 */
- (void)taskingTask:(TaskingTask *)taskingTask didCancelTasks:(NSArray<SPTask *> *)tasks;

@end
