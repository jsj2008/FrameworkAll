//
//  DataInputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "InputStream.h"
#import "InputStreamResetting.h"

/*********************************************************
 
    @class
        DataInputStream
 
    @abstract
        字节输入流
 
 *********************************************************/

@interface DataInputStream : InputStream <InputStreamResetting>
{
    // 字节数据缓冲
    NSData *_buffer;
}

/*!
 * @brief 初始化
 * @param data 字节数据
 * @result 初始化后的对象
 */
- (id)initWithData:(NSData *)data;

/*!
 * @brief 读取所有数据
 * @discussion 读取所有数据后，流结束
 * @result 数据
 */
- (NSData *)readAllData;

/*!
 * @brief 已读数据的大小
 * @result 已读数据的大小
 */
- (NSUInteger)readSize;

@end
