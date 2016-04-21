//
//  ResourceRequest.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

/*********************************************************
 
    @class
        ResourceRequest
 
    @abstract
        资源请求
 
    @discussion
        1，这是一个纯基类
 
 *********************************************************/

@interface ResourceRequest : NSObject

/*!
 * @brief 资源URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 资源所属账户
 */
@property (nonatomic) Account *account;

/*!
 * @brief 是否允许共享加载
 * @discussion 如果选是，将允许当前请求与正在执行的请求共享同一个加载器
 */
@property (nonatomic) BOOL canShareLoading;

/*!
 * @brief 用户字典
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 请求标识符
 * @result 标识符
 */
- (NSString *)identifier;

@end
