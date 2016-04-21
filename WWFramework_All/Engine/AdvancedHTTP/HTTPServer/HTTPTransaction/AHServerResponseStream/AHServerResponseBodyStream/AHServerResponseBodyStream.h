//
//  AHServerResponseBodyStream.h
//  Application
//
//  Created by WW on 14-3-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "InputStream.h"
#import "AHBody.h"
#import "AHServerCode.h"

/*********************************************************
 
    @class
        AHServerResponseBodyStream
 
    @abstract
        HTTP响应的主体流
 
 *********************************************************/

@interface AHServerResponseBodyStream : InputStream

/*!
 * @brief 初始化
 * @param body 响应主体
 * @result 初始化后的对象
 */
- (id)initWithBody:(AHBody *)body;

/*!
 * @brief 启动，根据响应头进行内部配置
 * @param header 响应头
 */
- (void)startWithHeaderFields:(NSDictionary *)headerFields;

/*!
 * @brief 响应的主体数据的已读长度
 * @result 已读长度
 */
- (unsigned long long)readRawDataSize;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Response_CompressError
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end
