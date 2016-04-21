//
//  AHServerResponseBodyTransferringStream.m
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerResponseBodyTransferringStream.h"
#import "AHChunkInputStream.h"

@implementation AHServerResponseBodyTransferringStream

- (id)init
{
    if (self = [super init])
    {
        _buffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)addInputData:(NSData *)data
{
    if (!_toBeFinished)
    {
        [_buffer appendData:data];
    }
}

- (void)finishStream
{
    _toBeFinished = YES;
}

- (NSData *)readDataOfLength:(NSUInteger)length
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
    
    _over = _toBeFinished && ![_buffer length];
    
    return data;
}

- (BOOL)isOver
{
    return _over;
}

@end


@interface AHServerResponseBodyChunkTransferringStream ()
{
    // chunk缓存
    NSMutableData *_chunkBuffer;
}

@end


@implementation AHServerResponseBodyChunkTransferringStream

- (id)init
{
    if (self = [super init])
    {
        _chunkBuffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)addInputData:(NSData *)data
{
    if (!_toBeFinished)
    {
        [_chunkBuffer appendData:data];
        
        if ([_chunkBuffer length] >= AHServerResponseBodyChunkSize)
        {
            AHChunkInputStream *chunkStream = [[AHChunkInputStream alloc] initWithRawData:_chunkBuffer];
            
            [_buffer appendData:[chunkStream readAllData]];
            
            [_chunkBuffer setLength:0];
        }
    }
}

- (void)finishStream
{
    _toBeFinished = YES;
    
    if ([_chunkBuffer length])
    {
        AHChunkInputStream *chunkStream = [[AHChunkInputStream alloc] initWithRawData:_chunkBuffer];
        
        [_buffer appendData:[chunkStream readAllData]];
        
        [_chunkBuffer setLength:0];
    }
    
    AHChunkInputStream *chunkStream = [[AHChunkInputStream alloc] initWithRawData:nil];
    
    [_buffer appendData:[chunkStream readAllData]];
}

@end


NSUInteger const AHServerResponseBodyChunkSize = 80 * 1024;
