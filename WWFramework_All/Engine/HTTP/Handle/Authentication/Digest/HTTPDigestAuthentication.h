//
//  HTTPDigestAuthentication.h
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPAuthentication.h"
#import "HTTPAuthenticationAccount.h"

/*********************************************************
 
    @class
        HTTPDigestAuthentication
 
    @abstract
        HTTP摘要认证
 
    @discussion
        1，在本地验证时，为保证效率，不验证qop=auth-int的服务器授权信息
 
 *********************************************************/

@interface HTTPDigestAuthentication : HTTPAuthentication

/*!
 * @brief 认证账户
 */
@property (nonatomic) HTTPGeneralAuthenticationAccount *authenticationAccount;

@end
