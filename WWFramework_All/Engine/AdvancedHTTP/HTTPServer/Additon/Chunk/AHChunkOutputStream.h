//
//  AHChunkOutputStream.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"

/*********************************************************
 
    @class
        AHChunkOutputStream
 
    @abstract
        chunked数据块输出流，将chunked数据块转换成HTTP的原始字节数据
 
    @discussion
        本流不解析拖挂数据，当遇到0\r\n字节数据便结束，结尾的\r\n不解析
 
 *********************************************************/

@interface AHChunkOutputStream : OverFlowableOutputStream

/*!
 * @brief 当前获得的所有原始数据
 * @result 原始数据
 */
- (NSData *)rawData;

/*!
 * @brief 清理当前获得的所有原始数据
 */
- (void)cleanRawData;

/*!
 * @brief 当前流运作是否正常
 * @result 当前流运作是否正常
 */
- (BOOL)isOK;

@end
