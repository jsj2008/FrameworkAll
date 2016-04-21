//
//  NetworkReachability.h
//  FoundationProject
//
//  Created by user on 13-12-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        NetworkReachStatus
 
    @abstract
        网络连接状态
 
 *********************************************************/

typedef enum
{
	NetworkReachStatus_NotReachable = 0,  // 不可达
	NetworkReachStatus_ViaWiFi      = 1,  // WiFi连接
	NetworkReachStatus_ViaWWAN      = 2   // 3G/2G连接
}NetworkReachStatus;


/*!
 * @brief 网络连接状态变化后的通知块，可在这里执行针对网络变化的代码
 * @param status 新的网络状态
 */
typedef void (^NetworkReachabilityChangedNotificationBlock)(NetworkReachStatus fromStatus, NetworkReachStatus toStatus);


#pragma mark - NetworkReachability

/*********************************************************
 
    @class
        NetworkReachability
 
    @abstract
        网络连接
 
    @discussion
        NetworkReachability是对网络连接的封装，负责获取网络状态和状态变化的通知
 
 *********************************************************/

@interface NetworkReachability : NSObject

/*!
 * @brief 连接的实时状态
 */
@property (nonatomic) NetworkReachStatus status;

/*!
 * @brief 连接变化的通知块
 */
@property (nonatomic, copy) NetworkReachabilityChangedNotificationBlock notificationBlock;

/*!
 * @brief 单例
 * @discussion 内部初始化过程中将获取当前连接状态，当网络缓慢时，这可能需要至多30秒时间
 */
+ (NetworkReachability *)internetReachability;

/*!
 * @brief 启动消息通知
 * @result 是否正确启动
 */
- (BOOL)startNotifier;

/*!
 * @brief 关闭消息通知
 */
- (void)stopNotifier;

@end
