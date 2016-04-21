//
//  AccountCenter.m
//  FoundationProject
//
//  Created by Baymax on 13-10-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "AccountCenter.h"
#import "APPConfiguration.h"

@interface AccountCenter ()

/*!
 * @brief 账户承载对象
 */
@property (atomic, copy) UserAccount *userAccount;

@end


@implementation AccountCenter

+ (AccountCenter *)sharedInstance
{
    static AccountCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[AccountCenter alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    
}

- (UserAccount *)currentUserAccount
{
    return (self.userAccount ? [self.userAccount copy] : [self defaultUserAccount]);
}

- (void)setCurrentUserAccount:(UserAccount *)account
{
    self.userAccount = account;
}

- (UserAccount *)defaultUserAccount
{
    UserAccount *account = [[UserAccount alloc] init];
    
    account.accountId = APP_DefaultUserAccountId;
    
    account.password = APP_DefaultUserAccountPassword;
    
    return account;
}

- (Account *)imageAccount
{
    Account *account = [[Account alloc] init];
    
    account.accountId = @"image";
    
    account.password = @"image";
    
    account.accountType = AccountType_Specific;
    
    return account;
}

@end
