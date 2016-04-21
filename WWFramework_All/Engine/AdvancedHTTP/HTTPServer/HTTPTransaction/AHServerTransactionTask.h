//
//  AHServerTransactionTask.h
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "SPTask.h"
#import "AHRequest.h"
#import "AHResponse.h"
#import "AHServerTransaction.h"
#import "AHServerCode.h"
#import "AHServerConfiguration.h"

/*********************************************************
 
    @class
        AHServerTransactionTask
 
    @abstract
        HTTP事务任务，封装了HTTP连接和HTTP事务之间的数据流程
 
 *********************************************************/

@interface AHServerTransactionTask : SPTask <AHServerTransactionDelegate>

/*!
 * @brief 初始化
 * @param header 请求头
 * @param configuration 配置项
 * @result 初始化后的对象
 */
- (id)initWithRequestHeader:(AHRequestHeader *)header configuration:(AHServerConfiguration *)configuration;

/*!
 * @brief 接收到请求主体数据（部分）
 * @param data 请求主体数据（部分），已经经过传输和压缩的解码处理
 */
- (void)didReceiveRequestData:(NSData *)data;

/*!
 * @brief 接收到请求拖挂
 * @param trailer 请求拖挂
 */
- (void)didReceiveRequestTrailer:(NSDictionary *)trailer;

/*!
 * @brief 请求数据接收结束
 */
- (void)didFinishReceivingRequest;

/*!
 * @brief 可以发送响应数据
 * @param maxLength 本次可发送的数据最大长度
 */
- (void)canSendResponseDataOfMaxLength:(NSUInteger)maxLength;

/*!
 * @brief 连接的输入流被关闭
 * @param code 状态码
 * @param error 错误描述，这只是一个辅助性的错误描述，并不是所有的状态码都有一个错误描述对应
 */
- (void)connectionInputDidBeClosedByCode:(AHServerCode)code error:(NSError *)error;

@end


/*********************************************************
 
    @protocol
        AHServerTransactionTaskDelegate
 
    @abstract
        HTTP事务任务的代理协议
 
 *********************************************************/

@protocol AHServerTransactionTaskDelegate <NSObject>

/*!
 * @brief 任务结束
 * @param task 任务
 */
- (void)AHServerTransactionTaskDidFinish:(AHServerTransactionTask *)task;

/*!
 * @brief 允许继续接收数据
 * @param task 任务
 */
- (void)AHServerTransactionTaskCanReceiveData:(AHServerTransactionTask *)task;

/*!
 * @brief 任务有数据需发送
 * @param task 任务
 */
- (void)AHServerTransactionTaskHaveDataToSend:(AHServerTransactionTask *)task;

/*!
 * @brief 发送数据
 * @param task 任务
 * @param data 数据，已经过传输和压缩编码处理
 */
- (void)AHServerTransactionTask:(AHServerTransactionTask *)task sendResponseData:(NSData *)data;

/*!
 * @brief 关闭连接的输入流
 * @param task 任务
 */
- (void)AHServerTransactionTaskStopConnectionInput:(AHServerTransactionTask *)task;

/*!
 * @brief 关闭连接的输出流
 * @param task 任务
 */
- (void)AHServerTransactionTaskStopConnection:(AHServerTransactionTask *)task;

@end
