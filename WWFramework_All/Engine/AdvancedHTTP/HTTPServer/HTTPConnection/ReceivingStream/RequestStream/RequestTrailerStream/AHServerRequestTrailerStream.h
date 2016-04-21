//
//  AHServerRequestTrailerStream.h
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
        AHServerRequestTrailerStream
 
    @abstract
        HTTP请求拖挂解析流
 
 *********************************************************/

@interface AHServerRequestTrailerStream : OverFlowableOutputStream

/*!
 * @brief 启动，根据请求头进行内部配置
 * @param header 请求头
 */
- (void)startWithHeader:(AHRequestHeader *)header;

/*!
 * @brief 当前解析出的拖挂
 * @result 拖挂数据
 */
- (NSDictionary *)output;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Request_UnrecognizedTrailer开头的状态码
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end


/*!
 * @brief HTTP请求拖挂的最大长度，256K字节
 */
extern NSUInteger const AHServerRequestTrailerHeaderMaxLength;
