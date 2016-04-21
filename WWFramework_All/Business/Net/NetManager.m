//
//  NetManager.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/8/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "NetManager.h"
#import "NetworkChanging.h"
#import "NotificationObservingSet.h"
#import "HTTPNetServiceCenter.h"

@interface NetManager ()

/*!
 * @brief 观察者集合
 */
@property (nonatomic) NotificationObservingSet *observerSet;

/*!
 * @brief 同步队列
 */
@property (nonatomic) dispatch_queue_t syncQueue;

/*!
 * @brief 收到网络状态变化的消息处理
 * @param notification 消息体
 */
- (void)didChangeNetworkStatusWithNotification:(NSNotification *)notification;

@end


@implementation NetManager

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

+ (NetManager *)sharedInstance
{
    static NetManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[NetManager alloc] init];
            
            instance.observerSet = [[NotificationObservingSet alloc] init];
            
            instance.syncQueue = dispatch_queue_create(nil, nil);
        }
    });
    
    return instance;
}

- (void)start
{
    dispatch_sync(self.syncQueue, ^{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeNetworkStatusWithNotification:) name:NetworkReachabilityChangedNotification object:nil];
    });
}

- (void)stop
{
    dispatch_sync(self.syncQueue, ^{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    });
}

- (NetworkReachStatus)currentNetworkReachStatus
{
    return [NetworkReachability internetReachability].status;
}

- (void)addNetworkChangingObserver:(id<NetManagerObserving>)observer
{
    dispatch_sync(self.syncQueue, ^{
        
        NotificationObserver *notificationObserver = [[NotificationObserver alloc] init];
        
        notificationObserver.observer = observer;
        
        notificationObserver.notifyThread = [NSThread currentThread];
        
        [self.observerSet.observers addObject:notificationObserver];
    });
}

- (void)removeNetworkChangingObserver:(id<NetManagerObserving>)observer
{
    dispatch_sync(self.syncQueue, ^{
        
        NSMutableArray *observers = [[NSMutableArray alloc] init];
        
        for (NotificationObserver *notificationObserver in self.observerSet.observers)
        {
            if (notificationObserver.observer == observer)
            {
                [observers addObject:notificationObserver];
            }
        }
        
        [self.observerSet.observers removeObjectsInArray:observers];
    });
}

- (void)didChangeNetworkStatusWithNotification:(NSNotification *)notification
{
    NetworkReachabilityChangedContext *context = [notification.userInfo objectForKey:NetworkReachabilityChangedNotificationKey_Context];
    
    [[HTTPNetServiceCenter sharedInstance] updateNetService];
    
    dispatch_sync(self.syncQueue, ^{
        
        [self.observerSet notify:^(id observer) {
            
            if (observer && [observer respondsToSelector:@selector(networkStautsDidChangeFromStatus:toStatus:)])
            {
                [observer networkStautsDidChangeFromStatus:context.fromStatus toStatus:context.toStatus];
            }
        } onThread:nil];
    });
}

@end
