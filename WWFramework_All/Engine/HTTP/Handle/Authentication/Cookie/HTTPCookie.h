//
//  HTTPCookie.h
//  Application
//
//  Created by Baymax on 14-3-4.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"

/*********************************************************
 
    @class
        HTTPCookie
 
    @abstract
        HTTP的cookie对象
 
 *********************************************************/

@interface HTTPCookie : NSObject

/*!
 * @brief cookie的键值属性
 */
@property (nonatomic) NSDictionary *properties;

/*!
 * @brief cookie有效期开始时间
 */
@property (nonatomic) NSDate *startDate;

/*!
 * @brief cookie有效期时长
 */
@property (nonatomic) unsigned long long maxAge;

/*!
 * @brief cookie名
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief cookie值
 */
@property (nonatomic, copy) NSString *value;

/*!
 * @brief 是否为cookie版本1
 */
@property (nonatomic) BOOL isVersion1;

@end
