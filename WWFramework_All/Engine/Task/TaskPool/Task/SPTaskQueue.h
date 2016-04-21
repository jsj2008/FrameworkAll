//
//  SPTaskQueue.h
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTask.h"

@protocol SPTaskQueueOwnerDelegate;

/*********************************************************
 
    @enum
        SPTaskQueueRunMode
 
    @abstract
        SPTaskQueue运行模式
 
 *********************************************************/

typedef enum
{
    SPTaskQueueRunMode_Persistent = 1,   // 持久运行，直到调用cancel方法结束
    SPTaskQueueRunMode_AutoClose  = 2    // 自关闭，当内部Task全部运行完成后自动关闭
}SPTaskQueueRunMode;


/**********************************************************
 
    @class
        SPTaskQueue
 
    @abstract
        异步管理和执行Task的队列，需要由调用者在单独的线程中运行
 
    @discussion
        1、队列有自己的负载量，负载量是队列中的Task的负载总和。负载量在队列池管理中使用
        2、队列内部有两个子队列，一个运行队列，一个准备队列。添加Task时，只将Task放入准备队列。队列会根据运行状况不断从准备队列转移Task到运行队列运行
 
 **********************************************************/

@interface SPTaskQueue : NSObject
{
    // 运行模式，默认TaskQueueRunMode_AutoClose
    SPTaskQueueRunMode _runMode;
    
    // 运行队列
    NSMutableArray *_runningTasks;
    
    // 准备队列
    NSMutableArray *_readyTasks;
    
    // 结束标志
    BOOL _isFinished;
    
    // 取消标志
    BOOL _isCancelled;
}

/*!
 * @brief 内部负载量上限，默认为SPTaskQueueDefaultLoadsLimit
 */
@property (nonatomic) NSUInteger loadsLimit;

/*!
 * @brief 所有者，owner协议消息的代理
 */
@property (nonatomic, weak) id<SPTaskQueueOwnerDelegate> owner;

/*!
 * @brief 初始化
 * @param mode 队列运行模式
 * @result 初始化后的对象
 */
- (id)initWithRunMode:(SPTaskQueueRunMode)mode;

/*!
 * @brief 当前负载量，即在本队列中运行的Task的总负载量
 * @result 当前负载量
 */
- (NSUInteger)loads;

/*!
 * @brief 队列是否超负荷，即队列当前负载量超过允许的负载量上线
 * @result 队列是否超负荷
 */
- (BOOL)isOverLoaded;

/*!
 * @brief 运行，开始自动执行队列内部操作
 */
- (void)run;

/*!
 * @brief 取消队列
 * @discussion 取消操作并不立即生效，队列将根据自身运行情况尽快执行
 */
- (void)cancel;

/*!
 * @brief 批量添加Task
 * @discussion 添加Task的操作只将Task放入准备队列，队列会根据自身运行状况尽快执行Task
 * @param tasks 待执行的Task
 * @result 添加是否成功，当队列结束或被取消时返回NO，传入的Tasks为空时返回YES，其他情况下返回YES
 */
- (BOOL)addTasks:(NSArray<SPTask *> *)tasks;

@end


/**********************************************************
 
    @protocol
        TaskQueueOwnerDelegate
 
    @abstract
        TaskQueue的owner的协议方法，用于通知owner对TaskQueue进行特殊管理
 
 **********************************************************/

@protocol SPTaskQueueOwnerDelegate <NSObject>

/*!
 * @brief 队列已经结束的消息
 * @discussion 在消息响应方法中实现TaskQueue的释放
 * @param queue 结束的队列
 */
- (void)SPTaskQueueDidFinish:(SPTaskQueue *)queue;

@end

