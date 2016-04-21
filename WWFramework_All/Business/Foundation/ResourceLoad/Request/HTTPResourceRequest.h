//
//  HTTPResourceRequest.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "ResourceRequest.h"
#import "HTTPCachePolicy.h"
#import "HTTPAuthenticationGenerator.h"

/*********************************************************
 
    @class
        HTTPResourceRequest
 
    @abstract
        HTTP资源请求
 
 *********************************************************/

@interface HTTPResourceRequest : ResourceRequest

/*!
 * @brief 超时时间
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 * @brief 缓存策略
 */
@property (nonatomic) HTTPCachePolicy cachePolicy;

/*!
 * @brief 认证器生成器
 */
@property (nonatomic) HTTPAuthenticationGenerator *authenticationGenerator;

@end
