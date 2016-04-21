//
//  IPRouteTraceCenter.h
//  PRIS_iPhone
//
//  Created by WW on 13-8-14.
//
//

#import <Foundation/Foundation.h>
#import "BlockTask.h"
#import "IPRouteTraceObserver.h"

/*********************************************************
 
    @class
        IPRouteTraceCenter
 
    @abstract
        路由追踪中心，负责管理路由追踪
 
    @discussion
        路由追踪是一个堵塞线程的操作，中心内部限制了并发的追踪数量，超过并发量的操作将进入队列等待操作
 
 *********************************************************/

@interface IPRouteTraceCenter : NSObject <BlockTaskDelegate>

/*!
 * @brief 单例
 */
+ (IPRouteTraceCenter *)sharedInstance;

/*!
 * @brief 启动服务
 */
- (void)start;

/*!
 * @brief 停止服务
 */
- (void)stop;

/*!
 * @brief 追踪指定主机
 * @param host 待追踪的主机地址，可以是ip地址或域名
 * @result 服务可用时，返回YES；服务不可用或host为空时，返回NO
 */
- (BOOL)traceHost:(NSString *)host withObserver:(IPRouteTraceObserver *)observer;

@end
