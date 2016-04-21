//
//  HTTPTempResourceResponse.h
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPTempResourceResponse
 
    @abstract
        HTTP临时资源的响应头信息的缓存
 
 *********************************************************/

@interface HTTPTempResourceResponse : NSObject <NSCoding>

/*!
 * @brief 响应头
 */
@property (nonatomic) NSHTTPURLResponse *URLResponse;

/*!
 * @brief 有效期
 */
@property (nonatomic) NSDate *expireDate;

@end
