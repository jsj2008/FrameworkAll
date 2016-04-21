//
//  ServiceUnit.h
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightLoadingPermanentQueue.h"

@protocol ServiceUnitDelegate;


/*********************************************************
 
    @class
        ServiceUnit
 
    @abstract
        应用服务单元，负责启动和关闭应用框架，基本引擎，目录服务等系统服务
 
    @discussion
        1，应当在主线程启动和关闭应用服务
        2，应当在应用启动后尽快启动应用服务，在应用结束前关闭应用服务
        3，必须为单元指定一个代理对象，在接收到启动结束消息后才能使用应用服务
 
 *********************************************************/

@interface ServiceUnit : NSObject <LightLoadingPermanentQueueDelegate>

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<ServiceUnitDelegate> delegate;

/*!
 * @brief 消息线程，代理对象将在该线程上接收消息，不能为空
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 单例
 */
+ (ServiceUnit *)sharedInstance;

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
        ServiceUnitDelegate
 
    @abstract
        应用服务消息
 
 *********************************************************/

@protocol ServiceUnitDelegate <NSObject>

@optional

/*!
 * @brief 应用服务启动成功消息
 * @param unit 应用服务单元
 * @param successfully 成功标志
 */
- (void)serviceUnit:(ServiceUnit *)unit didStartSuccessfully:(BOOL)successfully;

/*!
 * @brief 应用服务启动进度消息
 * @param unit 应用服务单元
 * @param progress 执行进度
 */
- (void)serviceUnit:(ServiceUnit *)unit isStartingWithProgress:(float)progress;

/*!
 * @brief 应用服务关闭成功消息
 * @param unit 应用服务单元
 * @param successfully 成功标志
 */
- (void)serviceUnit:(ServiceUnit *)unit didStopSuccessfully:(BOOL)successfully;

/*!
 * @brief 应用服务关闭进度消息
 * @param unit 应用服务单元
 * @param progress 执行进度
 */
- (void)serviceUnit:(ServiceUnit *)unit isStopingWithProgress:(float)progress;

@end
