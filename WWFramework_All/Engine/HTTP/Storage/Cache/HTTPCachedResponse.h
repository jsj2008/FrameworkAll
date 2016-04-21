//
//  HTTPCachedResponse.h
//  FoundationProject
//
//  Created by Baymax on 14-2-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponse.h"

/*********************************************************
 
    @class
        HTTPCachedResponse
 
    @abstract
        HTTP响应的缓存
 
 *********************************************************/

@interface HTTPCachedResponse : NSObject <NSCoding>

/*!
 * @brief HTTP响应
 */
@property (nonatomic) HTTPResponse *response;

/*!
 * @brief 有效期
 */
@property (nonatomic) NSDate *expireDate;

@end
