//
//  IPRouteItem.h
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************
 
    @class
        IPRouteItem
 
    @abstract
        路由信息，包括路由ip等
 
 **************************************************/

@interface IPRouteItem : NSObject

/*!
 * @brief ip地址
 */
@property (nonatomic, copy) NSString *ip;

/*!
 * @brief 追踪时间，单位单位微秒
 */
@property (nonatomic) double costTime;

@end
