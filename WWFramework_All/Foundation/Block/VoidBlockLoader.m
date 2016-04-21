//
//  VoidBlockLoader.m
//  Application
//
//  Created by Baymax on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "VoidBlockLoader.h"

@implementation VoidBlockLoader

- (id)initWithBlock:(void (^)(void))block
{
    if (self = [super init])
    {
        _block = [block copy];
    }
    
    return self;
}

- (void)exeBlock
{
    if (_block)
    {
        _block();
    }
}

@end
