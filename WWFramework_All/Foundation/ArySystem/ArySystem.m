//
//  ArySystem.m
//  FoundationProject
//
//  Created by WW on 14-1-27.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "ArySystem.h"

@implementation NSString (ArySystem)

- (long long)numberValueWithAry:(int)ary
{
    return strtoll([self UTF8String], NULL, ary);
}

- (long long)binaryNumberValue
{
    return [self numberValueWithAry:2];
}

- (long long)octalNumberValue
{
    return [self numberValueWithAry:8];
}

- (long long)hexNumberValue
{
    return [self numberValueWithAry:16];
}

- (long long)autoNumberValue
{
    return [self numberValueWithAry:0];
}

@end
