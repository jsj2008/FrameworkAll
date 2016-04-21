//
//  AHServerTransaction.h
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHRequest.h"
#import "AHResponse.h"
#import "AHServerCode.h"

@protocol AHServerTransactionDelegate;


/*********************************************************
 
    @class
        AHServerTransaction
 
    @abstract
        HTTP事务
 
    @discussion
        HTTP事务负责对接收到的请求数据进行处理，并生成响应数据发往客户端
        1，HTTP事务内部实现了对请求数据接收的流程控制，可以实时指定是否继续接收数据，只有在允许继续接收的情况下才能接收到新数据
        2，HTTP事务可以随时关闭事务所在连接的输入和输出流
 
 *********************************************************/

@interface AHServerTransaction : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<AHServerTransactionDelegate> delegate;

/*!
 * @brief 取消
 */
- (void)cancel;

/*!
 * @brief 接收到请求头
 * @param requestHeader 请求头
 */
- (void)didReceiveRequestHeader:(AHRequestHeader *)requestHeader;

/*!
 * @brief 接收到请求主体数据（部分）
 * @param data 请求主体数据（部分），已经经过传输和压缩的解码处理
 */
- (void)didReceiveRequestBodyData:(NSData *)data;

/*!
 * @brief 接收到请求拖挂
 * @param trailer 请求拖挂
 */
- (void)didReceiveRequestTrailer:(NSDictionary *)trailer;

/*!
 * @brief 请求数据接收结束，在接收完毕和发生错误时都会调用本方法
 * @param code 状态码，表征接收过程的状态
 */
- (void)didFinishReceivingRequestWithCode:(AHServerCode)code;

/*!
 * @brief 继续接收请求数据
 * @discussion 如果停止接收，事务所在的连接将关闭输入流
 * @param continueReceiving 是否继续
 */
- (void)continueReceivingRequest:(BOOL)continueReceiving;

/*!
 * @brief 发送响应数据
 * @discussion 发送数据不实现流程控制
 * @param response 响应数据
 */
- (void)sendResponse:(AHResponse *)response;

/*!
 * @brief 已发送响应头
 */
- (void)didSendResponseHeader;

/*!
 * @brief 已发送响应主体数据
 * @param size 已发送的主体数据长度，发送流式数据时，将得到流内读走的数据长度
 */
- (void)didSendResponseBodySize:(unsigned long long)size;

/*!
 * @brief 响应数据发送结束，在发送完毕和发生错误时都会调用本方法
 * @param code 状态码，表征发送过程的状态
 */
- (void)didFinishSendingResponseWithCode:(AHServerCode)code;

@end


/*********************************************************
 
    @protocol
        AHServerTransactionDelegate
 
    @abstract
        HTTP事务代理协议
 
 *********************************************************/

@protocol AHServerTransactionDelegate <NSObject>

/*!
 * @brief 事务结束
 * @param transaction 事务
 * @param close 是否需要关闭连接
 */
- (void)AHServerTransaction:(AHServerTransaction *)transaction didFinishAndWillCloseConnection:(BOOL)close;

/*!
 * @brief 是否允许继续接收数据
 * @param transaction 事务
 * @param can 是否允许连接继续接收数据
 */
- (void)AHServerTransaction:(AHServerTransaction *)transaction canReceiveData:(BOOL)can;

/*!
 * @brief 发送响应数据
 * @param transaction 事务
 * @param response 响应数据
 */
- (void)AHServerTransaction:(AHServerTransaction *)transaction sendResponse:(AHResponse *)response;

@end
