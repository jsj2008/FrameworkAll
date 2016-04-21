//
//  AHServerResponseBodyTransferringStream.h
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        AHServerResponseBodyTransferringStream
 
    @abstract
        HTTP响应主体传输流
 
 *********************************************************/

@interface AHServerResponseBodyTransferringStream : NSObject
{
    // 数据缓存
    NSMutableData *_buffer;
    
    // 传输结束标志
    BOOL _over;
    
    // 即将结束标志
    BOOL _toBeFinished;
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
 * @brief 传输是否结束
 * @result 传输是否结束
 */
- (BOOL)isOver;

@end


/*********************************************************
 
    @class
        AHServerResponseBodyChunkTransferringStream
 
    @abstract
        chunked编码的HTTP响应主体传输流
 
 *********************************************************/

@interface AHServerResponseBodyChunkTransferringStream : AHServerResponseBodyTransferringStream

@end


/*!
 * @brief chunked传输的块长度，80K字节
 */
extern NSUInteger const AHServerResponseBodyChunkSize;
