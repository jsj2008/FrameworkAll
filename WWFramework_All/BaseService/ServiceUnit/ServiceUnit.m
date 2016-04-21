//
//  ServiceUnit.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "ServiceUnit.h"

#import <libxml2/libxml/tree.h>

#import "APPConfiguration.h"

#import "MainFileDirectoryCenter.h"

#import "VoidBlockLoader.h"

#import "APPLog.h"

#import "APPDebug.h"

#import "NetworkReachability.h"
#import "NetworkChanging.h"

#import "HTTPNetServiceCenter.h"
#import "HTTPCache.h"
#import "HTTPTempResource.h"

#import "FileRemover.h"

#import "SPTaskConfiguration.h"
#import "SPTaskServiceProvider.h"

#import "DBLog.h"

#import "LightLoadingPermanentQueue.h"

@interface ServiceUnit ()

/*!
 * @brief 通知
 * @param notification 消息块
 */
- (void)notify:(void (^)(void))notification;

@end


@implementation ServiceUnit

+ (ServiceUnit *)sharedInstance
{
    static ServiceUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ServiceUnit alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    if (!self.notifyThread)
    {
        self.notifyThread = [NSThread currentThread];
    }
    
    // 初始化Libxml
    xmlInitParser();
    
    // 日志系统
    [APPLog sharedInstance].defaultLevel = APPLogLevel_High;
    [APPLog sharedInstance].logFileDirectory = [[MainFileDirectoryCenter sharedInstance] logDirectory];
    [[APPLog sharedInstance] start];
    
    // 轻载常驻队列
    [LightLoadingPermanentQueue sharedInstance].delegate = self;
    [LightLoadingPermanentQueue sharedInstance].notifyThread = self.notifyThread;
    [[LightLoadingPermanentQueue sharedInstance] start];
}

- (void)lightLoadingPermanentQueueDidStart:(LightLoadingPermanentQueue *)queue
{
    VoidBlockLoader *loader = [[VoidBlockLoader alloc] initWithBlock:^{
        
        [DBLog sharedInstance].customLogOperation = ^(NSString *logString){
            
            [[APPLog sharedInstance] logString:logString onLevel:APPLogLevel_High];
        };
        
        // 网络状态
        [NetworkReachability internetReachability].notificationBlock = ^(NetworkReachStatus fromStatus, NetworkReachStatus toStatus)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NetworkReachabilityChangedContext *context = [[NetworkReachabilityChangedContext alloc] init];
                
                context.fromStatus = fromStatus;
                
                context.toStatus = toStatus;
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:context, NetworkReachabilityChangedNotificationKey_Context, nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworkReachabilityChangedNotification object:nil userInfo:userInfo];
            });
        };
        
        BOOL success = [[NetworkReachability internetReachability] startNotifier];
        
        [APPDebug assertWithCondition:success string:@"reach ability start failed"];
        
        // 文件清理器清理当前剩余的垃圾文件
        [[FileRemover sharedInstance] clean];
        
        // Task配置
        [SPTaskConfiguration sharedInstance].daemonPoolCapacity = APP_DaemonTaskPoolCapacity;
        
        [SPTaskConfiguration sharedInstance].freePoolCapacity = APP_FreeTaskPoolCapacity;
        
        [SPTaskConfiguration sharedInstance].backgroundPoolCapacity = APP_BackgroundTaskPoolCapacity;
        
        [SPTaskConfiguration sharedInstance].defaultQueueLoadingLimit = APP_TaskQueueLoadingCapacity;
        
        [[SPTaskServiceProvider sharedInstance] start];
        
        // 配置HTTP引擎
        [HTTPNetServiceCenter sharedInstance].serviceCheckOperation = ^()
        {
            NetworkReachStatus netStatus = [NetworkReachability internetReachability].status;
            
            return (BOOL)((netStatus == NetworkReachStatus_ViaWiFi) || (netStatus == NetworkReachStatus_ViaWWAN));
        };
        
        [[HTTPNetServiceCenter sharedInstance] start];
        
        [HTTPCache sharedInstance].rootDirectory = [[MainFileDirectoryCenter sharedInstance].HTTPRootDirectory stringByAppendingPathComponent:@"Cache"];
        
        [[HTTPCache sharedInstance] start];
        
        [HTTPTempResource sharedInstance].rootDirectory = [[MainFileDirectoryCenter sharedInstance].HTTPRootDirectory stringByAppendingPathComponent:@"TempResource"];
        
        [[HTTPTempResource sharedInstance] start];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:isStartingWithProgress:)])
            {
                [self.delegate serviceUnit:self isStartingWithProgress:1.0];
            }
        }];
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:didStartSuccessfully:)])
            {
                [self.delegate serviceUnit:self didStartSuccessfully:YES];
            }
        }];
    }];
    
    [[LightLoadingPermanentQueue sharedInstance] addBlockLoader:loader];
}

- (void)stop
{
    VoidBlockLoader *loader = [[VoidBlockLoader alloc] initWithBlock:^{
        
        [[SPTaskServiceProvider sharedInstance] stop];
        
        [[HTTPNetServiceCenter sharedInstance] stop];
        
        [[NetworkReachability internetReachability] stopNotifier];
    }];
    
    [[LightLoadingPermanentQueue sharedInstance] addBlockLoader:loader];
    
    [[LightLoadingPermanentQueue sharedInstance] stop];
}

- (void)lightLoadingPermanentQueueDidStop:(LightLoadingPermanentQueue *)queue
{
    [[APPLog sharedInstance] stop];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:isStopingWithProgress:)])
        {
            [self.delegate serviceUnit:self isStopingWithProgress:1.0];
        }
    }];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(serviceUnit:didStopSuccessfully:)])
        {
            [self.delegate serviceUnit:self didStopSuccessfully:YES];
        }
    }];
    
    self.notifyThread = nil;
}

- (void)notify:(void (^)(void))notification
{
    NSThread *thread = self.notifyThread;
    
    if (!thread || [thread isEqual:[NSThread currentThread]])
    {
        notification();
    }
    else if ([thread isExecuting])
    {
        VoidBlockLoader *loader = [[VoidBlockLoader alloc] initWithBlock:notification];
        
        [loader performSelector:@selector(exeBlock) onThread:thread withObject:nil waitUntilDone:NO];
    }
}

@end
