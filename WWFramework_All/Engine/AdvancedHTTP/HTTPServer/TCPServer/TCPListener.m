//
//  TCPListener.m
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TCPListener.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

@interface TCPListener ()
{
    // 服务端监听端口
    NSInteger _port4;
    
    // 服务端监听socket
    CFSocketRef _ipv4Socket;
}

/*!
 * @brief 释放服务端socket
 * @discussion 在这里彻底释放socket资源
 * @param socketRef 服务端socket
 */
- (void)releaseSocket:(CFSocketRef)socketRef;

/*!
 * @brief 接收客户端socket句柄
 * @param handle 客户端socket句柄
 */
- (void)acceptNativeHandle:(CFSocketNativeHandle)handle;

@end


static void SocketAcceptCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (type == kCFSocketAcceptCallBack)
    {
        CFSocketNativeHandle handle = *((CFSocketNativeHandle *)data);
        
        if (handle != -1)
        {
            TCPListener *socket = (__bridge TCPListener *)info;
            
            [socket acceptNativeHandle:handle];
        }
        else
        {
            close(handle);
        }
    }
}


@implementation TCPListener

@synthesize delegate;

- (void)dealloc
{
    [self releaseSocket:_ipv4Socket]; _ipv4Socket = NULL;
}

- (id)initWithPort:(NSInteger)port
{
    if (self = [super init])
    {
        _port4 = port;
    }
    
    return self;
}

- (void)releaseSocket:(CFSocketRef)socketRef
{
    if (socketRef)
    {
        CFSocketInvalidate(socketRef);
        
        CFRelease(socketRef);
    }
}

- (NSString *)ipAddress
{
    NSString *address = nil;
    
    int BUFFERSIZE = 4000;
    int MAXADDRS = 32;
    
    char *if_names[MAXADDRS];
    char *ip_names[MAXADDRS];
    unsigned long ip_addrs[MAXADDRS];
    
    static int   nextAddr = 0;
    
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin = NULL;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        return address;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        return address;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = (int)MAX(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;    // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;    // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;        // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;    /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;    // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return address;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return address;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
    
    address = [NSString stringWithCString:(char *)inet_ntoa(sin->sin_addr) encoding:NSUTF8StringEncoding];
    
    return address;
}

- (NSInteger)currentIPV4Port
{
    return _port4;
}

- (BOOL)start
{
    BOOL success = YES;
    
    [self releaseSocket:_ipv4Socket]; _ipv4Socket = NULL;
    
    CFSocketContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    _ipv4Socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, &SocketAcceptCallBack, &context);
    
    struct sockaddr_in sin4;
    
    memset(&sin4, 0, sizeof(sin4));
    sin4.sin_len = sizeof(sin4);
    sin4.sin_family = AF_INET;
    sin4.sin_port = htons(_port4);
    sin4.sin_addr.s_addr = INADDR_ANY;
    
    CFDataRef sincfd4 = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&sin4, sizeof(sin4));
    
    CFSocketError socketError = CFSocketSetAddress(_ipv4Socket, sincfd4);
    
    if (socketError == kCFSocketSuccess)
    {
        BOOL value = YES;
        setsockopt(CFSocketGetNative(_ipv4Socket), SOL_SOCKET, SO_REUSEADDR, (void *)&value, sizeof(value));
        
        CFRunLoopSourceRef socketSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _ipv4Socket, 0);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), socketSource, kCFRunLoopDefaultMode);
        
        CFRelease(socketSource);
        
        NSData *addr = (NSData *)CFBridgingRelease(CFSocketCopyAddress(_ipv4Socket));
        memcpy(&sin4, [addr bytes], [addr length]);
        _port4 = ntohs(sin4.sin_port);
    }
    else
    {
        [self releaseSocket:_ipv4Socket]; _ipv4Socket = NULL;
        
        success = NO;
    }
    
    CFRelease(sincfd4);
    
    return success;
}

- (void)stop
{
    [self releaseSocket:_ipv4Socket]; _ipv4Socket = NULL;
}

- (void)acceptNativeHandle:(CFSocketNativeHandle)handle
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TCPListener:didAcceptSocket:)])
    {
        [self.delegate TCPListener:self didAcceptSocket:handle];
    }
}

@end
