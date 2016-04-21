//
//  HTTPBasicAuthentication.h
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPAuthentication.h"
#import "HTTPAuthenticationAccount.h"

/*********************************************************
 
    @class
        HTTPBasicAuthentication
 
    @abstract
        HTTP基本认证
 
 *********************************************************/

@interface HTTPBasicAuthentication : HTTPAuthentication

/*!
 * @brief 认证账户
 */
@property (nonatomic) HTTPGeneralAuthenticationAccount *authenticationAccount;

@end
