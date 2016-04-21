//
//  BlockTask.m
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "BlockTask.h"

#pragma mark - BlockTask

@interface BlockTask ()
{
    NSMutableDictionary *_context;
}

@end


@implementation BlockTask

@synthesize context = _context;

- (instancetype)init
{
    if (self = [super init])
    {
        _context = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)run
{
    self.dispatcher = nil;
    
    if (self.block)
    {
        self.block();
    }
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(blockTaskDidFinish:)])
        {
            [self.delegate blockTaskDidFinish:self];
        }
    }];
}

- (void)cancel
{
    self.runStatus = SPTaskRunStatus_Finish;
}

@end


#pragma mark - NSMutableDictionary (BlockTask)

@implementation NSMutableDictionary (BlockTask)

- (void)setBlockTaskContextObject:(id)object forKey:(NSString *)key
{
    if (object && [key length])
    {
        [self setObject:object forKey:key];
    }
}

@end
