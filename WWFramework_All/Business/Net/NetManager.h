//
//  NetManager.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/8/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkReachability.h"

@protocol NetManagerObserving;


/*********************************************************
 
    @class
        NetManager
 
    @abstract
        网络管理器，负责应用的网络管理
 
    @discussion
        管理器负责网络事件的处理，包括网络状态获取，变化通知等
 
 *********************************************************/

@interface NetManager : NSObject

/*!
 * @brief 单例
 */
+ (NetManager *)sharedInstance;

/*!
 * @brief 启动
 * @discussion 将启动网络状态变化侦听
 */
- (void)start;

/*!
 * @brief 停止
 * @discussion 将停止网络状态变化侦听
 */
- (void)stop;

/*!
 * @brief 获取当前网络状态
 * @result 当前网络状态
 */
- (NetworkReachStatus)currentNetworkReachStatus;

/*!
 * @brief 添加网络状态变化的观察者
 * @param observer 观察者
 */
- (void)addNetworkChangingObserver:(id<NetManagerObserving>)observer;

/*!
 * @brief 移除网络状态变化的观察者
 * @param observer 观察者
 */
- (void)removeNetworkChangingObserver:(id<NetManagerObserving>)observer;

@end


/*********************************************************
 
    @class
        NetManagerObserving
 
    @abstract
        网络管理通知协议
 
 *********************************************************/

@protocol NetManagerObserving <NSObject>

/*!
 * @brief 网络状态变化
 * @param fromStatus 变化前状态
 * @param toStatus 变化后状态
 */
- (void)networkStautsDidChangeFromStatus:(NetworkReachStatus)fromStatus toStatus:(NetworkReachStatus)toStatus;

@end
