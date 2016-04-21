//
//  AHServerRequestStream.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHServerConnectionRequestOutput.h"
#import "AHServerCode.h"

/*********************************************************
 
    @class
        AHServerRequestStream
 
    @abstract
        HTTP请求解析流
 
    @discussion
        1，本流会自动解析流内数据，根据解析到的首部进行chunked解码和数据解压操作
        2，每次写入数据的时候进行数据处理，该次写入的数据解析出数据块时，该数据块将作为一份输出，流内部不会对该块数据进行拼接和分割操作
 
 *********************************************************/

@interface AHServerRequestStream : OverFlowableOutputStream

/*!
 * @brief 输出
 * @result 输出
 */
- (NSArray *)outputs;

/*!
 * @brief 清理输出
 */
- (void)cleanOutputs;

/*!
 * @brief 流状态码
 * @discussion 允许的状态码取值范围为AHServerCode_OK和AHServerCode_Request_开头的状态码
 * @result 流状态码
 */
- (AHServerCode)streamCode;

@end
