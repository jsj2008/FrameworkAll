//
//  HTTPDecompressor.h
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        GeneralDecompressor
 
    @abstract
        数据解压器，负责对数据解压缩
 
    @discussion
        1. GeneralDecompressor本身解压时并不对数据进行解压编码，需要实现子类来完成解码功能
        2. 执行run方法后请尽快读取解码后数据并清空解码器内的这部分数据，避免内存暴涨
        3. 执行run返回NO说明解码出现故障，不能再继续解码
 
 ******************************************************/

@interface GeneralDecompressor : NSObject
{
    // 输入缓存，存放原始数据
    NSMutableData *_inputData;
    
    // 输出缓存，存放解码后数据
    NSMutableData *_outputData;
    
    // 完成标志
    BOOL _over;
}

/*!
 * @brief 启动解码器
 */
- (BOOL)start;

/*!
 * @brief 停止解码器
 */
- (void)stop;

/*!
 * @brief 添加原始数据
 * @param data 原始数据
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 解码
 * @discussion 解压过程将原始数据解码后存入输出缓存，并清空输入缓存
 */
- (BOOL)run;

/*!
 * @brief 查询是否结束
 * @result 是否结束
 */
- (BOOL)isOver;

/*!
 * @brief 读取输出缓存
 * @result 输出缓存
 */
- (NSData *)outputData;

/*!
 * @brief 清空输出缓存
 */
- (void)cleanOutput;

@end
