//
//  AccountCenter.h
//  FoundationProject
//
//  Created by Baymax on 13-10-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "UserAccount.h"

/*********************************************************
 
    @class
        AccountCenter
 
    @abstract
        用户账户中心，管理所有用户账户和引擎账户
 
 *********************************************************/

@interface AccountCenter : NSObject

/*!
 * @brief 单例
 */
+ (AccountCenter *)sharedInstance;

/*!
 * @brief 启动
 * @discussion 可以在这里配置当前账户等信息
 */
- (void)start;


/********** user account **********/

/*!
 * @brief 获取当前用户账户
 * @result 当前用户账户的拷贝
 */
- (UserAccount *)currentUserAccount;

/*!
 * @brief 设置当前用户账户
 * @discussion 设置后的账户数据是传入参数的一份拷贝；可以在这里做一些账户相关的数据操作
 * @param account 账户
 */
- (void)setCurrentUserAccount:(UserAccount *)account;

/*!
 * @brief 获取默认用户账户
 * @discussion 账户名密码均为guest
 * @result 默认用户账户
 */
- (UserAccount *)defaultUserAccount;


/********** specific account **********/

/*!
 * @brief 获取图片账户
 * @discussion 图片账户管理应用的所有图片资源
 * @result 图片账户
 */
- (Account *)imageAccount;

@end
