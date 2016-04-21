//
//  HTTPCachePolicy.h
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        HTTPCachePolicy
 
    @abstract
        HTTP缓存策略
 
 *********************************************************/

typedef enum
{
    HTTPCachePolicy_OnlyCache    = 1,                            // 仅使用缓存
    HTTPCachePolicy_OnlyNet      = 2,                            // 仅使用网络
    HTTPCachePolicy_CacheThenNet = 3,                            // 缓存优先
    HTTPCachePolicy_Default      = HTTPCachePolicy_CacheThenNet  // 默认
}HTTPCachePolicy;
