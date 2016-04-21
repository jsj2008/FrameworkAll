//
//  NetworkChanging.h
//  FoundationProject
//
//  Created by Baymax on 14-1-2.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkReachability.h"

/*!
 * @brief 网络消息变化的专用消息通知名字
 * @discussion NetworkReachability不负责发送本消息，本消息的发送须由NetworkReachabilityNotificationBlock实现
 */
extern NSString * const NetworkReachabilityChangedNotification;

/*!
 * @brief 网络消息变化的消息通知的用户信息的上下文键，用于提取上下文
 */
extern NSString * const NetworkReachabilityChangedNotificationKey_Context;


#pragma mark - NetworkReachabilityChangedContext

/*********************************************************
 
    @class
        NetworkReachabilityChangedContext
 
    @abstract
        网络消息变化的上下文
 
 *********************************************************/

@interface NetworkReachabilityChangedContext : NSObject

/*!
 * @brief 变化前的网络状态
 */
@property (nonatomic) NetworkReachStatus fromStatus;

/*!
 * @brief 变化后的网络状态
 */
@property (nonatomic) NetworkReachStatus toStatus;

@end
