//
//  IPRouteTraceCenter.m
//  PRIS_iPhone
//
//  Created by WW on 13-8-14.
//
//

#import "IPRouteTraceCenter.h"
#import "APPConfiguration.h"
#import "IPRouteTracer.h"
#import "LightLoadingPermanentQueue.h"

/*!
 * @brief 路由追踪任务的并发量
 */
static const NSUInteger IPRouteTracingConcurrentTaskCount = 5;

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Tracer = @"tracer";

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Observer = @"observer";

/*!
 * @brief 追踪上下文的键
 */
static NSString * const IPRouteTracingContextKey_Host = @"host";


@interface IPRouteTraceCenter ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
    
    // 队列式任务派发器
    SPTaskDispatcher *_dispatcher;
    
    // 停止标志
    BOOL _stop;
}

@end


@implementation IPRouteTraceCenter

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create(NULL, NULL);
        
        _dispatcher = [[SPTaskDispatcher alloc] init];
        
        _dispatcher.asyncTaskCapacity = MIN(IPRouteTracingConcurrentTaskCount, APP_FreeTaskPoolCapacity / 3) ;
    }
    
    return self;
}

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

+ (IPRouteTraceCenter *)sharedInstance
{
    static IPRouteTraceCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[IPRouteTraceCenter alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    _stop = NO;
}

- (void)stop
{
    _stop = YES;
    
    dispatch_sync(_syncQueue, ^{
        
        for (BlockTask *task in [_dispatcher allAsyncTasks])
        {
            IPRouteTracer *tracer = [task.context objectForKey:IPRouteTracingContextKey_Tracer];
            
            [tracer cancel];
        }
        
        [_dispatcher cancel];
    });
}

- (BOOL)traceHost:(NSString *)host withObserver:(IPRouteTraceObserver *)observer
{
    if (_stop || !host)
    {
        return NO;
    }
    
    dispatch_sync(_syncQueue, ^{
        
        IPRouteTracer *tracer = [[IPRouteTracer alloc] initWithDestinationHost:host];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionaryWithObjectsAndKeys:tracer, IPRouteTracingContextKey_Tracer, nil];
        
        if (observer)
        {
            [context setObject:observer forKey:IPRouteTracingContextKey_Observer];
            
            [context setObject:host forKey:IPRouteTracingContextKey_Host];
        }
        
        BlockTask *task = [[BlockTask alloc] init];
        
        task.block = ^()
        {
            IPRouteTracer *tracer = [context objectForKey:IPRouteTracingContextKey_Tracer];
            
            if (tracer)
            {
                [tracer run];
            }
        };
        
        [task.context addEntriesFromDictionary:context];
        
        task.delegate = self;
        
        task.notifyThread = [[LightLoadingPermanentQueue sharedInstance] runningThread];
        
        [_dispatcher asyncAddTask:task inMode:SPTaskAsyncRunMode_ExclusiveThread];
    });
    
    return YES;
}

- (void)blockTaskDidFinish:(BlockTask *)task
{
    dispatch_sync(_syncQueue, ^{
        
        IPRouteTraceObserver *taskObserver = [task.context objectForKey:IPRouteTracingContextKey_Observer];
        
        NSArray *routeItems = ((IPRouteTracer *)[task.context objectForKey:IPRouteTracingContextKey_Tracer]).routeItems;
        
        if (taskObserver)
        {
            [taskObserver notify:^(id observer) {
                
                if (taskObserver.observer && [taskObserver.observer respondsToSelector:@selector(IPRouteTrace_Host:didTraceWithRoutes:)])
                {
                    [taskObserver.observer IPRouteTrace_Host:[task.context objectForKey:IPRouteTracingContextKey_Host] didTraceWithRoutes:routeItems];
                }
            } onThread:nil];
        }
        
        [_dispatcher removeTask:task];
    });
}

@end
