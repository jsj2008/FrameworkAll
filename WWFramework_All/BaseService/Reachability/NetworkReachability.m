//
//  NetworkReachability.m
//  FoundationProject
//
//  Created by user on 13-12-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "NetworkReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>

#import <CoreFoundation/CoreFoundation.h>

#pragma mark - NetworkReachability

@interface NetworkReachability ()
{
    // 网络可达性对象
    SCNetworkReachabilityRef _reachabilityRef;
}

/*!
 * @brief 将可达性标志转换成网络状态
 * @param flags 可达性标志
 * @result 网络状态
 */
- (NetworkReachStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags;

@end


static void NetworkReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    NetworkReachability *reach = (__bridge NetworkReachability *)info;
    
    NetworkReachStatus fromStatus = reach.status;
    
    reach.status = [reach networkStatusForFlags:flags];
    
    NetworkReachStatus toStatus = reach.status;
    
    if ((toStatus != fromStatus) && reach.notificationBlock)
    {
        reach.notificationBlock(fromStatus, toStatus);
    }
}


@implementation NetworkReachability

- (void)dealloc
{
    [self stopNotifier];
    
    if (_reachabilityRef)
    {
        CFRelease(_reachabilityRef);
    }
}

- (id)init
{
    if (self = [super init])
    {
        struct sockaddr_in zeroAddress;
        
        bzero(&zeroAddress, sizeof(zeroAddress));
        
        zeroAddress.sin_len = sizeof(zeroAddress);
        
        zeroAddress.sin_family = AF_INET;
        
        _reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
        
        self.status = NetworkReachStatus_NotReachable;
        
        SCNetworkReachabilityFlags flags;
        
        if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
        {
            self.status = [self networkStatusForFlags:flags];
        }
    }
    
    return self;
}

+ (NetworkReachability *)internetReachability
{
    static NetworkReachability *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[NetworkReachability alloc] init];
        }
    });
    
    return instance;
}

- (BOOL)startNotifier
{
    BOOL success = NO;
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
	if (SCNetworkReachabilitySetCallback(_reachabilityRef, NetworkReachabilityCallback, &context))
	{
		if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			success = YES;
		}
	}
    
    return success;
}

- (void)stopNotifier
{
    if (_reachabilityRef)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (NetworkReachStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// The target host is not reachable.
		return NetworkReachStatus_NotReachable;
	}
    
	BOOL returnValue = NetworkReachStatus_NotReachable;
    
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		/*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
		returnValue = NetworkReachStatus_ViaWiFi;
	}
    
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = NetworkReachStatus_ViaWiFi;
        }
    }
    
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		/*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
		returnValue = NetworkReachStatus_ViaWWAN;
	}
    
    return returnValue;
}

@end
