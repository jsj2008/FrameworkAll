//
//  HTTPHeaderFields.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-21.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPHeaderFields
 
    @abstract
        HTTP首部
 
 *********************************************************/

@interface HTTPHeaderFields : NSObject

/*!
 * @brief 初始化
 * @param dictionary 首部字典
 * @result 初始化后的对象
 */
- (id)initWithHeaderFieldsDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

/*!
 * @brief 初始化
 * @param response HTTP响应头
 * @result 初始化后的对象
 */
- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response;

/*!
 * @brief 所有首部头域组成的字典
 * @result 首部字典，键为域名，值为域值
 */
- (NSDictionary<NSString *, NSString *> *)allHeaderFields;

/*!
 * @brief 时间
 * @result 时间
 */
- (NSDate *)date;

/*!
 * @brief 设置时间
 * @param date
 */
- (void)setDate:(NSDate *)date;

/*!
 * @brief 是否采用chunked传输编码
 * @result 是否采用chunked传输编码
 */
- (BOOL)isChunkedTransferring;

/*!
 * @brief 内容类型
 * @result 内容类型
 */
- (NSString *)contentType;

/*!
 * @brief 设置内容类型
 * @param contentType 内容类型
 */
- (void)setContentType:(NSString *)contentType;

/*!
 * @brief 内容长度
 * @result 内容长度
 */
- (unsigned long long)contentLength;

/*!
 * @brief 内容配置
 * @result 内容配置
 */
- (NSString *)contentDisposition;

/*!
 * @brief 设置内容配置
 * @param contentDisposition 内容配置
 */
- (void)setContentDisposition:(NSString *)contentDisposition;

/*!
 * @brief 是否指定内容类型为多表单形式
 * @result 是否指定内容类型为多表单形式
 */
- (BOOL)isMultipartedContentType;

/*!
 * @brief 多表单内容类型的分隔符
 * @result 分隔符
 */
- (NSString *)multipartBoundary;

@end
