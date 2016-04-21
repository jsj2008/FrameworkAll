//
//  OverFlowableOutputStream.h
//  Application
//
//  Created by Baymax on 14-2-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "OutputStream.h"

#pragma mark - BufferOutputStream

/*********************************************************
 
    @class
        BufferOutputStream
 
    @abstract
        包含字节缓冲区的输出流
 
 *********************************************************/

@interface BufferOutputStream : OutputStream
{
    // 字节数据缓冲
    NSMutableData *_buffer;
}

@end


#pragma mark - OverFlowableOutputStream

/*********************************************************
 
    @class
        OverFlowableOutputStream
 
    @abstract
        可溢出式输出流
 
    @discussion
        1，OverFlowableOutputStream可用于实现定长的字节流控制，指定数据结构的流式解析等
        2，OverFlowableOutputStream是一个纯基类，需要子类继承来实现具体功能
 
 *********************************************************/

@interface OverFlowableOutputStream : BufferOutputStream
{
    // 溢出标志
    BOOL _isOverFlowed;
}

/*!
 * @brief 数据是否已经溢出
 * @result 数据是否已经溢出
 */
- (BOOL)isOverFlowed;

/*!
 * @brief 溢出的数据
 * @result 溢出的数据
 */
- (NSData *)overFlowedData;

/*!
 * @brief 溢出的数据长度
 * @result 溢出的数据长度
 */
- (NSUInteger)overFlowedDataSize;

/*!
 * @brief 清理溢出的数据
 */
- (void)cleanOverFlowedData;

@end
