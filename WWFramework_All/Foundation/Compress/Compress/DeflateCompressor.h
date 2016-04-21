//
//  HTTPDeflateCompressor.h
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "GeneralCompressor.h"

/******************************************************
 
    @enum
        DeflateCompressLevel
 
    @abstract
        Deflate编码等级
 
    @discussion
        压缩速度越快，压缩率越低，反之亦然
 
 ******************************************************/

typedef enum
{
    DeflateCompressLevel_NoCompress   = 0,
    DeflateCompressLevel_BestSpeed    = 1,
    DeflateCompressLevel_GoodSpeed    = 4,
    DeflateCompressLevel_GoodCompress = 8,
    DeflateCompressLevel_BestCompress = 9,
    DeflateCompressLevel_Default      = 6
}DeflateCompressLevel;

/******************************************************
 
    @class
        DeflateCompressor
 
    @abstract
        GeneralCompressor的子类，负责deflate格式压缩
 
 ******************************************************/

@interface DeflateCompressor : GeneralCompressor
{
    // 压缩等级
    DeflateCompressLevel _compressLevel;
}

/*!
 * @brief 初始化
 * @param level 压缩等级
 * @result 初始化后的对象
 */
- (id)initWithCompressLevel:(DeflateCompressLevel)level;

@end
