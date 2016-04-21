//
//  HTTPTempResource.h
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTempResourceResponse.h"
#import "HTTPAccount.h"
#import "HTTPDownloadRequest.h"

/*********************************************************
 
    @class
        HTTPTempResource
 
    @abstract
        HTTP临时资源，管理下载过程中的响应头信息
 
 *********************************************************/

@interface HTTPTempResource : NSObject

/*!
 * @brief 临时资源文件根目录
 */
@property (nonatomic, copy) NSString *rootDirectory;

/*!
 * @brief 单例
 */
+ (HTTPTempResource *)sharedInstance;

/*!
 * @brief 启动
 * @discussion 启动后，缓存数据才能正确存取
 */
- (void)start;

/*!
 * @brief 保存临时资源数据
 * @param response 响应数据
 * @param request 请求
 * @param account 账户
 */
- (void)saveResponse:(HTTPTempResourceResponse *)response forDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 读取临时资源数据
 * @param request 请求
 * @param account 账户
 * @result 临时资源数据
 */
- (HTTPTempResourceResponse *)responseForDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 移除临时资源数据
 * @param request 请求
 * @param account 账户
 */
- (void)removeResponseForDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account;

/*!
 * @brief 移除临时资源数据
 * @param account 账户
 */
- (void)removeResponsesOfAccount:(HTTPAccount *)account;

/*!
 * @brief 移除临时资源数据
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
        HTTPDownloadRequest (Cache)
 
    @abstract
        HTTP下载请求的扩展，封装缓存相关的处理
 
 *********************************************************/

@interface HTTPDownloadRequest (Cache)

/*!
 * @brief HTTP下载请求的缓存索引
 * @result 缓存索引
 */
- (NSString *)cacheIndex;

@end
