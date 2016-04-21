//
//  TCPClientConnection.m
//  Application
//
//  Created by WW on 14-4-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "TCPClientConnection.h"

@interface TCPClientConnection ()
{
    // 输入流
    NSInputStream *_inputStream;
    
    // 输出流
    NSOutputStream *_outputStream;
    
    // 连接是否已开启
    BOOL _connectionGone;
}

/*!
 * @brief run loop
 */
@property (nonatomic) NSRunLoop *runLoop;

/*!
 * @brief 释放流
 * @discussion 在这里彻底释放流相关资源
 * @param stream 流
 */
- (void)releaseStream:(NSStream *)stream;

/*!
 * @brief 结束流
 * @param stream 流
 * @param error 错误信息
 */
- (void)finishStream:(NSStream *)stream byPeerWithError:(NSError *)error;

/*!
 * @brief 发送数据
 */
- (void)sendData;

/*!
 * @brief 接收数据
 */
- (void)receiveData;

@end


@implementation TCPClientConnection

- (id)initWithHost:(NSString *)host port:(unsigned long)port
{
    if (self = [super init])
    {
        _host = [host copy];
        
        _port = (UInt32)port;
    }
    
    return self;
}

- (void)releaseStream:(NSStream *)stream
{
    if (stream)
    {
        [stream close];
        
        [stream removeFromRunLoop:self.runLoop forMode:NSDefaultRunLoopMode];
        
        [stream setDelegate:nil];
    }
}

- (BOOL)start
{
    BOOL success = NO;
    
    if (_inputStream && _outputStream && _connectionGone)
    {
        success = YES;
    }
    else if (!_connectionGone)
    {
        self.runLoop = [NSRunLoop currentRunLoop];
        
        CFReadStreamRef readStream;
        
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)_host, _port, &readStream, &writeStream);
        
        _inputStream = (__bridge NSInputStream *)readStream;
        
        _outputStream = (__bridge NSOutputStream *)writeStream;
        
        CFReadStreamSetProperty((CFReadStreamRef)_inputStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        CFWriteStreamSetProperty((CFWriteStreamRef)_outputStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        [_inputStream open];
        
        [_outputStream open];
        
        if (_inputStream && _outputStream && [_inputStream streamStatus] != NSStreamStatusError && [_outputStream streamStatus] != NSStreamStatusError)
        {
            [_inputStream setDelegate:self];
            
            [_outputStream setDelegate:self];
            
            [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            success = YES;
            
            _connectionGone = YES;
        }
        else
        {
            [self releaseStream:_inputStream]; _inputStream = nil;
            
            [self releaseStream:_outputStream]; _outputStream = nil;
        }
    }
    
    return success;
}

- (void)cancel
{
    [self closeInputStream];
    
    [self closeOutputStream];
}

- (void)closeInputStream
{
    [self releaseStream:_inputStream]; _inputStream = nil;
}

- (BOOL)isInputStreamClosed
{
    return (_inputStream == nil);
}

- (void)closeOutputStream
{
    [self releaseStream:_outputStream]; _outputStream = nil;
}

- (BOOL)isOutputStreamClosed
{
    return (_outputStream == nil);
}

- (void)finishStream:(NSStream *)stream byPeerWithError:(NSError *)error
{
    if (stream == _inputStream && _inputStream)
    {
        [self releaseStream:_inputStream]; _inputStream = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPClientConnection:inputStreamDidCloseByPeerWithError:)])
        {
            [self.delegate TCPClientConnection:self inputStreamDidCloseByPeerWithError:error];
        }
    }
    else if (stream == _outputStream && _outputStream)
    {
        [self releaseStream:_outputStream]; _outputStream = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPClientConnection:outputStreamDidCloseByPeerWithError:)])
        {
            [self.delegate TCPClientConnection:self outputStreamDidCloseByPeerWithError:error];
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasSpaceAvailable:
        {
            if (aStream == _outputStream && _outputStream)
            {
                [self sendData];
            }
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (aStream == _inputStream && _inputStream)
            {
                [self receiveData];
            }
            break;
        }
        case NSStreamEventEndEncountered:
        {
            if (aStream == _inputStream && _inputStream)
            {
                [self receiveData];
            }
            
            [self finishStream:aStream byPeerWithError:nil];
            
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            [self finishStream:aStream byPeerWithError:[aStream streamError]];
            
            break;
        }
        default:
            break;
    }
}

- (void)sendData:(NSData *)data
{
    if (_outputStream && [data length])
    {
        [_outputStream write:[data bytes] maxLength:[data length]];
    }
}

- (NSData *)readData
{
    NSData *data = nil;
    
    if (_inputStream)
    {
        uint8_t buf[16 * 1024];
        
        NSInteger len = 0;
        
        if ([_inputStream hasBytesAvailable])
        {
            len = [_inputStream read:buf maxLength:sizeof(buf)];
        }
        
        if (len > 0)
        {
            data = [NSData dataWithBytes:buf length:len];
        }
    }
    
    return data;
}

- (void)sendData
{
    if (_outputStream && self.delegate && [self.delegate respondsToSelector:@selector(TCPClientConnectionCanReadData:)])
    {
        [self.delegate TCPClientConnectionCanReadData:self];
    }
}

- (void)receiveData
{
    if (_inputStream && self.delegate && [self.delegate respondsToSelector:@selector(TCPClientConnectionCanReadData:)])
    {
        [self.delegate TCPClientConnectionCanReadData:self];
    }
}

@end


NSUInteger const TCPClientConnectionMaxSendingDataLengthPerStreamLoop = 1 * 1024;
