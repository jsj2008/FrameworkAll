//
//  HTTPBasicCreditial.h
//  Application
//
//  Created by Baymax on 14-2-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPCreditial.h"

/*********************************************************
 
    @class
        HTTPBasicCreditial
 
    @abstract
        基本认证证书
 
 *********************************************************/

@interface HTTPBasicCreditial : HTTPCreditial

/*!
 * @brief 质询域
 */
@property (nonatomic, copy) NSString *authenticationHeaderField;

@end
