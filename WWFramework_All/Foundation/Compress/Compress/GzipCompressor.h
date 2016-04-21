//
//  HTTPGzipCompressor.h
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "GeneralCompressor.h"

/******************************************************
 
    @enum
        GzipCompressLevel
 
    @abstract
        Gzip编码等级
 
    @discussion
        压缩速度越快，压缩率越低，反之亦然
 
 ******************************************************/

typedef enum
{
    GzipCompressLevel_NoCompress = 0,
    GzipCompressLevel_BestSpeed = 1,
    GzipCompressLevel_GoodSpeed = 4,
    GzipCompressLevel_GoodCompress = 8,
    GzipCompressLevel_BestCompress = 9,
    GzipCompressLevel_Default = 6
}GzipCompressLevel;

/******************************************************
 
    @class
        GzipCompressor
 
    @abstract
        GeneralCompressor的子类，负责gzip格式压缩
 
 ******************************************************/

@interface GzipCompressor : GeneralCompressor
{
    // 压缩等级
    GzipCompressLevel _compressLevel;
}

/*!
 * @brief 初始化
 * @param level 压缩等级
 * @result 初始化后的对象
 */
- (id)initWithCompressLevel:(GzipCompressLevel)level;

@end
