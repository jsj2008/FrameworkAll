//
//  DataBaseUnit.m
//  Demo
//
//  Created by Baymax on 13-10-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DataBaseUnit.h"

@implementation DataBaseUnit

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        self.handle = [[DBHandle alloc] initWithPath:filePath];
    }
    
    return self;
}

- (BOOL)start
{
    return [self.handle start];
}

@end
