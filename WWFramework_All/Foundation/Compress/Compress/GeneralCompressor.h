//
//  HTTPCompressor.h
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        GeneralCompressor
 
    @abstract
        数据压缩器，负责对数据压缩编码
 
    @discussion
        1. GeneralCompressor本身压缩时并不对数据进行压缩编码，可以使用子类来完成编码功能
        2. 执行runWithEnd:方法后请尽快读取编码后数据并清空编码器内的这部分数据，避免内存暴涨
        3. 执行runWithEnd:返回NO说明编码出现故障，不能再继续编码
 
 ******************************************************/

@interface GeneralCompressor : NSObject
{
    // 输入缓冲，存放原始数据
    NSMutableData *_inputData;
    
    // 输出缓冲，存放编码后数据
    NSMutableData *_outputData;
}

/*!
 * @brief 启动编码器
 * @result 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 停止编码器
 */
- (void)stop;

/*!
 * @brief 添加原始数据
 * @param data 原始数据
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 编码
 * @discussion 本过程将原始数据编码后存入输出缓存，并清空输入缓存
 * @param end 本次操作是否需将所有剩余输入缓冲数据全部编码
 * @result 编码是否成功
 */
- (BOOL)runWithEnd:(BOOL)end;

/*!
 * @brief 读取输出缓冲
 * @result 输出缓冲
 */
- (NSData *)outputData;

/*!
 * @brief 清空输出缓冲
 */
- (void)cleanOutput;

@end
