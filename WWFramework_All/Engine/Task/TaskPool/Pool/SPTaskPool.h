//
//  SPTaskPool.h
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTaskQueue.h"

/**********************************************************
 
    @class
        SPTaskPool
 
    @abstract
        管理任务队列的池，负责队列的创建、取消和销毁，根据队列负载状况分配队列执行任务
 
 **********************************************************/

@interface SPTaskPool : NSObject <SPTaskQueueOwnerDelegate>
{
    // 队列的队列（队列池）
    NSMutableArray *_taskQueues;
    
    // 同步队列
    dispatch_queue_t _syncQueue;
    
    // 停止标志
    BOOL _stop;
}

/*!
 * @brief 池中队列容量
 * @discussion 默认数量为3
 */
@property (nonatomic) NSUInteger poolCapacity;

/*!
 * @brief 启动池
 */
- (void)start;

/*!
 * @brief 停止池，结束当前池中队列，不再进行任何队列和任务管理
 * @discussion 停止后所有针对队列和任务的操作都将无效
 */
- (void)stop;

/*!
 * @brief 停止指定队列
 * @param queue 队列
 */
- (void)stopTaskQueue:(SPTaskQueue *)queue;

/*!
 * @brief 当前池中运行的队列数量
 * @result 当前池中运行的队列数量
 */
- (NSUInteger)currentPoolVolume;

/*!
 * @brief 添加任务
 * @discussion 池内部根据队列情况分配队列执行任务
 * @result 是否添加成功，若池启动，添加总是成功
 */
- (BOOL)addTasks:(NSArray<SPTask *> *)tasks;

/*!
 * @brief 池是否超负荷运作，即池内所有队列都处于超负荷状态
 * @result 池是否超负荷运作
 */
- (BOOL)isOverLoaded;

@end


/*********************************************************
 
    @constant
        SPTaskPoolThreadDictionaryKey_Identifier
 
    @abstract
        SPTaskPool及其子类发起的线程的字典中用于标记SPTaskPool的键
 
 *********************************************************/

extern NSString * const SPTaskPoolThreadDictionaryKey_Identifier;
