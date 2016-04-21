//
//  HTTPCache.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"
#import "HTTPCachedResponse.h"
#import "HTTPAccount.h"

/*********************************************************
 
    @class
        HTTPCache
 
    @abstract
        HTTP缓存
 
 *********************************************************/

@interface HTTPCache : NSObject

/*!
 * @brief 缓存文件根目录
 */
@property (nonatomic, copy) NSString *rootDirectory;

/*!
 * @brief 单例
 */
+ (HTTPCache *)sharedInstance;

/*!
 * @brief 启动
 * @discussion 启动后，缓存数据才能正确存取
 */
- (void)start;

/*!
 * @brief 保存响应数据
 * @param response 响应数据
 * @param request 请求
 * @param account 账户
 */
- (void)saveResponse:(HTTPCachedResponse *)response forRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 读取响应数据
 * @param request 请求
 * @param account 账户
 * @result 响应数据
 */
- (HTTPCachedResponse *)responseForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 移除响应数据
 * @param request 请求
 * @param account 账户
 */
- (void)removeResponseForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 移除响应数据
 * @param account 账户
 */
- (void)removeResponsesOfAccount:(HTTPAccount *)account;

/*!
 * @brief 移除响应数据
 */
- (void)removeAllResponse;

/*!
 * @brief 响应数据的大小
 * @result 数据大小
 */
- (long long)currentResponseSize;

@end


/*********************************************************
 
    @category
        HTTPRequest (Cache)
 
    @abstract
        HTTP请求的扩展，封装缓存相关的处理
 
 *********************************************************/

@interface HTTPRequest (Cache)

/*!
 * @brief HTTP请求的缓存索引
 * @result 缓存索引
 */
- (NSString *)cacheIndex;

@end
