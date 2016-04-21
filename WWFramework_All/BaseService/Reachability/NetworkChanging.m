//
//  NetworkChanging.m
//  FoundationProject
//
//  Created by Baymax on 14-1-2.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "NetworkChanging.h"

/*!
 * @brief 网络消息变化的专用消息通知名字
 */
NSString * const NetworkReachabilityChangedNotification = @"NetworkReachabilityChanged";

/*!
 * @brief 网络消息变化的消息通知的用户信息的上下文键，用于提取上下文
 */
NSString * const NetworkReachabilityChangedNotificationKey_Context = @"Context";


#pragma mark - NetworkReachabilityChangedContext

@implementation NetworkReachabilityChangedContext

@end
