//
//  HTTPAuthentication.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPAuthentication.h"

@class HTTPRequest, HTTPResponse;


/*********************************************************
 
    @class
        HTTPAuthenticator
 
    @abstract
        HTTP认证器
 
    @discussion
        1，认证器负责管理加载过程中的所有认证事件，包括各类认证方式（框架内部已经集成了基本认证、摘要认证和cookie管理的认证方式，其中认证器已经内嵌cookie方式，基本认证和摘要认证只需在认证器属性中添加即可）
        2，认证器涉及到多种认证账户。认证器应包含一个基本账户（属性），作为加载账户，表征所有的认证操作都是为该账户进行的，并作为cookie处理的账户。各个认证方式下（cookie除外），都使用各自的认证账户（或不使用），因为存在使用其他账户为当前加载账户认证的情况
 
 *********************************************************/

@interface HTTPAuthenticator : NSObject

/*!
 * @brief 认证器可用的认证次数
 * @discussion 默认1
 */
@property (nonatomic) NSUInteger authenticatedTimes;

/*!
 * @brief HTTP请求
 */
@property (nonatomic) HTTPRequest *request;

/*!
 * @brief 账户
 * @discussion 这是加载账户，即当前的认证是为该账户进行的，不是认证使用的账户（cookie会使用本账户，但其他认证方式不会使用本账户）
 * @discussion 账户的类型在使用时无用
 */
@property (nonatomic) HTTPAccount *account;

/*!
 * @brief 认证方式，由HTTPAuthentication对象构成
 * @discussion 这里需要注意认证方式的排序，后序的认证方式的认证结果可能会覆盖前序的
 */
@property (nonatomic) NSArray<HTTPAuthentication *> *authentications;

/*!
 * @brief 是否允许使用cookie
 * @discussion 默认允许使用
 */
@property (nonatomic) BOOL cookieEnable;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 对质询响应头的认证信息
 * @discussion 在接收到服务器质询时需用过本方法做出认证
 * @param URLResponse 质询响应头
 * @result 认证首部
 */
- (NSDictionary<NSString *, NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 响应是否通过本地验证
 * @param response 响应
 * @result 是否通过本地验证
 */
- (BOOL)canResponsePassLocalAuthencation:(HTTPResponse *)response;

/*!
 * @brief 向请求添加认证首部
 * @discussion 当通过认证后，通过本方法可以为之后的请求预先配置认证首部，可以避免反复认证
 */
- (void)addAuthenticationHeaderFieldsToRequest;

/*!
 * @brief 保存cookie信息
 */
- (void)saveCookieFromURLResponse:(NSHTTPURLResponse *)URLResponse;

@end
