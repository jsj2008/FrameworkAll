//
//  HTTPAuthenticationAccount.h
//  Application
//
//  Created by NetEase on 14-8-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"

/*********************************************************
 
    @class
        HTTPAuthenticationAccount
 
    @abstract
        HTTP认证账户
 
    @discussion
        1，认证账户是HTTP认证时所使用的账户，与加载账户可以不一致（即当前加载账户可以使用其他账户来鉴权）
        2，认证账户可以包含多个子账户用于不同类型的认证
        3，子账户可以为nil，表征该子账户对应的认证将不生效；子账户名为@“”，对应的认证仍将生效
 
 *********************************************************/

@interface HTTPAuthenticationAccount : NSObject

/*!
 * @brief 认证主账户
 */
@property (nonatomic) HTTPAccount *userAccount;

@end


/*********************************************************
 
    @class
        HTTPGeneralAuthenticationAccount
 
    @abstract
        HTTP通用型认证账户
 
    @discussion
        1，通用型账户用于HTTP基本认证和摘要认证，也可以根据实际需要用于其他认证方式
        2，通用型账户的主账户用于默认认证（如基本认证和摘要认证的WWW-Authenticate认证），代理账户用于代理认证（如基本认证和摘要认证的Proxy-Authenticate认证）
 
 *********************************************************/

@interface HTTPGeneralAuthenticationAccount : HTTPAuthenticationAccount

/*!
 * @brief 代理认证账户
 */
@property (nonatomic) HTTPAccount *proxyUserAccount;

@end
