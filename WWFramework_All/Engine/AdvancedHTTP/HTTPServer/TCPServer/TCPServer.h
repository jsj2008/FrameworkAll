//
//  TCPServer.h
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPListener.h"

@class TCPConnection;

@protocol TCPServerDelegate;

/******************************************************
 
    @class
        TCPServer
 
    @abstract
        TCP层服务端对象，负责监听指定端口，生成连接
 
    @discussion
        1. 服务端开启后，会创建ipv4的监听socket。目前不支持ipv6
        2. 服务端开启后，将尽量使用初始化时指定的端口监听，但并不保证一定使用该端口。因此需要使用currentIPV4Port来获取实际端口号
 
 ******************************************************/

@interface TCPServer : NSObject <TCPListenDelegate>
{
    // 监听端口
    NSUInteger _port;
}

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<TCPServerDelegate> delegate;

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
 * @discussion 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 停止
 */
- (void)stop;

@end

/******************************************************
 
    @protocol
        TCPServerDelegate
 
    @abstract
        TCP服务端的协议消息
 
 ******************************************************/

@protocol TCPServerDelegate <NSObject>

/*!
 * @brief 接收到连接请求
 * @param server TCP服务端
 * @param connection TCP连接
 */
- (void)TCPServer:(TCPServer *)server didAcceptConnection:(TCPConnection *)connection;

@end
