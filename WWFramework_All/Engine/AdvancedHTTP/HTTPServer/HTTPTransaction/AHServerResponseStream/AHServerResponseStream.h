//
//  AHServerResponseStream.h
//  Application
//
//  Created by WW on 14-3-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "InputStream.h"
#import "AHResponse.h"
#import "AHServerCode.h"

/*********************************************************
 
    @class
        AHServerResponseStream
 
    @abstract
        HTTP响应输出流，封装了数据读取和编码操作
 
 *********************************************************/

@interface AHServerResponseStream : InputStream

/*!
 * @brief 初始化
 * @param response 响应数据
 * @result 初始化后的对象
 */
- (id)initWithResponse:(AHResponse *)response;

/*!
 * @brief 响应的主体数据的已读长度
 * @result 已读长度
 */
- (unsigned long long)bodyTotalReadSize;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Response_开头的状态码
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end
