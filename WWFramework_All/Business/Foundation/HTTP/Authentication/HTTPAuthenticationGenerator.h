//
//  HTTPAuthenticationGenerator.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAuthenticator.h"
#import "HTTPBasicAuthentication.h"

/*********************************************************
 
    @class
        HTTPAuthenticationGenerator
 
    @abstract
        HTTP认证器的生成器
 
    @discussion
        1，这是一个纯基类
        2，用途：为各种业务HTTP加载模块提供一个统一的认证器生成器模式
 
 *********************************************************/

@interface HTTPAuthenticationGenerator : NSObject

/*!
 * @brief 获取认证器
 * @result 认证器
 */
- (HTTPAuthenticator *)authenticator;

@end
