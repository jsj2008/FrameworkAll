//
//  AHServer.h
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPServer.h"
#import "AHServerConnection.h"
#import "AHServerConfiguration.h"

/*********************************************************
 
    @class
        AHServer
 
    @abstract
        服务器端对象
 
    @discussion
        1，本对象负责管理监听和HTTP连接
        2，监听和HTTP连接的数据收发在同一线程（节省线程资源）
        3，扩展了流量统计功能
        4，扩展了输入和输出的中断和继续功能，配合流量统计功能可以实现流量控制
 
 *********************************************************/

@interface AHServer : NSObject <TCPServerDelegate, AHServerConnectionDelegate>

/*!
 * @brief 配置项
 */
@property (nonatomic) AHServerConfiguration *configuration;

/*!
 * @brief 初始化
 * @param port 服务端监听端口
 * @result 初始化后的对象
 */
- (id)initWithPort:(NSUInteger)port;

/*!
 * @brief 服务端IP地址
 * @result 服务端IP地址
 */
- (NSString *)serverIPAddress;

/*!
 * @brief 当前监听端口
 * @result 当前监听端口
 */
- (NSInteger)currentIPV4Port;

/*!
 * @brief 启动
 */
- (BOOL)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 已接收到的数据大小
 * @result 已接收到的数据大小
 */
- (unsigned long long)totalReceivedDataSize;

/*!
 * @brief 已发送的数据大小
 * @result 已发送的数据大小
 */
- (unsigned long long)totalSentDataSize;

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
