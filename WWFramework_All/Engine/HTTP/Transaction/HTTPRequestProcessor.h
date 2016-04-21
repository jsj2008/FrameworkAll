//
//  HTTPRequestProcessor.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"

/*********************************************************
 
    @class
        HTTPRequestProcessor
 
    @abstract
        HTTP请求处理器，对HTTP事务中请求的封装
 
    @discussion
        1，处理器会自动处理流式数据的发送
        2，处理器内部会根据响应首部中的内容编码方式对发送数据进行编码
 
 *********************************************************/

@interface HTTPRequestProcessor : NSObject <NSStreamDelegate>

/*!
 * @brief 初始化
 * @param request HTTP请求
 * @result 初始化后的对象
 */
- (id)initWithRequest:(HTTPRequest *)request;

/*!
 * @brief 将HTTP请求转换成URL请求
 * @result URL请求
 */
- (NSURLRequest *)URLRequest;

@end
