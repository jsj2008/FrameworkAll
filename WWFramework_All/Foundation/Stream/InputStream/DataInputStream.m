//
//  DataInputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "DataInputStream.h"

@interface DataInputStream ()
{
    // 当前数据读取位置
    NSUInteger _readLocation;
}

@end


@implementation DataInputStream

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        if ([data length])
        {
            if ([data isKindOfClass:[NSMutableData class]])
            {
                _buffer = [[NSData alloc] initWithData:data];
            }
            else
            {
                _buffer = data;
            }
            
        }
        else
        {
            _over = YES;
        }
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if (_readLocation <= [_buffer length] - 1)
    {
        data = [_buffer subdataWithRange:NSMakeRange(_readLocation, MIN(length, [_buffer length] -_readLocation))];
        
        _readLocation += [data length];
    }
    
    _over = (_readLocation >= [_buffer length] - 1);
    
    return data;
}

- (NSData *)readAllData
{
    _over = YES;
    
    return [NSData dataWithData:_buffer];
}

- (NSUInteger)readSize
{
    return (_readLocation + 1);
}

- (void)resetInput
{
    _over = !([_buffer length] > 0);
    
    _readLocation = 0;
}

@end
