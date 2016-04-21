//
//  AHChunkInputStream.m
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHChunkInputStream.h"

@interface AHChunkInputStream ()
{
    // 转换后的数据缓存
    NSMutableData *_data;
}

@end


@implementation AHChunkInputStream

- (id)initWithRawData:(NSData *)data
{
    if (self = [super init])
    {
        _data = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"%lx\r\n", (unsigned long)[data length]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [_data appendData:data];
        
        [_data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if ([_data length] > length)
    {
        data = [_data subdataWithRange:NSMakeRange(0, length)];
        
        [_data replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
    }
    else
    {
        data = [NSData dataWithData:_data];
        
        [_data setLength:0];
        
        _over = YES;
    }
    
    return data;
}

- (NSData *)readAllData
{
    NSData *data = [NSData dataWithData:_data];
    
    [_data setLength:0];
    
    _over = YES;
    
    return data;
}

@end
