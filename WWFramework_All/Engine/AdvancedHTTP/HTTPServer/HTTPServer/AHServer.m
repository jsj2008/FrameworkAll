//
//  AHServer.m
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServer.h"

@interface AHServer ()
{
    // 目标端口，不一定与实际端口一致
    NSUInteger _port;
    
    // HTTP连接
    NSMutableArray *_connections;
    
    // 已结束的连接接收到的数据大小
    unsigned long long _overedConnectionReceivedDataSize;
    
    // 已结束的连接发送的数据大小
    unsigned long long _overedConnectionSentDataSize;
}

@property (nonatomic) TCPServer *TCPServer;

@end


@implementation AHServer

- (id)initWithPort:(NSUInteger)port
{
    if (self = [super init])
    {
        _port = port;
        
        _connections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)start
{
    BOOL success = NO;
    
    TCPServer *server = [[TCPServer alloc] initWithPort:_port];
    
    if ([server start])
    {
        self.TCPServer = server;
        
        self.TCPServer.delegate = self;
        
        success = YES;
    }
    else
    {
        [server stop];
    }
    
    return self;
}

- (void)stop
{
    [self.TCPServer stop];
    
    self.TCPServer = nil;
    
    for (AHServerConnection *connection in _connections)
    {
        [connection stop];
    }
    
    [_connections removeAllObjects];
}

- (NSString *)serverIPAddress
{
    return [self.TCPServer serverIPAddress];
}

- (NSInteger)currentIPV4Port
{
    return [self.TCPServer currentIPV4Port];
}

- (void)TCPServer:(TCPServer *)server didAcceptConnection:(TCPConnection *)connection
{
    AHServerConnection *HTTPConnection = [[AHServerConnection alloc] initWithTCPConnection:connection];
    
    HTTPConnection.configuration = self.configuration;
    
    HTTPConnection.delegate = self;
    
    if ([HTTPConnection start])
    {
        [_connections addObject:HTTPConnection];
    }
    else
    {
        [HTTPConnection stop];
    }
}

- (void)AHServerConnectionDidFinish:(AHServerConnection *)connection
{
    _overedConnectionReceivedDataSize += [connection inputDataSize];
    
    _overedConnectionSentDataSize += [connection outputDataSize];
    
    [_connections removeObject:connection];
}

- (unsigned long long)totalReceivedDataSize
{
    unsigned long long activeConnectionReceivedDataSize = 0;
    
    for (AHServerConnection *connection in _connections)
    {
        activeConnectionReceivedDataSize += [connection inputDataSize];
    }
    
    return (_overedConnectionReceivedDataSize + activeConnectionReceivedDataSize);
}

- (unsigned long long)totalSentDataSize
{
    unsigned long long activeConnectionSentDataSize = 0;
    
    for (AHServerConnection *connection in _connections)
    {
        activeConnectionSentDataSize += [connection outputDataSize];
    }
    
    return (_overedConnectionSentDataSize + activeConnectionSentDataSize);
}

- (void)suspendReceiving
{
    for (AHServerConnection *connection in _connections)
    {
        [connection suspendReceiving];
    }
}

- (void)resumeReceiving
{
    for (AHServerConnection *connection in _connections)
    {
        [connection resumeReceiving];
    }
}

- (void)suspendSending
{
    for (AHServerConnection *connection in _connections)
    {
        [connection suspendSending];
    }
}

- (void)resumeSending
{
    for (AHServerConnection *connection in _connections)
    {
        [connection resumeSending];
    }
}

@end
