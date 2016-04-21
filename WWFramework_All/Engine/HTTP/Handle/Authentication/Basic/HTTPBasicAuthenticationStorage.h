//
//  HTTPBasicAuthenticationStorage.h
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPBasicCreditial.h"


/*********************************************************
 
    @class
        HTTPBasicAuthenticationStorage
 
    @abstract
        HTTP基本认证的证书存储中心
 
    @discussion
        1，中心仅在内存中保存证书信息
        2，建立证书索引时，不能使用realm，尽管这样更准确。理由是，证书中心的证书仅在为请求预装认证首部时使用，此时不知道realm，且通常对同一客户端来说，可以认为服务器给出的realm总是相同的
 
 *********************************************************/

@interface HTTPBasicAuthenticationStorage : NSObject

/*!
 * @brief 单例
 */
+ (HTTPBasicAuthenticationStorage *)sharedInstance;

/*!
 * @brief 保存证书
 * @param creditial 证书
 * @param headerField 质询域
 * @param host 主机
 * @param account 账户
 */
- (void)saveCreditial:(HTTPBasicCreditial *)creditial forAuthenticationHeaderField:(NSString *)headerField ofHost:(NSString *)host account:(HTTPAccount *)account;

/*!
 * @brief 读取证书
 * @param headerField 质询域
 * @param host 主机
 * @param account 账户
 * @result 证书
 */
- (HTTPBasicCreditial *)creditialForAuthenticationHeaderField:(NSString *)headerField ofHost:(NSString *)host account:(HTTPAccount *)account;

/*!
 * @brief 读取证书
 * @param host 主机
 * @param account 账户
 * @result 证书
 */
- (NSDictionary<NSString *, HTTPBasicCreditial *> *)creditialsOfHost:(NSString *)host account:(HTTPAccount *)account;

@end
