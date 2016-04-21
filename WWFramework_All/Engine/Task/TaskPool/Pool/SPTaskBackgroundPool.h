//
//  SPTaskBackgroundPool.h
//  Task
//
//  Created by Baymax on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskPool.h"

/**********************************************************
 
    @class
        SPTaskBackgroundPool
 
    @abstract
        管理后台任务（低优先级）队列的池，负责队列的创建、取消和销毁，根据队列负载状况分配队列执行任务
 
    @discussion
        管理后台队列，为任务分配队列时遵循如下原则：1）判断队列是否已满，若未满，创建新队列执行任务；2）若已满，寻找负载量最小的队列执行任务
 
 **********************************************************/

@interface SPTaskBackgroundPool : SPTaskPool

/*!
 * @brief 单例
 */
+ (SPTaskBackgroundPool *)sharedInstance;

@end


/*********************************************************
 
    @constant
        SPTaskBackgroundPoolThreadIdentifier
 
    @abstract
        SPTaskBackgroundPool的线程标记，用于在线程字典中标记线程由SPBackgroundTaskPool发起
 
 *********************************************************/

extern NSString * const SPTaskBackgroundPoolThreadIdentifier;
