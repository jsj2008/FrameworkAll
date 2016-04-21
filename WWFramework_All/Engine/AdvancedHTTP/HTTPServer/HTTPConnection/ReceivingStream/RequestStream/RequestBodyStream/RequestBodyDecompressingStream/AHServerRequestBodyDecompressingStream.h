//
//  AHServerRequestBodyDecompressingStream.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "OutputStream.h"
#import "AHServerCode.h"
#import "GeneralDecompressor.h"

/*********************************************************
 
    @class
        AHServerRequestBodyDecompressingStream
 
    @abstract
        HTTP请求主体数据解压流
 
 *********************************************************/

@interface AHServerRequestBodyDecompressingStream : OutputStream
{
    // 解压器
    GeneralDecompressor *_decompressor;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 当前解析出的数据
 * @result 解析的数据输出
 */
- (NSData *)output;

/*!
 * @brief 清理解析结果
 */
- (void)cleanOutput;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK，AHServerCode_Request_DecompressError
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end


/*********************************************************
 
    @class
        AHServerRequestBodyIdentityDecompressingStream
 
    @abstract
        HTTP请求主体数据透传式解压流，解压过程保持原数据不变
 
 *********************************************************/

@interface AHServerRequestBodyIdentityDecompressingStream : AHServerRequestBodyDecompressingStream

@end

/*********************************************************
 
    @class
        AHServerRequestBodyDeflateDecompressingStream
 
    @abstract
        HTTP请求主体数据deflate解压流
 
 *********************************************************/

@interface AHServerRequestBodyDeflateDecompressingStream : AHServerRequestBodyDecompressingStream

@end

/*********************************************************
 
    @class
        AHServerRequestBodyGzipDecompressingStream
 
    @abstract
        HTTP请求主体数据gzip解压流
 
 *********************************************************/

@interface AHServerRequestBodyGzipDecompressingStream : AHServerRequestBodyDecompressingStream

@end
