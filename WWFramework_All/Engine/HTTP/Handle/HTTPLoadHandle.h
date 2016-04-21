//
//  HTTPLoadHandle.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "HTTPAuthenticator.h"

/*********************************************************
 
    @class
        HTTPLoadHandle
 
    @abstract
        HTTP加载句柄
 
    @discussion
        HTTPLoadHandle是一个纯基类，由子类实现具体功能
 
 *********************************************************/

@interface HTTPLoadHandle : NSObject

/*!
 * @brief 初始化
 * @param URL URL
 * @result 初始化后的对象
 */
- (id)initWithURL:(NSURL *)URL;

/*!
 * @brief 请求首部
 */
@property (nonatomic) NSDictionary *headerFields;

/*!
 * @brief 账户
 * @discussion 与缓存数据相关
 */
@property (nonatomic) Account *account;

/*!
 * @brief 认证器
 */
@property (nonatomic) HTTPAuthenticator *authenticator;

/*!
 * @brief 超时时间（单次HTTP事务超时时间）
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 * @brief 启动运行
 */
- (void)run;

/*!
 * @brief 取消
 */
- (void)cancel;

@end
