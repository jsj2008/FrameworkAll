//
//  NotificationObserver.h
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        NotificationObserver
 
    @abstract
        消息观察者，用于承载异步任务的消息观察者信息
 
 *********************************************************/

@interface NotificationObserver : NSObject

/*!
 * @brief 实际观察者
 */
@property (nonatomic, weak) id observer;

/*!
 * @brief 接收消息的线程
 */
@property (nonatomic, retain) NSThread *notifyThread;

/*!
 * @brief 在指定线程上发送块消息
 * @discussion 消息块将在之后的runloop中得到执行
 * @param notification 待发送的消息
 * @param thread 发送线程，若为nil，则在notifyThread上发送消息，若notifyThread也为nil，则在当前线程上发送消息
 */
- (void)notify:(void (^)(id observer))notification onThread:(NSThread *)thread;

@end
