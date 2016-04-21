//
//  HTTPTransaction.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"
#import "HTTPResponse.h"
#import "HTTPTransactionCode.h"
#import "HTTPConnectionProcessor.h"

@protocol HTTPTransactionDelegate;


/*********************************************************
 
    @class
        HTTPTransaction
 
    @abstract
        HTTP事务，与服务器一次请求和响应的封装
 
    @discussion
        HTTP事务运行过程中，会通过代理协议向代理对象发送关于事务的消息
 
 *********************************************************/

@interface HTTPTransaction : NSObject <HTTPConnectionProcessorDelegate>

/*!
 * @brief 初始化
 * @param request 请求
 * @result 初始化后的对象
 */
- (id)initWithRequest:(HTTPRequest *)request;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPTransactionDelegate> delegate;

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
        HTTPTransactionDelegate
 
    @abstract
        HTTP事务代理协议
 
 *********************************************************/

@protocol HTTPTransactionDelegate <NSObject>

@required

/*!
 * @brief 事务结束
 * @param transaction 事务
 * @param code 事务码
 */
- (void)HTTPTransaction:(HTTPTransaction *)transaction didFinishWithCode:(HTTPTransactionCode)code;

@optional

/*!
 * @brief 接收到响应头
 * @param transaction 事务
 * @param URLResponse 响应头
 */
- (void)HTTPTransaction:(HTTPTransaction *)transaction didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 接收到响应数据
 * @param transaction 事务
 * @param data 响应数据
 */
- (void)HTTPTransaction:(HTTPTransaction *)transaction didReceiveResponseBodyData:(NSData *)data;

/*!
 * @brief 发送数据
 * @discussion 发送数据流时，采用chunked传输或者采用压缩，则无法准确计算传输进度
 * @param transaction 事务
 * @param bytesWritten 本次发送字节数
 * @param totalBytesWritten 已发送总字节数
 * @param totalBytesExpectedToWrite 需发送总字节数
 */
- (void)HTTPTransaction:(HTTPTransaction *)transaction didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end


/*********************************************************
 
    @category
        HTTPTransaction (HTTPNetService)
 
    @abstract
        HTTP事务，封装网络服务的处理
 
 *********************************************************/


@interface HTTPTransaction (HTTPNetService)

/*!
 * @brief 因网络服务不可用而终止
 */
- (void)finishByNetServiceUnavailable;

@end
