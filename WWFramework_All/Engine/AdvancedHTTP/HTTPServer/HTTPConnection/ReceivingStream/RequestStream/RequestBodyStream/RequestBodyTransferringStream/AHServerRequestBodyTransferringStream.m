//
//  AHServerRequestBodyTransferringStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestBodyTransferringStream.h"
#import "AHChunkOutputStream.h"

@implementation AHServerRequestBodyTransferringStream

- (id)init
{
    if (self = [super init])
    {
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    
}

- (NSData *)output
{
    return nil;
}

- (void)cleanOutput
{
    
}

- (AHServerCode)streamCode
{
    return _code;
}

@end


@interface AHServerRequestBodyFixedLengthTransferringStream ()
{
    // 定长的长度
    unsigned long long _fixedLength;
    
    // 当前处理过的长度
    unsigned long long _currentLength;
    
    // 解析结果的缓存
    NSMutableData *_output;
}

@end


@implementation AHServerRequestBodyFixedLengthTransferringStream

- (id)initWithFixedLength:(unsigned long long)length
{
    if (self = [super init])
    {
        _fixedLength = length;
        
        _output = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    if (!_isOverFlowed && _currentLength < _fixedLength)
    {
        if ([data length] <= (_fixedLength - _currentLength))
        {
            [_output appendData:data];
            
            _currentLength += [data length];
        }
        else
        {
            [_output appendData:[data subdataWithRange:NSMakeRange(0, (_fixedLength - _currentLength))]];
            
            [_buffer appendData:[data subdataWithRange:NSMakeRange((_fixedLength - _currentLength), ([data length] - _fixedLength + _currentLength))]];
            
            _currentLength = _fixedLength;
        }
        
        _isOverFlowed = (_currentLength >= _fixedLength);
    }
    else
    {
        [_buffer appendData:data];
    }
}

- (NSData *)output
{
    return _output;
}

- (void)cleanOutput
{
    [_output setLength:0];
}

@end


@interface AHServerRequestBodyChunkTransferringStream ()
{
    // 解析结果的缓存
    NSMutableData *_output;
}

/*!
 * @brief chunk数据块解析流
 */
@property (nonatomic, retain) AHChunkOutputStream *chunkStream;

@end


@implementation AHServerRequestBodyChunkTransferringStream

- (id)init
{
    if (self = [super init])
    {
        _output = [[NSMutableData alloc] init];
        
        self.chunkStream = [[AHChunkOutputStream alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    if (!_isOverFlowed && self.chunkStream && ![self.chunkStream isOverFlowed])
    {
        [self.chunkStream writeData:data];
        
        if (![self.chunkStream isOK])
        {
            _code = AHServerCode_Request_ChunkParseError;
            
            return;
        }
        
        [_output appendData:[self.chunkStream rawData]];
        
        [self.chunkStream cleanRawData];
        
        if ([self.chunkStream isOverFlowed])
        {
            if ([self.chunkStream overFlowedDataSize])
            {
                [_buffer appendData:[self.chunkStream overFlowedData]];
            }
            
            self.chunkStream = nil;
            
            _isOverFlowed = YES;
        }
    }
    else
    {
        [_buffer appendData:data];
    }
}

- (NSData *)output
{
    return _output;
}

- (void)cleanOutput
{
    [_output setLength:0];
}

@end
