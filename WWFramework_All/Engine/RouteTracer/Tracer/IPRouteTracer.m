//
//  IPRouteTracer.m
//  PRIS_iPhone
//
//  Created by WW on 13-8-15.
//
//

#import "IPRouteTracer.h"
#import <sys/socket.h>
#import <sys/time.h>
#import <netinet/in.h>
#import <netinet/ip.h>
#import <netinet/ip_icmp.h>
#import <netinet/udp.h>
#import <arpa/inet.h>
#import <netdb.h>

@interface IPRouteTracer ()
{
    // 目标主机到达标志
    BOOL _isDestinationHostReached;
    
    // 取消标志
    BOOL _cancel;
}

@end


@implementation IPRouteTracer

- (id)initWithDestinationHost:(NSString *)host
{
    if (self = [super init])
    {
        _destinationHost = [host copy];
        
        _routeItems = [[NSMutableArray alloc] initWithCapacity:IPROUTETRACE_MAXTTLCOUNT];
    }
    
    return self;
}

- (NSString *)ipOfHost:(NSString *)host
{
    NSString *ip = nil;
    
    if (host)
    {
        if (inet_addr([host UTF8String]) == INADDR_NONE)
        {
            struct hostent *hp = gethostbyname([host UTF8String]);
            
            if (hp)
            {
                ip = [NSString stringWithCString:(char *)inet_ntoa(*(struct in_addr*)(hp->h_addr)) encoding:NSUTF8StringEncoding];
            }
        }
        else
        {
            ip = host;
        }
    }
    
    return ip;
}

