//
//  HTTPAccount.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "Account.h"

/*********************************************************
 
    @class
        HTTPAccount
 
    @abstract
        HTTP框架使用的账户
 
 *********************************************************/

@interface HTTPAccount : Account

/*!
 * @brief 初始化
 * @param account 应用账户
 * @result 初始化后的对象
 */
- (id)initWithAccount:(Account *)account;

@end


/*********************************************************
 
    @category
        HTTPAccount (Special)
 
    @abstract
        HTTP账户的扩展，封装专用账户
 
 *********************************************************/

@interface HTTPAccount (Special)

/*!
 * @brief 公有缓存账户
 */
+ (HTTPAccount *)publicCacheAccount;

@end
