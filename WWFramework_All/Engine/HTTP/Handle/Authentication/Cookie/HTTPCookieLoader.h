//
//  HTTPCookieAuthentication.h
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPRequest.h"

/*********************************************************
 
    @class
        HTTPCookieLoader
 
    @abstract
        HTTP的cookie加载器
 
    @discussion
        1，支持cookie版本0和版本1
 
 *********************************************************/

@interface HTTPCookieLoader : NSObject

/*!
 * @brief 保存cookie
 * @param request HTTP请求
 * @param account 认证账户
 * @param URLResponse 服务器响应头
 */
- (void)saveCookieForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account withURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 获取cookie
 * @param request HTTP请求
 * @param account 认证账户
 * @result cookie值
 */
- (NSString *)cookieStringForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account;

@end
