//
//  AHChunkInputStream.h
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"

/*********************************************************
 
    @class
        AHChunkInputStream
 
    @abstract
        chunked数据块输入流，将原始字节数据转换成HTTP的chunked数据块
 
    @discussion
        允许对空数据进行转换
 
 *********************************************************/

@interface AHMessageBodyChunkDataSerializingStream : BufferInputStream

/*!
 * @brief 初始化
 * @param rawData 原始数据
 * @result 初始化后的对象
 */
- (id)initWithRawData:(NSData *)rawData;

/*!
 * @brief 读取所有转换后的数据
 * @result 转换后的数据
 */
- (NSData *)readAllData;

@end
