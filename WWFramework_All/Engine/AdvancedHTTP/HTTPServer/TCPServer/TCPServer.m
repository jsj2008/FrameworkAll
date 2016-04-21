//
//  TCPServer.m
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TCPServer.h"
#import "TCPConnection.h"

@interface TCPServer ()

/*!
 * @brief TCP监听器
 */
@property (nonatomic) TCPListener *listener;

@end


@implementation TCPServer

@synthesize delegate;

- (void)dealloc
{
    if (self.listener)
    {
        [self.listener stop];
    }
}

- (id)initWithPort:(NSUInteger)port
{
    if (self = [super init])
    {
        _port = port;
    }
    
    return self;
}

- (NSString *)serverIPAddress
{
    return self.listener ? [self.listener ipAddress] : nil;
}

- (NSInteger)currentIPV4Port
{
    return self.listener ? [self.listener currentIPV4Port] : 0;
}

- (BOOL)start
{
    TCPListener *listener1 = [[TCPListener alloc] initWithPort:_port];
    
    listener1.delegate = self;
    
    BOOL success = [listener1 start];
    
    if (success)
    {
        self.listener = listener1;
    }
    else
    {
        [listener1 stop];
    }
    
    return success;
}

- (void)stop
{
    [self.listener stop];
    
    self.listener = nil;
}

- (void)TCPListener:(TCPListener *)listener didAcceptSocket:(CFSocketNativeHandle)handle
{
    if (handle != -1)
    {
        TCPConnection *connection = [[TCPConnection alloc] initWithNativeHandle:handle];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPServer:didAcceptConnection:)])
        {
            [self.delegate TCPServer:self didAcceptConnection:connection];
        }
    }
}

@end
