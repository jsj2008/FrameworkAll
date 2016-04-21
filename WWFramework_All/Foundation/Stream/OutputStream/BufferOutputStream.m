//
//  OverFlowableOutputStream.m
//  Application
//
//  Created by Baymax on 14-2-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"

#pragma mark - BufferOutputStream

@implementation BufferOutputStream

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

@end


#pragma mark - OverFlowableOutputStream

@implementation OverFlowableOutputStream

- (BOOL)isOverFlowed
{
    return _isOverFlowed;
}

- (NSData *)overFlowedData
{
    return _buffer;
}

- (NSUInteger)overFlowedDataSize
{
    return [_buffer length];
}

- (void)cleanOverFlowedData
{
    [_buffer setLength:0];
}

@end
