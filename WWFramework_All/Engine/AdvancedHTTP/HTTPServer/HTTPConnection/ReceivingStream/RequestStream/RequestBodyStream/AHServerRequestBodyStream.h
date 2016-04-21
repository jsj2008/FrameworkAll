//
//  AHServerRequestBodyStream.h
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
        AHServerRequestBodyStream
 
    @abstract
        HTTP请求主体数据解析流
 
    @discussion
        本流会根据请求头信息自动进行chunked解码和数据解压操作
 
 *********************************************************/

@interface AHServerRequestBodyStream : OverFlowableOutputStream

/*!
 * @brief 启动，根据请求头进行内部配置
 * @param header 请求头
 */
- (void)startWithHeader:(AHRequestHeader *)header;

/*!
 * @brief 请求头
 * @result 请求头
 */
- (AHRequestHeader *)header;

/*!
 * @brief 当前解析出的所有数据
 * @result 解析的数据输出
 */
- (NSData *)output;

/*!
 * @brief 清理解析结果
 */
- (void)cleanOutput;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为
    AHServerCode_OK，
    AHServerCode_Request_UnsupportedTransferringEncoding，
    AHServerCode_Request_UnsupportedContentEncoding，
    AHServerCode_Request_UnknownContentLength，
    AHServerCode_Request_DecompressError，
    AHServerCode_Request_ChunkParseError
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end
