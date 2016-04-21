//
//  BufferInputStream.m
//  Application
//
//  Created by Baymax on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"

@implementation BufferInputStream

- (id)init
{
    if (self = [super init])
    {
        _buffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if ([_buffer length] > length)
    {
        data = [_buffer subdataWithRange:NSMakeRange(0, length)];
        
        [_buffer replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
    }
    else
    {
        data = [NSData dataWithData:_buffer];
        
        [_buffer setLength:0];
    }
    
    return data;
}

@end
