//
//  HTTPResponse.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutputStream.h"

#pragma mark - HTTPResponse

/*********************************************************
 
    @class
        HTTPResponse
 
    @abstract
        HTTP响应
 
 *********************************************************/

@interface HTTPResponse : NSObject <NSCoding>

/*!
 * @brief 响应头
 */
@property (nonatomic) NSHTTPURLResponse *URLResponse;

/*!
 * @brief 响应数据流
 * @discussion 响应数据以输出流形式传递，便于对数据进行各种操作
 */
@property (nonatomic) OutputStream *bodyStream;

@end


#pragma mark - NSHTTPURLResponse (Expire)

/*********************************************************
 
    @category
        NSHTTPURLResponse (Expire)
 
    @abstract
        NSHTTPURLResponse扩展，封装响应有效期的处理
 
 *********************************************************/

@interface NSHTTPURLResponse (Expire)

/*!
 * @brief 从响应首部解析有效期时间
 * @result 有效期时间
 */
- (NSDate *)expireDate;

@end


#pragma mark - NSHTTPURLResponse (Content)

/*********************************************************
 
    @category
        NSHTTPURLResponse (Content)
 
    @abstract
        NSHTTPURLResponse扩展，封装响应主体数据信息的处理
 
 *********************************************************/

@interface NSHTTPURLResponse (Content)

/*!
 * @brief 从响应首部解析原始响应数据（资源）的大小
 * @result 原始响应数据（资源）的大小
 */
- (unsigned long long)rawContentLength;

@end
