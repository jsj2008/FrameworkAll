//
//  AHServerConnection.h
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPConnection.h"
#import "AHServerTransactionTask.h"
#import "AHServerConfiguration.h"

@protocol AHServerConnectionDelegate;


/*********************************************************
 
    @class
        AHServerConnection
 
    @abstract
        服务器端的HTTP连接
 
    @discussion
        HTTP连接负责连接内部的数据收发，支持长连接和管道化，并管理着请求间和数据间的时序，连接内部会解析数据并生成和派发正确的HTTP事务。
        1，连接内部的数据收发在同一线程
        2，输入流被中断时（无论是客户端还是服务器端造成的），在所有请求的响应被发送后，将自动中断整个连接
        3，连接内部实现了流量统计，和输入输出流的暂停和继续功能
 
 *********************************************************/

@interface AHServerConnection : NSObject <TCPConnectionDelegate, AHServerTransactionTaskDelegate>

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<AHServerConnectionDelegate> delegate;

/*!
 * @brief 配置项
 */
@property (nonatomic) AHServerConfiguration *configuration;

/*!
 * @brief 初始化
 * @param connection TCP连接
 * @result 初始化后的对象
 */
- (id)initWithTCPConnection:(TCPConnection *)connection;

/*!
 * @brief 启动连接
 * @result 是否正确启动
 */
- (BOOL)start;

/*!
 * @brief 中断连接
 */
- (void)stop;

/*!
 * @brief 连接已接收到的数据大小
 */
@property (nonatomic) unsigned long long inputDataSize;

/*!
 * @brief 连接已发送的数据大小
 */
@property (nonatomic) unsigned long long outputDataSize;

/*!
 * @brief 暂停输入
 */
- (void)suspendReceiving;

/*!
 * @brief 继续输入
 */
- (void)resumeReceiving;

/*!
 * @brief 暂停输出
 */
- (void)suspendSending;

/*!
 * @brief 继续输出
 */
- (void)resumeSending;

@end


/*********************************************************
 
    @protocol
        AHServerConnectionDelegate
 
    @abstract
        HTTP连接代理协议
 
 *********************************************************/

@protocol AHServerConnectionDelegate <NSObject>

/*!
 * @brief 连接结束
 * @param connection HTTP连接
 */
- (void)AHServerConnectionDidFinish:(AHServerConnection *)connection;

@end
