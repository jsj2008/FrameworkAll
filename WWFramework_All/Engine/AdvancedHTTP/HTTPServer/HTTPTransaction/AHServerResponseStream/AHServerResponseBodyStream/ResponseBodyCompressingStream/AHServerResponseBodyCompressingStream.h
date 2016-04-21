//
//  AHServerResponseBodyCompressingStream.h
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHServerCode.h"
#import "GeneralCompressor.h"

/*********************************************************
 
    @class
        AHServerResponseBodyCompressingStream
 
    @abstract
        HTTP响应主体压缩流
 
 *********************************************************/

@interface AHServerResponseBodyCompressingStream : NSObject
{
    // 压缩器
    GeneralCompressor *_compressor;
    
    // 流状态码
    AHServerCode _code;
    
    // 即将结束标志
    BOOL _toBeFinished;
    
    // 压缩结束标志
    BOOL _over;
}

/*!
 * @brief 添加原始数据
 * @param data 原始数据
 */
- (void)addInputData:(NSData *)data;

/*!
 * @brief 读取指定长度的处理后的数据
 * @param length 指定长度
 * @result 读取的数据，不会大于指定长度
 */
- (NSData *)readDataOfLength:(NSUInteger)length;

/*!
 * @brief 结束流，对流内原始数据进行终结处理
 */
- (void)finishStream;

/*!
 * @brief 压缩是否结束
 * @result 压缩是否结束
 */
- (BOOL)isOver;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Response_CompressError
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end


/*********************************************************
 
    @class
        AHServerResponseBodyIdentityCompressingStream
 
    @abstract
        HTTP响应主体透传式压缩流，不对原始数据进行压缩处理
 
 *********************************************************/

@interface AHServerResponseBodyIdentityCompressingStream : AHServerResponseBodyCompressingStream

@end


/*********************************************************
 
    @class
        AHServerResponseBodyDeflateCompressingStream
 
    @abstract
        HTTP响应主体deflate压缩流
 
 *********************************************************/

@interface AHServerResponseBodyDeflateCompressingStream : AHServerResponseBodyCompressingStream

@end


/*********************************************************
 
    @class
        AHServerResponseBodyGzipCompressingStream
 
    @abstract
        HTTP响应主体gzip压缩流
 
 *********************************************************/

@interface AHServerResponseBodyGzipCompressingStream : AHServerResponseBodyCompressingStream

@end
