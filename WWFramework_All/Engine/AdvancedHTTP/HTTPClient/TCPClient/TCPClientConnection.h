//
//  TCPClientConnection.h
//  Application
//
//  Created by WW on 14-4-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCPClientConnectionDelegate;

/******************************************************
 
    @class
        TCPClientConnection
 
    @abstract
        TCP连接，负责数据接收发送，流的开关等
 
    @discussion
        1. TCPConnection必须执行start方法才能正确启动，且只能启动一次，若启动失败，则无法再次正确启动
        2. TCPConnection执行cancel方法后，将彻底关闭所有相关资源，无法再次启动
 
 ******************************************************/

@interface TCPClientConnection : NSObject <NSStreamDelegate>
{
    // 服务器端主机
    NSString *_host;
    
    // 服务器端端口
    UInt32 _port;
}

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<TCPClientConnectionDelegate> delegate;

/*!
 * @brief 初始化
 * @param host 服务器端主机ip或域名
 * @param port 服务器端主机端口
 * @result 初始化后的对象
 */
- (id)initWithHost:(NSString *)host port:(unsigned long)port;

/*!
 * @brief 启动
 * @discussion 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 取消
 */
- (void)cancel;

/*!
 * @brief 关闭输入流
 */
- (void)closeInputStream;

/*!
 * @brief 输入流是否关闭
 * @result 输入流是否关闭
 */
- (BOOL)isInputStreamClosed;

/*!
 * @brief 关闭输出流
 */
- (void)closeOutputStream;

/*!
 * @brief 输出流是否关闭
 * @result 输出流是否关闭
 */
- (BOOL)isOutputStreamClosed;

/*!
 * @brief 发送数据
 * @param data 数据
 */
- (void)sendData:(NSData *)data;

/*!
 * @brief 读取数据
 * @result 数据
 */
- (NSData *)readData;

@end


/******************************************************
 
    @protocol
        TCPServerConnectionDelegate
 
    @abstract
        TCP连接的协议消息
 
 ******************************************************/

@protocol TCPClientConnectionDelegate <NSObject>

/*!
 * @brief 可接收新数据
 * @param connection TCP连接
 */
- (void)TCPClientConnectionCanReadData:(TCPClientConnection *)connection;

/*!
 * @brief 可发送新数据
 * @param connection TCP连接
 */
- (void)TCPClientConnectionCanSendData:(TCPClientConnection *)connection;

/*!
 * @brief 客户端关闭本方输入流
 * @param connection TCP连接
 * @param error 错误信息。若为nil，表示正常关闭
 */
- (void)TCPClientConnection:(TCPClientConnection *)connection inputStreamDidCloseByPeerWithError:(NSError *)error;

/*!
 * @brief 客户端关闭本方输出流
 * @param connection TCP连接
 * @param error 错误信息。若为nil，表示正常关闭
 */
- (void)TCPClientConnection:(TCPClientConnection *)connection outputStreamDidCloseByPeerWithError:(NSError *)error;

@end


/*!
 * @brief TCP连接的每个流循环允许发送的最大数据长度，1K字节
 */
extern NSUInteger const TCPClientConnectionMaxSendingDataLengthPerStreamLoop;
