//
//  SPTaskDaemonPool.h
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskPool.h"

/**********************************************************
 
    @class
        SPTaskDaemonPool
 
    @abstract
        管理守护任务队列的池，负责队列的创建、取消和销毁，根据队列负载状况分配队列执行任务
 
    @discussion
        1、管理守护队列，为任务分配队列时遵循如下原则：1）寻找当前未超负荷的队列中负载最小的队列执行任务；2）若找不到，若此时队列未满，创建新队列执行任务；3）若队列已满，则寻找负载最小的队列执行任务，不论该队列是否超负荷
        2、可以在此池中创建指定数量的常驻队列
 
 **********************************************************/

@interface SPTaskDaemonPool : SPTaskPool

/*!
 * @brief 单例
 */
+ (SPTaskDaemonPool *)sharedInstance;

/*!
 * @brief 创建并启动指定数量的常驻队列
 * @param count 常驻队列的数量
 */
- (void)startWithPersistentQueueCount:(NSUInteger)count;

@end


/*********************************************************
 
    @constant
        SPTaskDaemonPoolThreadIdentifier
 
    @abstract
        SPTaskDaemonPool的线程标记，用于在线程字典中标记线程由SPDaemonTaskPool发起
 
 *********************************************************/

extern NSString * const SPTaskDaemonPoolThreadIdentifier;
