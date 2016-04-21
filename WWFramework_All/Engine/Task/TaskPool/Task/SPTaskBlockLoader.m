//
//  SPTaskBlockLoader.m
//  TaskPool
//
//  Created by Baymax on 13-10-14.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "SPTaskBlockLoader.h"

@implementation SPTaskBlockLoader

- (id)initWithBlock:(void (^)(void))block
{
    if (self = [super init])
    {
        _block = block;
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
