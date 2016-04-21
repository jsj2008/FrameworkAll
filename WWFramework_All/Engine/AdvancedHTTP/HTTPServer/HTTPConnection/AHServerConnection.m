//
//  AHServerConnection.m
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerConnection.h"
#import "SPTaskDispatcher.h"
#import "Notifier.h"
#import "AHServerConnectionReceivingStream.h"
#import "AHServerConnectionRequestOutput.h"

@interface AHServerConnection ()
{
    // 数据接收和处理流
    AHServerConnectionReceivingStream *_receivingStream;
    
    // 负责响应时序的HTTP事务任务数组
    NSMutableArray *_transactionTaskQueueForReponse;
    
    // 当前是否可以从TCP流中接收数据，用于维持和HTTP事务接收数据之间的时序
    BOOL _canReceiveData;
    
    // 正在发送的数据大小
    NSUInteger _outputDataSizeSending;
    
    // 输入挂起标志
    BOOL _inputSuspended;
    
    // 输出挂起标志
    BOOL _outputSuspended;
}

/*!
 * @brief HTTP事务任务调度器
 */
@property (nonatomic) SPTaskDispatcher *dispatcher;

/*!
 * @brief TCP连接
 */
@property (nonatomic) TCPConnection *TCPConnection;

/*!
 * @brief 当前接收请求的HTTP事务任务
 */
@property (nonatomic) AHServerTransactionTask *currentRequestTask;

/*!
 * @brief 关闭连接
 */
- (void)finish;

/*!
 * @brief 从输入流读取和处理流内数据
 */
- (void)readData;

/*!
 * @brief 向输出流发送数据
 * @param data 待发送的数据
 */
- (void)sendData:(NSData *)data;

@end


@implementation AHServerConnection

- (id)initWithTCPConnection:(TCPConnection *)connection
{
    if (self = [super init])
    {
        self.TCPConnection = connection;
        
        self.TCPConnection.delegate = self;
        
        _receivingStream = [[AHServerConnectionReceivingStream alloc] init];
        
        _transactionTaskQueueForReponse = [[NSMutableArray alloc] init];
        
        _canReceiveData = YES;
    }
    
    return self;
}

- (BOOL)start
{
    BOOL success = NO;
    
    if ([self.TCPConnection start])
    {
        success = YES;
        
        self.dispatcher = [[SPTaskDispatcher alloc] init];
        
        if (self.configuration.taskPool)
        {
            [self.dispatcher setDaemonTaskPool:self.configuration.taskPool];
        }
    }
    else
    {
        [self stop];
    }
    
    return success;
}

- (void)stop
{
    self.TCPConnection.delegate = nil;
    
    [self.TCPConnection cancel];
    
    self.TCPConnection = nil;
    
    [_receivingStream resetOutput];
    
    [_transactionTaskQueueForReponse removeAllObjects];
    
    [self.dispatcher cancel];
}

- (void)suspendReceiving
{
    _inputSuspended = YES;
}

- (void)resumeReceiving
{
    _inputSuspended = NO;
    
    [self readData];
}

- (void)suspendSending
{
    _outputSuspended = YES;
}

- (void)resumeSending
{
    _outputSuspended = NO;
    
    [self sendData:nil];
}

- (void)finish
{
    [self stop];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerConnectionDidFinish:)])
    {
        [self.delegate AHServerConnectionDidFinish:self];
    }
}

- (void)TCPConnectionCanReadData:(TCPConnection *)connection
{
    [self readData];
}

- (void)TCPConnectionCanSendData:(TCPConnection *)connection
{
    self.outputDataSize += _outputDataSizeSending;
    
    _outputDataSizeSending = 0;
    
    [self sendData:nil];
}

- (void)TCPConnection:(TCPConnection *)connection inputStreamDidCloseByPeerWithError:(NSError *)error
{
    // 输入流被关闭时，需在所有HTTP事务任务完成时关闭连接
    
    if ([self.TCPConnection isInputStreamClosed] && [[self.dispatcher allAsyncTasks] count] == 0)
    {
        [self finish];
    }
    else
    {
        // 对正在执行的HTTP事务任务，发送输入流关闭消息，由HTTP事务任务自行处理
        for (AHServerTransactionTask *task in [self.dispatcher allAsyncTasks])
        {
            [Notifier notify:^{
                
                [task connectionInputDidBeClosedByCode:AHServerCode_ConnectionStream_InputClosedByClient error:error];
            } onThread:[task runningThread]];
        }
    }
}

- (void)TCPConnection:(TCPConnection *)connection outputStreamDidCloseByPeerWithError:(NSError *)error
{
    // 输出流被关闭时，此时再接收数据也是无用的，应当关闭整个连接
    [self finish];
}

- (void)AHServerTransactionTaskDidFinish:(AHServerTransactionTask *)task
{
    [self.dispatcher removeTask:task];
    
    [_transactionTaskQueueForReponse removeObject:task];
    
    // 检查输入流连接情况，当输入流被关闭且所有HTTP事务任务都结束时，关闭连接
    if ([self.TCPConnection isInputStreamClosed] && [[self.dispatcher allAsyncTasks] count] == 0)
    {
        [self finish];
    }
}

