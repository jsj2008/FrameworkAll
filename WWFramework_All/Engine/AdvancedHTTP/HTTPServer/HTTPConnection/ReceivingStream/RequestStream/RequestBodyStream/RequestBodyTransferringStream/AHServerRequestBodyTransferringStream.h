//
//  AHServerRequestBodyTransferringStream.h
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
        AHServerRequestBodyTransferringStream
 
    @abstract
        HTTP请求主体数据的传输解析流，用于实现传输解码
 
 *********************************************************/

@interface AHServerRequestBodyTransferringStream : OverFlowableOutputStream
{
    // 流状态码
    AHServerCode _code;
}

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
 * @discussion 允许的状态码取值范围为AHServerCode_OK，AHServerCode_Request_ChunkParseError
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end


/*********************************************************
 
    @class
        AHServerRequestBodyFixedLengthTransferringStream
 
    @abstract
        定长的HTTP请求主体数据的传输解析流
 
 *********************************************************/

@interface AHServerRequestBodyFixedLengthTransferringStream : AHServerRequestBodyTransferringStream

/*!
 * @brief 初始化
 * @param length 指定的长度
 * @result 初始化后的对象
 */
- (id)initWithFixedLength:(unsigned long long)length;

@end


/*********************************************************
 
    @class
        AHServerRequestBodyChunkTransferringStream
 
    @abstract
        chunked传输的HTTP请求主体数据的传输解析流
 
 *********************************************************/

@interface AHServerRequestBodyChunkTransferringStream : AHServerRequestBodyTransferringStream

@end