- (void)run
{
    NSUInteger sourcePort = 40101;
    NSUInteger destinationPort = 40102;
    
    struct sockaddr_in remoteAddress;
    memset(&remoteAddress, 0, sizeof(struct sockaddr_in));
    
    remoteAddress.sin_family = AF_INET;
    remoteAddress.sin_port = htons(destinationPort);
    remoteAddress.sin_addr.s_addr = inet_addr([_destinationHost UTF8String]);
    
    // host为域名
    if (remoteAddress.sin_addr.s_addr == INADDR_NONE)
    {
        struct hostent *hp = gethostbyname([_destinationHost UTF8String]);
        
        if (hp)
        {
            remoteAddress.sin_family = hp->h_addrtype;
            memcpy(&(remoteAddress.sin_addr), hp->h_addr, sizeof(struct in_addr));
        }
    }
    
    // 目标地址有效
    if (remoteAddress.sin_addr.s_addr != INADDR_NONE)
    {
        BOOL over = NO;
        
        struct sockaddr_in localAddress;
        memset(&localAddress, 0, sizeof(struct sockaddr_in));
        
        localAddress.sin_family = AF_INET;
        localAddress.sin_port = htons(sourcePort);
        localAddress.sin_addr.s_addr = htonl(INADDR_ANY);
        
        int sendSocket = 0;
        int receiveSocket = 0;
        
        // 启动发送套接字
        
        // socket()成功返回描述字，失败返回-1
        if ((sendSocket = socket(AF_INET, SOCK_DGRAM, 0)) >= 0)
        {
            // 重用地址
            int opt = 1;
            setsockopt(sendSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(int));
            
            // bind()成功返回0，失败返回-1
            if ((bind(sendSocket, (struct sockaddr *)&localAddress, sizeof(localAddress))) == 0)
            {
                // 启动接收套接字
                
                if ((receiveSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP)) >= 0)
                {
                    // 开始发送和接收数据
                    
                    unsigned long lastAddress = 0;
                    
                    for (int ttl = 1; ttl <= IPROUTETRACE_MAXTTLCOUNT; ttl ++)
                    {
                        if (_cancel)
                        {
                            break;
                        }
                        
                        setsockopt(sendSocket, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl));
                        
                        for (int probeCount = 0; probeCount < 3; probeCount ++)
                        {
                            char buf[40];
                            memset(buf, 0, 40);
                            
                            if (sendto(sendSocket, buf, 40, 0, (struct sockaddr *)&remoteAddress, sizeof(struct sockaddr_in)) != -1)
                            {
                                struct timeval startTime;
                                gettimeofday(&startTime, 0);
                                
                                struct timeval time = {(int)IPROUTETRACE_MAXDGRAMRECEIVINGTIME, (IPROUTETRACE_MAXDGRAMRECEIVINGTIME - (int)IPROUTETRACE_MAXDGRAMRECEIVINGTIME) * 1000000};
                                struct fd_set fdSet;
                                FD_ZERO(&fdSet);
                                FD_SET(receiveSocket, &fdSet);
                                
                                select(receiveSocket + 1, &fdSet, NULL, NULL, &time);
                                
                                if (FD_ISSET(receiveSocket, &fdSet))
                                {
                                    char buf[65535];
                                    struct sockaddr_in fromAddress;
                                    unsigned int addLen = sizeof(struct sockaddr_in);
                                    
                                    if (recvfrom(receiveSocket, buf, 65535, 0, (struct sockaddr *)&fromAddress, &addLen))
                                    {
                                        struct timeval endTime;
                                        gettimeofday(&endTime, 0);
                                        
                                        BOOL icmpOK = NO;
                                        
                                        struct ip *ip = (struct ip *)buf;
                                        int hlen = ip->ip_hl << 2;		//ip数据报文头部长度
                                        if(ip->ip_p == IPPROTO_ICMP)
                                        {
                                            //icmp
                                            struct icmp *icmp = (struct icmp *)(buf + hlen);
                                            
                                            //icmp超时
                                            if(icmp->icmp_type == 11 && icmp->icmp_code == 0)
                                            {
                                                struct ip *iip = (struct ip *)&icmp->icmp_ip;
                                                int ihlen = iip->ip_hl << 2;
                                                struct udphdr *udp = (struct udphdr *)((u_char *)iip + ihlen);
                                                if(iip->ip_p == IPPROTO_UDP && udp->uh_sport == htons(sourcePort) && udp->uh_dport == htons(destinationPort))
                                                    icmpOK = YES;
                                            }
                                            
                                            //icmp端口不可达
                                            if(icmp->icmp_type == 3 && icmp->icmp_code == 3)
                                            {
                                                struct ip *iip = (struct ip *)&icmp->icmp_ip;
                                                int ihlen = iip->ip_hl << 2;
                                                struct udphdr *udp = (struct udphdr *)((u_char *)iip + ihlen);
                                                if(iip->ip_p == IPPROTO_UDP && udp->uh_sport == htons(sourcePort) && udp->uh_dport == htons(destinationPort))
                                                    icmpOK = YES;
                                            }
                                        }
                                        
                                        if (icmpOK)
                                        {
                                            IPRouteItem *item = [[IPRouteItem alloc] init];
                                            item.ip = [NSString stringWithCString:(char *)inet_ntoa(fromAddress.sin_addr) encoding:NSUTF8StringEncoding];
                                            item.costTime = 1000000 * (endTime.tv_sec - startTime.tv_sec) + (endTime.tv_usec - startTime.tv_usec);
                                            [_routeItems addObject:item];
                                            
                                            if (fromAddress.sin_addr.s_addr == remoteAddress.sin_addr.s_addr)
                                            {
                                                over = YES;
                                            }
                                            else if (fromAddress.sin_addr.s_addr != lastAddress)
                                            {
                                                lastAddress = fromAddress.sin_addr.s_addr;
                                            }
                                            
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (over)
                        {
                            break;
                        }
                    }
                }
            }
        }
        
        _isDestinationHostReached = over;
        
        close(sendSocket);
        close(receiveSocket);
    }
}

- (void)cancel
{
    _cancel = YES;
}

- (NSArray *)routeItems
{
    return _routeItems;
}

- (BOOL)isDestinationHostReached
{
    return _isDestinationHostReached;
}

@end


/*!
 * @brief 路由追踪的最大ttl数
 */
NSUInteger const IPROUTETRACE_MAXTTLCOUNT = 10;


/*!
 * @brief 路由追踪过程中接收数据包的最大等待时间，单位秒
 */
double const IPROUTETRACE_MAXDGRAMRECEIVINGTIME = 1.0;
