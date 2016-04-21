//
//  LightLoadingPermanentQueue.m
//  FoundationProject
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "LightLoadingPermanentQueue.h"

@interface LightLoadingPermanentQueue ()
{
    // 取消标志
    BOOL _stop;
}

/*!
 * @brief 内部运行线程
 */
@property (nonatomic) NSThread *internalRunningThread;

/*!
 * @brief 取消
 */
- (void)internalCancel;

/*!
 * @brief 通知
 * @param notification 消息块
 */
- (void)notify:(void (^)())notification;

@end


@implementation LightLoadingPermanentQueue

- (id)init
{
    if (self = [super init])
    {
        _stop = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [self internalCancel];
}

+ (LightLoadingPermanentQueue *)sharedInstance
{
    static LightLoadingPermanentQueue *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[LightLoadingPermanentQueue alloc] init];
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
    
    if (_stop)
    {
        _stop = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] target:self selector:@selector(stop) userInfo:nil repeats:NO];
            
            self.internalRunningThread = [NSThread currentThread];
            
            [self notify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(lightLoadingPermanentQueueDidStart:)])
                {
                    [self.delegate lightLoadingPermanentQueueDidStart:self];
                }
            }];
            
            while (!_stop)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            [self notify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(lightLoadingPermanentQueueDidStop:)])
                {
                    [self.delegate lightLoadingPermanentQueueDidStop:self];
                }
            }];
        });
    }
}

- (void)stop
{
    self.notifyThread = nil;
    
    _stop = YES;
    
    if ([self.internalRunningThread isExecuting])
    {
        [self performSelector:@selector(internalCancel) onThread:self.internalRunningThread withObject:nil waitUntilDone:NO];
    }
}

- (void)internalCancel
{
    self.internalRunningThread = nil;
}

- (void)notify:(void (^)())notification
{
    if ([self.notifyThread isExecuting])
    {
        VoidBlockLoader *loader = [[VoidBlockLoader alloc] initWithBlock:notification];
        
        [loader performSelector:@selector(exeBlock) onThread:self.notifyThread withObject:nil waitUntilDone:NO];
    }
}

- (NSThread *)runningThread
{
    return _stop ? nil : self.internalRunningThread;
}

- (BOOL)addBlockLoader:(VoidBlockLoader *)blockLoader
{
    BOOL success = NO;
    
    if (!_stop && [self.internalRunningThread isExecuting])
    {
        [blockLoader performSelector:@selector(exeBlock) onThread:self.internalRunningThread withObject:nil waitUntilDone:NO];
        
        success = YES;
    }
    
    return success;
}

@end
