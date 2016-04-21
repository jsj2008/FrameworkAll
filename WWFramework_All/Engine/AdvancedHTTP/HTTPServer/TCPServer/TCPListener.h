//
//  TCPListener.h
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCPListenDelegate;

/******************************************************
 
    @class
        TCPListener
 
    @abstract
        TCP端口监听对象
 
    @discussion
        1. 创建ipv4的监听socket。不支持ipv6
        2. 监听开启后，将尽量使用初始化时指定的端口监听，但并不保证一定使用该端口。因此需要使用currentIPV4Port来获取实际端口号
 
 ******************************************************/

@interface TCPListener : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<TCPListenDelegate>delegate;

/*!
 * @brief 初始化
 * @param port 服务端监听端口
 * @result 初始化后的对象
 */
- (id)initWithPort:(NSInteger)port;

/*!
 * @brief 服务端IP地址
 * @result 服务端IP地址
 */
- (NSString *)ipAddress;

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
        TCPListenDelegate
 
    @abstract
        TCP监听的协议消息
 
 ******************************************************/

@protocol TCPListenDelegate <NSObject>

/*!
 * @brief 监听到端口连接
 * @param listener 监听对象
 * @param handle Socket句柄
 */
- (void)TCPListener:(TCPListener *)listener didAcceptSocket:(CFSocketNativeHandle)handle;

@end
