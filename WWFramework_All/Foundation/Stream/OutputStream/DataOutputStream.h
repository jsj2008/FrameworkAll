//
//  BufferOutputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "OutputStream.h"
#import "OutputStreamResetting.h"

/*********************************************************
 
    @class
        DataOutputStream
 
    @abstract
        字节数据输出流
 
 *********************************************************/

@interface DataOutputStream : OutputStream <OutputStreamResetting>
{
    // 字节数据缓冲
    NSMutableData *_buffer;
}

/*!
 * @brief 已写入流内的字节数据
 * @result 字节数据
 */
- (NSData *)data;

/*!
 * @brief 已写入流内的字节数据长度
 * @result 字节数据长度
 */
- (NSUInteger)dataSize;

@end
