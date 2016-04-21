//
//  HTTPAccount.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPAccount.h"

@implementation HTTPAccount

- (id)initWithAccount:(Account *)account
{
    if (self = [super init])
    {
        self.accountId = [@"_" stringByAppendingString:account.accountId ? account.accountId : @""];
        
        self.password = account.password;
        
        self.accountType = account.accountType;
    }
    
    return self;
}

@end


@implementation HTTPAccount (Special)

+ (HTTPAccount *)publicCacheAccount
{
    HTTPAccount *account = [[HTTPAccount alloc] init];
    
    account.accountId = @"public_cache";
    
    account.password = @"public_cache";
    
    account.accountType = AccountType_Specific;
    
    return account;
}

@end
