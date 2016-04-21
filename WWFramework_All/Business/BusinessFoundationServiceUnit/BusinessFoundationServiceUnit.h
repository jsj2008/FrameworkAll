//
//  BusinessFoundationServiceUnit.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BusinessFoundationServiceUnitDelegate;


/*********************************************************
 
    @class
        BusinessFoundationServiceUnit
 
    @abstract
        基础业务服务单元，负责启动和关闭业务层基础框架，基本引擎等系统服务
 
    @discussion
        1，应当在主线程启动和关闭应用服务
        2，应当在应用启动后尽快启动应用服务，在应用结束前关闭应用服务
        3，必须为单元指定一个代理对象，在接收到启动结束消息后才能使用应用服务
 
 *********************************************************/

@interface BusinessFoundationServiceUnit : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<BusinessFoundationServiceUnitDelegate> delegate;

/*!
 * @brief 单例
 */
+ (BusinessFoundationServiceUnit *)sharedInstance;

/*!
 * @brief 启动应用服务
 * @discussion 启动过程中将向代理对象发送启动消息
 */
- (void)start;

/*!
 * @brief 关闭应用服务
 * @discussion 关闭过程中将向代理对象发送关闭消息
 */
- (void)stop;

@end


/*********************************************************
 
    @protocol
        BusinessFoundationServiceUnitDelegate
 
    @abstract
        应用服务消息
 
 *********************************************************/

@protocol BusinessFoundationServiceUnitDelegate <NSObject>

@optional

/*!
 * @brief 应用服务启动成功消息
 * @param unit 应用服务单元
 * @param successfully 成功标志
 */
- (void)businessFoundationServiceUnit:(BusinessFoundationServiceUnit *)unit didStartSuccessfully:(BOOL)successfully;

/*!
 * @brief 应用服务启动进度消息
 * @param unit 应用服务单元
 * @param progress 执行进度
 */
- (void)businessFoundationServiceUnit:(BusinessFoundationServiceUnit *)unit isStartingWithProgress:(float)progress;

/*!
 * @brief 应用服务关闭成功消息
 * @param unit 应用服务单元
 * @param successfully 成功标志
 */
- (void)businessFoundationServiceUnit:(BusinessFoundationServiceUnit *)unit didStopSuccessfully:(BOOL)successfully;

/*!
 * @brief 应用服务关闭进度消息
 * @param unit 应用服务单元
 * @param progress 执行进度
 */
- (void)businessFoundationServiceUnit:(BusinessFoundationServiceUnit *)unit isStopingWithProgress:(float)progress;

@end
