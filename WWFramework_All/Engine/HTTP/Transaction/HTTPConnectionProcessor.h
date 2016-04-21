//
//  HTTPConnectionProcessor.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTransactionCode.h"

@protocol HTTPConnectionProcessorDelegate;


/*********************************************************
 
    @class
        HTTPConnectionProcessor
 
    @abstract
        HTTP连接处理器，在NSURLConnection之上的一层简单封装
 
    @discussion
        HTTP连接运行过程中，会通过代理协议向代理对象发送关于连接的消息
 
 *********************************************************/

@interface HTTPConnectionProcessor : NSObject <NSURLConnectionDataDelegate>

/*!
 * @brief 初始化
 * @param URLRequest 请求
 * @result 初始化后的对象
 */
- (id)initWithURLRequest:(NSURLRequest *)URLRequest;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPConnectionProcessorDelegate> delegate;

/*!
 * @brief 启动运行
 */
- (void)run;

/*!
 * @brief 取消
 */
- (void)cancel;

@end


/*********************************************************
 
    @protocol
        HTTPConnectionProcessorDelegate
 
    @abstract
        HTTP连接处理器代理协议
 
 *********************************************************/

@protocol HTTPConnectionProcessorDelegate <NSObject>

/*!
 * @brief 连接结束
 * @param processor 连接处理器
 * @param code 事务码
 */
- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didFinishWithCode:(HTTPTransactionCode)code;

/*!
 * @brief 接收到响应头
 * @param processor 连接处理器
 * @param response 响应头
 */
- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didReceiveURLResponse:(NSHTTPURLResponse *)response;

/*!
 * @brief 接收到响应数据
 * @param processor 连接处理器
 * @param data 响应数据
 */
- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didReceiveResponseBodyData:(NSData *)data;

/*!
 * @brief 发送数据
 * @param processor 连接处理器
 * @param bytesWritten 本次发送字节数
 * @param totalBytesWritten 已发送总字节数
 * @param totalBytesExpectedToWrite 需发送总字节数
 */
- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end
