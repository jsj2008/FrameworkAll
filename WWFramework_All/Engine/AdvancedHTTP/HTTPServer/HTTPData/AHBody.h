//
//  AHBody.h
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputStream.h"

/*********************************************************
 
    @protocol
        AHBodyInputStreaming
 
    @abstract
        HTTP主体数据流式化协议
 
 *********************************************************/

@protocol AHBodyInputStreaming <NSObject>

/*!
 * @brief 主体数据转换成输入流
 * @result 输入流
 */
- (InputStream *)bodyInputStream;

@end


/*********************************************************
 
    @class
        AHBody
 
    @abstract
        HTTP主体
 
 *********************************************************/

@interface AHBody : NSObject <AHBodyInputStreaming>

@end


/*********************************************************
 
    @class
        AHDataBody
 
    @abstract
        字节型HTTP主体
 
 *********************************************************/

@interface AHDataBody : AHBody

/*!
 * @brief 数据
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        AHDataBody
 
    @abstract
        流式HTTP主体
 
 *********************************************************/

@interface AHStreamBody : AHBody

/*!
 * @brief 数据输入流
 */
@property (nonatomic) InputStream *stream;

@end
