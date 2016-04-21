//
//  LightLoadingPermanentQueue.h
//  FoundationProject
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoidBlockLoader.h"

@protocol LightLoadingPermanentQueueDelegate;


/*********************************************************
 
    @class
        LightLoadingPermanentTaskQueue
 
    @abstract
        轻载常驻任务队列，内建常驻线程，运行轻载任务
 
    @discussion
        1，本队列可以用于执行信号监听等任务，也可以用于借助内建线程发送消息，队列内不能执行可能长时间堵塞线程的操作
        2，本队列的设计初衷是提供一个常驻线程，用来承载操作时间较短的跨线程操作，例如消息通知，信号通知等
 
 *********************************************************/

@interface LightLoadingPermanentQueue : NSObject

/*!
 * @brief 协议消息的代理
 */
@property (nonatomic, weak) id<LightLoadingPermanentQueueDelegate> delegate;

/*!
 * @brief 通知线程，在此线程上发送启动和停止消息
 * @discussion 此线程不能为空
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 单例
 */
+ (LightLoadingPermanentQueue *)sharedInstance;

/*!
 * @brief 起动内建线程和内部管理模块
 */
- (void)start;

/*!
 * @brief 停止内建线程，撤销管理模块
 */
- (void)stop;

/*!
 * @brief 内建线程
 * @result 内建线程
 */
- (NSThread *)runningThread;

/*!
 * @brief 添加任务块到内建线程执行
 * @param blockLoader 任务块承载对象
 * @result 队列正常运行时返回YES，反之返回NO
 */
- (BOOL)addBlockLoader:(VoidBlockLoader *)blockLoader;

@end


/*********************************************************
 
    @protocol
        LightLoadingPermanentQueueDelegate
 
    @abstract
        LightLoadingPermanentQueue的代理消息协议
 
 *********************************************************/

@protocol LightLoadingPermanentQueueDelegate <NSObject>

/*!
 * @brief 启动的消息
 * @param queue 队列
 */
- (void)lightLoadingPermanentQueueDidStart:(LightLoadingPermanentQueue *)queue;

/*!
 * @brief 结束的消息
 * @param queue 队列
 */
- (void)lightLoadingPermanentQueueDidStop:(LightLoadingPermanentQueue *)queue;

@end
