//
//  AHMessageHeader.h
//  Application
//
//  Created by WW on 14-4-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHMessageVersion.h"

/*********************************************************
 
    @class
        AHMessageHeader
 
    @abstract
        HTTP报文头
 
 *********************************************************/

@interface AHMessageHeader : NSObject

/*!
 * @brief HTTP版本
 */
@property (nonatomic) AHMessageVersion version;

/*!
 * @brief 首部
 */
@property (nonatomic) NSDictionary *headerFields;

@end


/*********************************************************
 
    @class
        AHRequestHeader
 
    @abstract
        HTTP请求报文头
 
 *********************************************************/

@interface AHRequestMessageHeader : AHMessageHeader

/*!
 * @brief URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 请求方法
 * @discussion 取值支持GET和POST
 */
@property (nonatomic, copy) NSString *method;

@end


/*********************************************************
 
    @class
        AHResponseHeader
 
    @abstract
        HTTP响应报文头
 
 *********************************************************/

@interface AHResponseMessageHeader : AHMessageHeader

/*!
 * @brief 状态码
 */
@property (nonatomic) NSInteger statusCode;

/*!
 * @brief 状态描述
 */
@property (nonatomic, copy) NSString *statusDescription;

@end
