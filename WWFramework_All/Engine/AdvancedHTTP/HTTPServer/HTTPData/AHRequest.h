//
//  AHRequest.h
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHVersion.h"
#import "AHBody.h"

@class AHRequestHeader;

/*********************************************************
 
    @class
        AHRequest
 
    @abstract
        HTTP请求
 
 *********************************************************/

@interface AHRequest : NSObject

/*!
 * @brief 请求头
 */
@property (nonatomic) AHRequestHeader *header;

/*!
 * @brief body
 */
@property (nonatomic) AHBody *body;

@end


/*********************************************************
 
    @class
        AHRequestHeader
 
    @abstract
        HTTP请求头
 
 *********************************************************/

@interface AHRequestHeader : NSObject

/*!
 * @brief HTTP版本
 */
@property (nonatomic) AHVersion version;

/*!
 * @brief URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 请求方法
 * @discussion 取值支持GET和POST
 */
@property (nonatomic, copy) NSString *method;

/*!
 * @brief 请求首部
 */
@property (nonatomic) NSDictionary *headerFields;

/*!
 * @brief 超时时间
 */
@property (nonatomic) NSTimeInterval timeout;

@end
