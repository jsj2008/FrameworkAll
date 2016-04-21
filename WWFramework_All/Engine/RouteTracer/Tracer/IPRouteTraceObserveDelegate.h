//
//  IPRouteTraceObserveDelegate.h
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPRouteItem.h"

/*********************************************************
 
    @protocol
        IPRouteTraceObserveDelegate
 
    @abstract
        路由追踪的观察者协议
 
 *********************************************************/

@protocol IPRouteTraceObserveDelegate <NSObject>

/*!
 * @brief 路由追踪结束
 * @param host 待追踪的主机host
 * @param routes 追踪到的路由信息，由URLRouteItem对象构成
 */
- (void)IPRouteTrace_Host:(NSString *)host didTraceWithRoutes:(NSArray<IPRouteItem *> *)routes;

@end
