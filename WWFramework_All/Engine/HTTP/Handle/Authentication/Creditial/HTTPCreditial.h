//
//  HTTPCreditial.h
//  Application
//
//  Created by Baymax on 14-2-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"

/*********************************************************
 
    @class
        HTTPCreditial
 
    @abstract
        HTTP认证证书
 
 *********************************************************/

@interface HTTPCreditial : NSObject

/*!
 * @brief 账户
 */
@property (nonatomic) HTTPAccount *account;

/*!
 * @brief 主机
 */
@property (nonatomic, copy) NSString *host;

/*!
 * @brief 认证值
 */
@property (nonatomic, copy) NSString *value;

@end
