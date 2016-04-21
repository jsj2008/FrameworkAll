//
//  AHResponse.h
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHVersion.h"
#import "AHBody.h"

@class AHResponseHeader;

/*********************************************************
 
    @class
        AHResponse
 
    @abstract
        HTTP响应
 
 *********************************************************/

@interface AHResponse : NSObject

/*!
 * @brief 响应头
 */
@property (nonatomic) AHResponseHeader *header;

/*!
 * @brief body
 */
@property (nonatomic) AHBody *body;

@end


/*********************************************************
 
    @class
        AHResponseHeader
 
    @abstract
        HTTP响应头
 
 *********************************************************/

@interface AHResponseHeader : NSObject

/*!
 * @brief HTTP版本
 */
@property (nonatomic) AHVersion version;

/*!
 * @brief 状态码
 */
@property (nonatomic) NSInteger statusCode;

/*!
 * @brief 状态描述
 */
@property (nonatomic, copy) NSString *statusDescription;

/*!
 * @brief 响应首部
 */
@property (nonatomic) NSDictionary *headerFields;

@end
