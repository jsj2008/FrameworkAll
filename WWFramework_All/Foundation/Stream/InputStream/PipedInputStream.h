//
//  PipedInputStream.h
//  Demo
//
//  Created by Baymax on 13-10-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "InputStream.h"

@protocol PipedInputStreamDelegate;


/*********************************************************
 
    @class
        PipedInputStream
 
    @abstract
        管道数据输入流，通过协议方式实现任意数据的流式输入
 
    @discussion
        1，从流中读取数据时，通过调用代理的协议方法读入数据，必须为InputStream指定代理对象并实现协议方法，否则每次读取数据为nil；
        2，流内读取不到有效数据时流结束
 
 *********************************************************/

@interface PipedInputStream : InputStream

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<PipedInputStreamDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        PipedInputStreamDelegate
 
    @abstract
        管道数据输入流的协议
 
 *********************************************************/

@protocol PipedInputStreamDelegate <NSObject>

/*!
 * @brief 读取数据
 * @param stream 所在流
 * @param length 读取长度
 * @result 读取到的数据，若为nil或长度为0，表征流结束
 */
- (NSData *)pipedInputStream:(PipedInputStream *)stream dataOfLength:(NSUInteger)length;

@end
