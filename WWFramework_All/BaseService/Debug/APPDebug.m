//
//  Debug.m
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "APPDebug.h"

@implementation APPDebug

+ (void)assertWithCondition:(BOOL)condition string:(NSString *)string
{
    NSAssert(condition, string);
}

@end
