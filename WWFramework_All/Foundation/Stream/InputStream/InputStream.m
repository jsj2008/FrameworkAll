//
//  InputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "InputStream.h"

@implementation InputStream

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    _over = YES;
    
    return nil;
}

- (BOOL)isOver
{
    return _over;
}

@end
