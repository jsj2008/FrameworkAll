//
//  AHServerTransactionTask.m
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerTransactionTask.h"
#import "AHServerResponseStream.h"

/*********************************************************
 
    @enum
        AHServerTransactionTaskRunStatus
 
    @abstract
        HTTP事务任务内部的运行状态类型
 
 *********************************************************/

typedef enum
{
    AHServerTransactionTaskRunStatus_Request  = 1,  // 接收请求
    AHServerTransactionTaskRunStatus_Response = 2   // 发送请求
}AHServerTransactionTaskRunStatus;


@interface AHServerTransactionTask ()
{
    // 运行状态，用于管理接收到连接的输入输出流关闭消息后的处理
    AHServerTransactionTaskRunStatus _runStatus;
}

/*!
 * @brief HTTP事务
 */
@property (nonatomic) AHServerTransaction *transaction;

/*!
 * @brief 响应流，负责对原始响应数据进行处理
 */
@property (nonatomic) AHServerResponseStream *responseStream;

/*!
 * @brief 任务结束
 * @param close 是否需要关闭连接
 */
- (void)finishWithClosingConnection:(BOOL)close;

@end


@implementation AHServerTransactionTask

- (id)initWithRequestHeader:(AHRequestHeader *)header configuration:(AHServerConfiguration *)configuration
{
    if (self = [super init])
    {
        _runStatus = AHServerTransactionTaskRunStatus_Request;
        
        self.transaction = configuration.transactionTemplate ? [[[configuration.transactionTemplate class] alloc] init] : [[AHServerTransaction alloc] init];
        
        self.transaction.delegate = self;
        
        [self.transaction performSelector:@selector(didReceiveRequestHeader:) onThread:[NSThread currentThread] withObject:header waitUntilDone:NO];
    }
    
    return self;
}

- (void)cancel
{
    self.transaction.delegate = nil;
    
    [self.transaction cancel];
    
    self.transaction = nil;
    
    [super cancel];
}

- (void)finishWithClosingConnection:(BOOL)close
{
    [self cancel];
    
    if (close)
    {
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTaskStopConnection:)])
            {
                [self.delegate AHServerTransactionTaskStopConnection:self];
            }
        }];
    }
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTaskDidFinish:)])
        {
            [self.delegate AHServerTransactionTaskDidFinish:self];
        }
    }];
}

- (void)didReceiveRequestData:(NSData *)data
{
    [self.transaction didReceiveRequestBodyData:data];
}

- (void)didReceiveRequestTrailer:(NSDictionary *)trailer
{
    [self.transaction didReceiveRequestTrailer:trailer];
}

- (void)didFinishReceivingRequest
{
    _runStatus = AHServerTransactionTaskRunStatus_Response;
    
    [self.transaction didFinishReceivingRequestWithCode:AHServerCode_OK];
}

- (void)canSendResponseDataOfMaxLength:(NSUInteger)maxLength
{
    // 只有在发送下一批数据时才能确定前一批数据已发送
    
    AHServerCode streamCode = [self.responseStream streamCode];
    
    if (streamCode != AHServerCode_OK)
    {
        [self.transaction didFinishSendingResponseWithCode:streamCode];
    }
    else
    {
        if ([self.responseStream isOver])
        {
            [self.transaction didSendResponseBodySize:[self.responseStream bodyTotalReadSize]];
            
            [self notify:^{
                
                [self.transaction didFinishSendingResponseWithCode:AHServerCode_OK];
            } onThread:[NSThread currentThread]];
        }
        else
        {
            unsigned long long beforeSize = [self.responseStream bodyTotalReadSize];
            
            NSData *data = [self.responseStream readDataOfMaxLength:maxLength];
            
            if ([self.responseStream streamCode] != AHServerCode_OK)
            {
                [self.transaction didFinishSendingResponseWithCode:AHServerCode_OK];
            }
            else
            {
                [self notify:^{
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTask:sendResponseData:)])
                    {
                        [self.delegate AHServerTransactionTask:self sendResponseData:data];
                    }
                }];
                
                unsigned long long afterSize = [self.responseStream bodyTotalReadSize];
                
                if (beforeSize > 0)
                {
                    [self.transaction didSendResponseBodySize:beforeSize];
                }
                else if (afterSize > 0)
                {
                    [self.transaction didSendResponseHeader];
                }
            }
        }
    }
}

- (void)connectionInputDidBeClosedByCode:(AHServerCode)code error:(NSError *)error
{
    if (_runStatus == AHServerTransactionTaskRunStatus_Request)
    {
        [self.transaction didFinishReceivingRequestWithCode:code];
    }
}

- (void)AHServerTransaction:(AHServerTransaction *)transaction didFinishAndWillCloseConnection:(BOOL)close
{
    [self finishWithClosingConnection:close];
}

- (void)AHServerTransaction:(AHServerTransaction *)transaction canReceiveData:(BOOL)can
{
    if (can)
    {
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTaskCanReceiveData:)])
            {
                [self.delegate AHServerTransactionTaskCanReceiveData:self];
            }
        }];
    }
    else
    {
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTaskStopConnectionInput:)])
            {
                [self.delegate AHServerTransactionTaskStopConnectionInput:self];
            }
        }];
    }
}

- (void)AHServerTransaction:(AHServerTransaction *)transaction sendResponse:(AHResponse *)response
{
    self.responseStream = [[AHServerResponseStream alloc] initWithResponse:response];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransactionTaskHaveDataToSend:)])
        {
            [self.delegate AHServerTransactionTaskHaveDataToSend:self];
        }
    }];
}

@end
