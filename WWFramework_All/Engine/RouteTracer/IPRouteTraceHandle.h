//
//  IPRouteTraceHandle.h
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPRouteTraceObserveDelegate.h"

@protocol IPRouteTraceHandleDelegate;


/*********************************************************
 
    @class
        IPRouteTraceHandle
 
    @abstract
        IP路由追踪句柄
 
    @discussion
        IPRouteTraceHandle将尽可能获取路由信息，但不保证能获取完整和准确的路由信息
 
 *********************************************************/

@interface IPRouteTraceHandle : NSObject <IPRouteTraceObserveDelegate>

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<IPRouteTraceHandleDelegate> delegate;

/*!
 * @brief 追踪指定主机的路由信息
 * @param host 待追踪的主机地址，可以是ip地址或域名
 * @result 服务可用时，返回YES；服务不可用时，返回NO
 */
- (BOOL)traceHost:(NSString *)host;

@end


/*********************************************************
 
    @protocol
        IPRouteTraceHandleDelegate
 
    @abstract
        IP路由追踪协议
 
 *********************************************************/

@protocol IPRouteTraceHandleDelegate <NSObject>

/*!
 * @brief 路由追踪结果
 * @param handle 追踪句柄
 * @param routes 追踪到的路由信息，按照途径的路由顺序存放，由IPRouteItem对象构成
 */
- (void)IPRouteTraceHandle:(IPRouteTraceHandle *)handle didTraceWithIPRoutes:(NSArray *)routes;

@end
