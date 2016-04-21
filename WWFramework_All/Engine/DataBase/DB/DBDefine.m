//
//  DBDefine.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBDefine.h"

#pragma mark - SMDBTableField

@implementation DBTableField

- (id)initWithName:(NSString *)name1 type:(DBValueType)type1 primary:(BOOL)primary1
{
    if (self = [super init])
    {
        self.name = name1;
        
        self.type = type1;
        
        self.primary = primary1;
    }
    
    return self;
}

@end
