//
//  HTTPNetServiceCenter.h
//  Application
//
//  Created by Baymax on 14-2-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPTransaction;

/*!
 * @brief HTTP网络服务可用性检查操作
 */
typedef BOOL(^HTTPNetServiceIsAvailable)();


/*********************************************************
 
    @class
        HTTPNetServiceCenter
 
    @abstract
        HTTP网络服务中心，提供网络可用性服务
 
    @discussion
        1，所有的HTTP事务必须在中心注册成功后才能运行
        2，中心在网络不可用时会通知所有已注册的HTTP事务停止工作
 
 *********************************************************/

@interface HTTPNetServiceCenter : NSObject

/*!
 * @brief 单例
 */
+ (HTTPNetServiceCenter *)sharedInstance;

/*!
 * @brief 启动
 * @discussion 启动后，HTTP事务才能在中心注册成功
 */
- (void)start;

/*!
 * @brief 停止
 * @discussion 停止后，HTTP事务将在中心注册失败
 */
- (void)stop;

/*!
 * @brief 网络可用性检查操作
 */
@property (nonatomic, copy) HTTPNetServiceIsAvailable serviceCheckOperation;

/*!
 * @brief 更新网络服务状态
 * @discussion 服务状态变为不可用时，中心将通知所有已注册的HTTP事务停止工作
 */
- (void)updateNetService;

/*!
 * @brief 注册HTTP事务
 * @discussion 只有网络服务可用时才能注册成功
 * @param transaction HTTP事务
 * @result 注册是否成功
 */
- (BOOL)addTransaction:(HTTPTransaction *)transaction;

/*!
 * @brief 移除HTTP事务
 * @param transaction HTTP事务
 */
- (void)removeTransaction:(HTTPTransaction *)transaction;

@end
