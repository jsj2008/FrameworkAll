//
//  UserAccount.m
//  FoundationProject
//
//  Created by Baymax on 13-10-31.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

- (id)init
{
    if (self = [super init])
    {
        self.accountType = AccountType_User;
    }
    
    return self;
}

- (void)setAccountType:(AccountType)accountType
{
    
}

- (id)copyWithZone:(NSZone *)zone
{
    UserAccount *copy = [super copyWithZone:zone];
    
    copy.accountType = AccountType_User;
    
    return copy;
}

@end
