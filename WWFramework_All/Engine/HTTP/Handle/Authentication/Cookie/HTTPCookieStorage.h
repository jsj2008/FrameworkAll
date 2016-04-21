//
//  HTTPCookieStorage.h
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPCookie.h"
#import "HTTPAccount.h"

/*********************************************************
 
    @class
        HTTPCookieStorage
 
    @abstract
        HTTP的cookie存储器
 
    @discussion
        1，内存形式存储，应用退出后，cookie将自动清除
        2，内部按照domain(account@domain)-path-port三级索引方式存储cookie
        3，为避免cookie内存暴涨和提供无效数据，在沿着索引路径获取cookie数据时，删除该路径下的无效cookie数据（过期数据）
 
 *********************************************************/


@interface HTTPCookieStorage : NSObject

/*!
 * @brief 单例
 */
+ (HTTPCookieStorage *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 存储cookie
 * @param cookies cookie数组，由HTTPCookie对象构成
 * @param URL URL
 * @param account 认证账户
 * @param date 响应时间，不能为空
 */
- (void)saveCookies:(NSArray<HTTPCookie *> *)cookies forURL:(NSURL *)URL ofAccount:(HTTPAccount *)account atDate:(NSDate *)date;

/*!
 * @brief 获取cookie
 * @discussion 获取cookie时，检查索引路径下的cookie有效期，删除过期的cookie
 * @param URL URL
 * @param account 认证账户
 * @result cookie数组，由HTTPCookie对象构成
 */
- (NSArray<HTTPCookie *> *)cookiesForURL:(NSURL *)URL ofAccount:(HTTPAccount *)account;

@end
