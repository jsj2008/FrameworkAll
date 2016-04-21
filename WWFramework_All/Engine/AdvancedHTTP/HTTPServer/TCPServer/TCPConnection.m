//
//  TCPConnection.m
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TCPConnection.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@interface TCPConnection ()
{
    // 输入流
    NSInputStream *_inputStream;
    
    // 输出流
    NSOutputStream *_outputStream;
    
    // 客户端地址
    NSString *_address;
    
    // 服务端数据通讯端口
    NSInteger _port;
    
    // 本地数据通讯是否已开启
    BOOL _nativeHandleGone;
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

/*!
 * @brief 解析Socket句柄
 * @param address 客户端地址
 * @param port 服务端数据通讯端口
 * @param handle Socket句柄
 */
- (void)socketInfoWithAddress:(NSString **)address port:(NSInteger *)port fromNativeHandle:(CFSocketNativeHandle)handle;

@end


@implementation TCPConnection

@synthesize delegate;

- (void)dealloc
{
    [self releaseStream:_inputStream]; _inputStream = nil;
    
    [self releaseStream:_outputStream]; _outputStream = nil;
}

- (id)initWithNativeHandle:(CFSocketNativeHandle)handle
{
    if (self = [super init])
    {
        _nativeHandle = handle;
        
        NSString *address = _address;
        
        [self socketInfoWithAddress:&address port:&_port fromNativeHandle:_nativeHandle];
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
    
    if (_inputStream && _outputStream && _nativeHandleGone)
    {
        success = YES;
    }
    else if (!_nativeHandleGone)
    {
        self.runLoop = [NSRunLoop currentRunLoop];
        
        CFReadStreamRef readStream;
        
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, _nativeHandle, (CFReadStreamRef *)&readStream, (CFWriteStreamRef *)&writeStream);
        
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
            
            _nativeHandleGone = YES;
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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPConnection:inputStreamDidCloseByPeerWithError:)])
        {
            [self.delegate TCPConnection:self inputStreamDidCloseByPeerWithError:error];
        }
    }
    else if (stream == _outputStream && _outputStream)
    {
        [self releaseStream:_outputStream]; _outputStream = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPConnection:outputStreamDidCloseByPeerWithError:)])
        {
            [self.delegate TCPConnection:self outputStreamDidCloseByPeerWithError:error];
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

- (void)socketInfoWithAddress:(NSString **)address port:(NSInteger *)port fromNativeHandle:(CFSocketNativeHandle)handle
{
    if (_nativeHandle != -1)
    {
        uint8_t name[SOCK_MAXADDRLEN];
        
        socklen_t namelen = sizeof(name);
        
        NSData *peer = nil;
        
        if (0 == getpeername(_nativeHandle, (struct sockaddr *)name, &namelen))
        {
            peer = [NSData dataWithBytes:name length:namelen];
        }
        
        if (peer)
        {
            // ipv4 length = 16； ipv6 length = 28
            if ([peer length] < 20)
            {
                struct sockaddr_in add4;
                
                memcpy(&add4, [peer bytes], [peer length]);
                
                unsigned char *p = (unsigned char *)&(add4.sin_addr.s_addr);
                
                *address = [NSString stringWithFormat:@"%d.%d.%d.%d", p[0], p[1], p[2], p[3]];
                
                *port = ntohs(add4.sin_port);
            }
            else
            {
                struct sockaddr_in6 add6;
                
                char addressChar[16];
                
                memcpy(&add6, [peer bytes], [peer length]);
                
                if (inet_ntop(AF_INET6, &add6, addressChar, sizeof(addressChar)/sizeof(char)))
                {
                    *address = [NSString stringWithCString:addressChar encoding:NSUTF8StringEncoding];
                    
                    *port = ntohs(add6.sin6_port);
                }
                else
                {
                    *address = nil;
                    
                    *port = 0;
                }
            }
        }
    }
}

- (NSString *)socketAddress
{
    return [_address copy];
}

- (NSUInteger)socketPort
{
    return _port;
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
    if (_outputStream && self.delegate && [self.delegate respondsToSelector:@selector(TCPConnectionCanSendData:)])
    {
        [self.delegate TCPConnectionCanSendData:self];
    }
}

- (void)receiveData
{
    if (_inputStream && self.delegate && [self.delegate respondsToSelector:@selector(TCPConnectionCanReadData:)])
    {
        [self.delegate TCPConnectionCanReadData:self];
    }
}

@end


NSUInteger const TCPConnectionMaxSendingDataLengthPerStreamLoop = 16 * 1024;
