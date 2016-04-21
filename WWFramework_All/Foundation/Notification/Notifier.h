//
//  Notifier.h
//  FoundationProject
//
//  Created by Baymax on 13-12-25.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        Notifier
 
    @abstract
        通知者，负责在特定线程发送通知代码
 
 *********************************************************/

@interface Notifier : NSObject

/*!
 * @brief 消息通知
 * @discussion 通知在当前线程的下一个runloop发送
 * @param notification 消息块
 */
+ (void)notify:(void (^)())notification;

/*!
 * @brief 消息通知
 * @discussion 通知在指定线程发送
 * @param notification 消息块
 * @param thread 消息发送线程
 */
+ (void)notify:(void (^)())notification onThread:(NSThread *)thread;

@end
