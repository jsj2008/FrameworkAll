//
//  Account.m
//  Demo
//
//  Created by Baymax on 13-10-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "Account.h"

@implementation Account

- (id)init
{
    if (self = [super init])
    {
        self.accountType = AccountType_User;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Account *account = [[[self class] allocWithZone:zone] init];
    
    account.accountId = self.accountId;
    
    account.password = self.password;
    
    account.accountType = self.accountType;
    
    return account;
}

- (NSString *)identifier
{
    NSString *identifier = nil;
    
    if ([self.accountId length])
    {
        switch (self.accountType)
        {
            case AccountType_User:
                identifier = [NSString stringWithFormat:@"U_%@", self.accountId];
                break;
            case AccountType_Specific:
                identifier = [NSString stringWithFormat:@"S_%@", self.accountId];
                break;
            default:
                break;
        }
    }
    
    return identifier;
}

@end