- (void)AHServerTransactionTaskCanReceiveData:(AHServerTransactionTask *)task
{
    [self readData];
}

- (void)AHServerTransactionTaskHaveDataToSend:(AHServerTransactionTask *)task
{
    [self sendData:nil];
}

- (void)AHServerTransactionTask:(AHServerTransactionTask *)task sendResponseData:(NSData *)data
{
    [self sendData:data];
}

- (void)AHServerTransactionTaskStopConnectionInput:(AHServerTransactionTask *)task
{
    // 这里不需要判断输入流状态并关闭连接，在本方法之后会得到task的结束通知，在那里做关闭处理
    
    [self.TCPConnection closeInputStream];
    
    NSMutableArray *notifyingTasks = [NSMutableArray arrayWithArray:[self.dispatcher allAsyncTasks]];
    
    [notifyingTasks removeObject:task];
    
    for (AHServerTransactionTask *task in notifyingTasks)
    {
        [Notifier notify:^{
            
            [task connectionInputDidBeClosedByCode:AHServerCode_ConnectionStream_InputClosedByServer error:nil];
        } onThread:[task runningThread]];
    }
}

- (void)AHServerTransactionTaskStopConnection:(AHServerTransactionTask *)task
{
    [self finish];
}

- (void)readData
{
    if (_canReceiveData && !_inputSuspended)
    {
        // 数据接收流在接收数据后，根据解析进度，可生成多份输出，只有在无输出时，才需要从TCP流中读取数据，否则会破坏HTTP事务任务对时序的控制
        
        AHServerConnectionRequestOutput *output = [_receivingStream output];
        
        if (!output)
        {
            NSMutableData *data = [NSMutableData data];
            
            NSData *TCPData = [self.TCPConnection readData];
            
            if ([TCPData length])
            {
                [data appendData:TCPData];
                
                self.inputDataSize += [TCPData length];
                
                [_receivingStream writeData:data];
            }
            
            output = [_receivingStream output];
        }
        
        AHServerCode code = [_receivingStream streamCode];
        
        if (code != AHServerCode_OK)
        {
            [self.TCPConnection closeInputStream];
            
            for (AHServerTransactionTask *task in [self.dispatcher allAsyncTasks])
            {
                [Notifier notify:^{
                    
                    [task connectionInputDidBeClosedByCode:code error:nil];
                } onThread:[task runningThread]];
            }
        }
        else if (output)
        {
            if ([output isKindOfClass:[AHServerConnectionRequestHeaderOutput class]])
            {
                AHServerTransactionTask *newTask = [[AHServerTransactionTask alloc] initWithRequestHeader:((AHServerConnectionRequestHeaderOutput *)output).header configuration:self.configuration];
                
                newTask.delegate = self;
                
                newTask.notifyThread = [NSThread currentThread];
                
                self.currentRequestTask = newTask;
                
                [_transactionTaskQueueForReponse addObject:newTask];
                
                [self.dispatcher asyncAddTask:newTask];
            }
            else if ([output isKindOfClass:[AHServerConnectionRequestBodyDataOutput class]])
            {
                [Notifier notify:^{
                    
                    [self.currentRequestTask didReceiveRequestData:((AHServerConnectionRequestBodyDataOutput *)output).data];
                } onThread:[self.currentRequestTask runningThread]];
            }
            else if ([output isKindOfClass:[AHServerConnectionRequestTrailerOutput class]])
            {
                [Notifier notify:^{
                    
                    [self.currentRequestTask didReceiveRequestTrailer:((AHServerConnectionRequestTrailerOutput *)output).trailer];
                } onThread:[self.currentRequestTask runningThread]];
            }
            else if ([output isKindOfClass:[AHServerConnectionRequestFinishingOutput class]])
            {
                [Notifier notify:^{
                    
                    [self.currentRequestTask didFinishReceivingRequest];
                } onThread:[self.currentRequestTask runningThread]];
            }
            
            _canReceiveData = NO;
        }
        else
        {
            // 无输出时才允许从流中接收数据，否则TCP流会激发数据的读取和处理操作，在HTTP事务任务未允许的情况下向其发送数据
            _canReceiveData = YES;
        }
    }
}

- (void)sendData:(NSData *)data
{
    if ([data length])
    {
        _outputDataSizeSending = [data length];
        
        [self.TCPConnection sendData:data];
    }
    else if ([_transactionTaskQueueForReponse count])
    {
        if (!_outputSuspended)
        {
            AHServerTransactionTask *task = [_transactionTaskQueueForReponse objectAtIndex:0];
            
            [Notifier notify:^{
                
                [task canSendResponseDataOfMaxLength:TCPConnectionMaxSendingDataLengthPerStreamLoop];
            } onThread:[task runningThread]];
        }
    }
}

@end
