//
//  AHServerConnectionRequestOutput.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHRequest.h"

/*********************************************************
 
    @class
        AHServerConnectionRequestOutput
 
    @abstract
        HTTP请求的解析输出块
 
 *********************************************************/

@interface AHServerConnectionRequestOutput : NSObject

@end


/*********************************************************
 
    @class
        AHServerConnectionRequestHeaderOutput
 
    @abstract
        HTTP请求头的解析输出块
 
 *********************************************************/

@interface AHServerConnectionRequestHeaderOutput : AHServerConnectionRequestOutput

/*!
 * @brief 请求头
 */
@property (nonatomic) AHRequestHeader *header;

@end


/*********************************************************
 
    @class
        AHServerConnectionRequestBodyDataOutput
 
    @abstract
        HTTP请求主体数据的解析输出块
 
 *********************************************************/

@interface AHServerConnectionRequestBodyDataOutput : AHServerConnectionRequestOutput

/*!
 * @brief 请求数据
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        AHServerConnectionRequestTrailerOutput
 
    @abstract
        HTTP请求拖挂的解析输出块
 
 *********************************************************/

@interface AHServerConnectionRequestTrailerOutput : AHServerConnectionRequestOutput

/*!
 * @brief 请求拖挂
 */
@property (nonatomic) NSDictionary *trailer;

@end


/*********************************************************
 
    @class
        AHServerConnectionRequestFinishingOutput
 
    @abstract
        HTTP请求结束的解析输出块
 
 *********************************************************/

@interface AHServerConnectionRequestFinishingOutput : AHServerConnectionRequestOutput

@end
