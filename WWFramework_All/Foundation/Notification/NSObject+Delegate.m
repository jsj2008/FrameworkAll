//
//  NSObject+Delegate.m
//  MarryYou
//
//  Created by ww on 15/7/22.
//  Copyright (c) 2015年 MiaoTo. All rights reserved.
//

#import "NSObject+Delegate.h"
#import <objc/runtime.h>
#import "NotificationObserver.h"

#pragma mark - NSObject (Delegate_Internal)

/**********************************************************
 
    @category
        NSObject (Delegate_Internal)
 
    @abstract
        NSObject的Delegate内部扩展
 
 **********************************************************/

@interface NSObject (Delegate_Internal)

/*!
 * @brief delegate观察者
 * @result 观察者对象
 */
- (NSMutableDictionary *)delegateObservers;

/*!
 * @brief delegate同步队列
 * @result 同步队列
 */
- (dispatch_queue_t)delegateSyncQueue;

@end


#pragma mark - NSObject (Delegate)


@implementation NSObject (Delegate)

- (void)addDelegate:(id)delegate
{
    if (delegate)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        NSString *index = [NSString stringWithFormat:@"%x", delegate];
        
        NSThread *currentThread = [NSThread currentThread];
        
        dispatch_sync(syncQueue, ^{
            
            NSMutableDictionary *observers = [self delegateObservers];
            
            if (![[observers allKeys] containsObject:index])
            {
                NotificationObserver *observer = [[NotificationObserver alloc] init];
                
                observer.observer = delegate;
                
                observer.notifyThread = currentThread;
                
                [observers setObject:observer forKey:index];
            }
        });
    }
}

- (void)removeDelegate:(id)delegate
{
    if (delegate)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        NSString *index = [NSString stringWithFormat:@"%x", delegate];
        
        dispatch_sync(syncQueue, ^{
            
            NSMutableDictionary *observers = [self delegateObservers];
            
            [observers removeObjectForKey:index];
        });
    }
}

- (void)operateDelegate:(void (^)(id))operation
{
    if (operation)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        dispatch_sync(syncQueue, ^{
            
            for (NotificationObserver *observer in [[self delegateObservers] allValues])
            {
                [observer notify:^(id observer) {
                    
                    operation(observer);
                    
                } onThread:nil];
            }
        });
    }
}

@end


#pragma mark - NSObject (Delegate_Internal)


static char kNSObjectDelegateKey[] = "kNSObjectDelegateKey";

static char kNSObjectDelegateSyncQueue[] = "kNSObjectDelegateSyncQueue";


@implementation NSObject (Delegate_Internal)

- (NSMutableDictionary *)delegateObservers
{
    NSMutableDictionary *observers = objc_getAssociatedObject(self, kNSObjectDelegateKey);
    
    if (!observers)
    {
        observers = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self, kNSObjectDelegateKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return observers;
}

- (dispatch_queue_t)delegateSyncQueue
{
    dispatch_queue_t queue = objc_getAssociatedObject(self, kNSObjectDelegateSyncQueue);
    
    if (!queue)
    {
        queue = dispatch_queue_create(NULL, NULL);
        
        objc_setAssociatedObject(self, kNSObjectDelegateSyncQueue, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return queue;
}

@end
