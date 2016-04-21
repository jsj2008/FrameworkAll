//
//  ResourceLoadHandle.m
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "ResourceLoadHandle.h"
#import "SPTaskDispatcher.h"
#import "Notifier.h"

@interface ResourceLoadHandleContext ()

/*!
 * @brief 执行同一加载操作的请求
 */
@property (nonatomic) NSMutableArray *requests;

/*!
 * @brief 执行加载操作的任务
 */
@property (nonatomic) FoundationTask *task;

@end


@implementation ResourceLoadHandleContext

@end


@interface ResourceLoadHandle ()
{
    // 当前正在执行的请求
    NSMutableDictionary *_requests;
    
    // 任务调度器
    SPTaskDispatcher *_taskDispatcher;
}

@end


@implementation ResourceLoadHandle

- (void)dealloc
{
    [_taskDispatcher cancel];
}

- (id)init
{
    if (self = [super init])
    {
        _requests = [[NSMutableDictionary alloc] init];
        
        _taskDispatcher = [[SPTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)loadResourceRequests:(NSArray<ResourceRequest *> *)requests
{
    for (ResourceRequest *request in requests)
    {
        NSString *identifier = [request identifier];
        
        ResourceLoadHandleContext *context = [_requests objectForKey:identifier];
        
        if (context)
        {
            if (![context.requests containsObject:request])
            {
                [context.requests addObject:request];
            }
        }
        else
        {
            ResourceLoadTask *task = [[ResourceLoadTask alloc] initWithRequest:request];
            
            context = [[ResourceLoadHandleContext alloc] init];
            
            context.requests = [NSMutableArray arrayWithObject:request];
            
            context.task = task;
            
            [_requests setObject:context forKey:identifier];
            
            [_taskDispatcher asyncAddTask:task];
        }
    }
}

- (void)cancel
{
    [_taskDispatcher cancel];
    
    [_requests removeAllObjects];
}

- (void)cancelLoadingRequest:(ResourceRequest *)request
{
    NSString *identifier = [request identifier];
    
    ResourceLoadHandleContext *context = [_requests objectForKey:identifier];
    
    if ([context.requests containsObject:request])
    {
        [context.requests removeObject:request];
        
        if (![context.requests count])
        {
            [_taskDispatcher cancelTask:context.task];
            
            [_requests removeObjectForKey:identifier];
        }
    }
}

- (void)resourceLoadTask:(ResourceLoadTask *)task didFinishLoadingWithCode:(ResourceLoadCode)code content:(NSData *)content
{
    NSString *identifier = [task.request identifier];
    
    ResourceLoadHandleContext *context = [_requests objectForKey:identifier];
    
    for (ResourceRequest *request in context.requests)
    {
        [Notifier notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(resourceLoadHandle:didLoadResourceOfRequest:withCode:content:)])
            {
                [self.delegate resourceLoadHandle:self didLoadResourceOfRequest:request withCode:code content:content];
            }
        }];
    }
    
    [_taskDispatcher removeTask:task];
    
    [_requests removeObjectForKey:identifier];
}

@end
