//
//  BufferOutputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "DataOutputStream.h"

@implementation DataOutputStream

- (id)init
{
    if (self = [super init])
    {
        _buffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        [_buffer appendData:data];
    }
}

- (NSData *)data
{
    return _buffer;
}

- (NSUInteger)dataSize
{
    return [_buffer length];
}

- (void)resetOutput
{
    [_buffer setLength:0];
}

@end
