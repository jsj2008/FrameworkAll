//
//  SPTaskFreePool.h
//  Task
//
//  Created by Baymax on 13-8-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskPool.h"

/**********************************************************
 
    @class
        SPTaskFreePool
 
    @abstract
        管理自由任务队列的池，负责队列的创建、取消和销毁，根据队列负载状况分配队列执行任务
 
    @discussion
        管理自由队列，为任务分配队列时遵循如下原则：1）判断队列是否已满，若未满，创建新队列执行任务；2）若已满，寻找负载量最小的队列执行任务
 
 **********************************************************/

@interface SPTaskFreePool : SPTaskPool

/*!
 * @brief 单例
 */
+ (SPTaskFreePool *)sharedInstance;

@end


/*********************************************************
 
    @constant
        SPTaskFreePoolThreadIdentifier
 
    @abstract
        SPTaskFreePool的线程标记，用于在线程字典中标记线程由SPFreeTaskPool发起
 
 *********************************************************/

extern NSString * const SPTaskFreePoolThreadIdentifier;
