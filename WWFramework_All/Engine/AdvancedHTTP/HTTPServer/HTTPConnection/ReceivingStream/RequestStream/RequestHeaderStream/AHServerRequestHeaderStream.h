//
//  AHServerRequestHeaderStream.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHRequest.h"
#import "AHServerCode.h"

/*********************************************************
 
    @class
        AHServerRequestHeaderStream
 
    @abstract
        HTTP请求头解析流
 
 *********************************************************/

@interface AHServerRequestHeaderStream : OverFlowableOutputStream

/*!
 * @brief 解析到的请求头
 * @discussion 在流结束时可以获取到请求头
 * @result 请求头
 */
- (AHRequestHeader *)header;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Request_UnrecognizedHeader
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end


/*!
 * @brief HTTP请求首部的最大长度，256K字节
 */
extern NSUInteger const AHServerRequestHeaderMaxLength;
