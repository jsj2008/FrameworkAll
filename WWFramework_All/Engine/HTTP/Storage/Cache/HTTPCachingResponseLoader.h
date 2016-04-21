//
//  HTTPCachingResponseLoader.h
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPRequest.h"
#import "HTTPCachedResponse.h"

/*********************************************************
 
    @class
        HTTPCachingResponseLoader
 
    @abstract
        HTTP响应缓存加载器，负责响应的缓存数据加载和存储
 
    @discussion
        加载器内部会根据响应的缓存首部区分私有缓存和公有缓存并作相应处理
 
 *********************************************************/

@interface HTTPCachingResponseLoader : NSObject

/*!
 * @brief HTTP账户
 */
@property (nonatomic) HTTPAccount *account;

/*!
 * @brief 响应对应的请求
 */
@property (nonatomic) HTTPRequest *request;

/*!
 * @brief 是否默认使用私有缓存
 * @discussion 当从响应首部无法解析出缓存公有和私有属性时，使用本属性作为缓存属性
 * @discussion 本属性只影响响应数据的存储
 * @discussion 默认值为YES
 */
@property (nonatomic) BOOL defaultPrivateAccount;

/*!
 * @brief 保存响应数据
 * @param response 响应数据
 */
- (void)saveResponse:(HTTPCachedResponse *)response;

/*!
 * @brief 移除响应数据
 * @discussion 只移除当前账户下的响应数据，若当前账户为私有账户，不会移除公有缓存的数据
 */
- (void)removeResponse;

/*!
 * @brief 读取响应数据
 * @discussion 读取数据时，将尝试首先从私有缓存读取，若读取失败则尝试从公有缓存读取
 * @result 响应数据
 */
- (HTTPCachedResponse *)response;

@end
