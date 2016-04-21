//
//  BufferInputStream.h
//  Application
//
//  Created by Baymax on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "InputStream.h"

/*********************************************************
 
    @class
        BufferInputStream
 
    @abstract
        带缓冲区的输入流
 
 *********************************************************/

@interface BufferInputStream : InputStream
{
    // 数据缓冲区
    NSMutableData *_buffer;
}

@end
