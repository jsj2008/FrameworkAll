//
//  Account.h
//  Demo
//
//  Created by Baymax on 13-10-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        AccountType
 
    @abstract
        用户账户类别
 
 *********************************************************/

typedef enum
{
    AccountType_User     = 1,   // 用户账户，用于标记使用者
    AccountType_Specific = 2    // 专用账户，用于特殊类型的账户
}AccountType;


/*********************************************************
 
    @class
        Account
 
    @abstract
        账户
 
    @discussion
        默认账户类型为AccountType_User
 
 *********************************************************/

@interface Account : NSObject <NSCopying>

/*!
 * @brief 用户id
 */
@property (nonatomic, copy) NSString *accountId;

/*!
 * @brief 账户密码
 */
@property (nonatomic, copy) NSString *password;

/*!
 * @brief 账户类型
 */
@property (nonatomic) AccountType accountType;

/*!
 * @brief 账户标识符，由账户名和类型唯一确定
 * @result 账户标识符，若类型为专用账户，标识符为S_账户名，类型为用户账户，标识符为U_账户名
 */
- (NSString *)identifier;

@end
