//
//  NotificationObservingSet.h
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationObserver.h"

/*********************************************************
 
    @class
        NotificationObservingSet
 
    @abstract
        观察者集合，用于承载对单个对象的多个观察者信息
 
 *********************************************************/

@interface NotificationObservingSet : NSObject

/*!
 * @brief 被观察对象
 */
@property (nonatomic) id object;

/*!
 * @brief 观察者数组
 * @discussion 成员变量须为NotificationObserver对象
 * @discussion 在NotificationObservingSet初始化时，将自动创建本数组
 */
@property (nonatomic) NSMutableArray *observers;

/*!
 * @brief 在指定线程上发送块消息
 * @discussion 消息块将在之后的runloop中得到执行
 * @param notification 待发送的消息
 * @param thread 发送线程，若为nil，则在各NotificationObserver的通知线程上发送消息
 */
- (void)notify:(void (^)(id observer))notification onThread:(NSThread *)thread;

@end
