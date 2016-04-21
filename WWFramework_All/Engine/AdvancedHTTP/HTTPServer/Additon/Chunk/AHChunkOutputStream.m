//
//  AHChunkOutputStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHChunkOutputStream.h"

/*********************************************************
 
    @enum
        AHChunkOutputStreamStatus
 
    @abstract
        流运行阶段
 
 *********************************************************/

typedef enum
{
    AHChunkOutputStreamStatus_Size = 1,  // 解析chunk块大小
    AHChunkOutputStreamStatus_Data = 2,  // 解析chunk块内数据
    AHChunkOutputStreamStatus_CRLT = 3   // 解析chunk块结束符（CRLT）
}AHChunkOutputStreamStatus;


@interface AHChunkOutputStream ()
{
    // 当前chunk块大小
    NSInteger _currentChunkSize;
    
    // 当前chunk块中被解析过的数据大小
    NSUInteger _currentParsedSize;
    
    // 当前流运行阶段
    AHChunkOutputStreamStatus _status;
    
    // 流运作是否正常的标志
    BOOL _ok;
    
    // 解析得到的chunk块的原始数据
    NSMutableData *_rawData;
}

@end


@implementation AHChunkOutputStream

- (id)init
{
    if (self = [super init])
    {
        _currentChunkSize = -1;
        
        _status = AHChunkOutputStreamStatus_Size;
        
        _ok = YES;
        
        _rawData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    NSData *crlfData = [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    [_buffer appendData:data];
    
    while (!_isOverFlowed && _ok && [_buffer length])
    {
        BOOL finishWhile = NO;
        
        switch (_status)
        {
            case AHChunkOutputStreamStatus_Size:
            {
                NSRange crlfRange = [_buffer rangeOfData:crlfData options:0 range:NSMakeRange(0, [_buffer length])];
                
                if (crlfRange.location != NSNotFound)
                {
                    NSData *sizeData = [_buffer subdataWithRange:NSMakeRange(0, crlfRange.location)];
                    
                    [_buffer replaceBytesInRange:NSMakeRange(0, crlfRange.location + crlfRange.length) withBytes:NULL length:0];
                    
                    NSString *sizeString = [[NSString alloc] initWithData:sizeData encoding:NSUTF8StringEncoding];
                    
                    if ([sizeString length] > 8)
                    {
                        _ok = NO;
                        
                        finishWhile = YES;;
                    }
                    
                    // 将字符串转换成无符号长整型数
                    _currentChunkSize = strtoul([sizeString UTF8String], NULL, 16);
                    
                    _status = AHChunkOutputStreamStatus_Data;
                    
                    _currentParsedSize = 0;
                    
                    if (_currentChunkSize == 0)
                    {
                        _isOverFlowed = YES;
                    }
                }
                else
                {
                    if ([_buffer length] > 8)
                    {
                        _ok = NO;
                    }
                    
                    finishWhile = YES;
                }
                
                break;
            }
            
            case AHChunkOutputStreamStatus_Data:
            {
                if ([_buffer length] >= (_currentChunkSize - _currentParsedSize))
                {
                    [_rawData appendData:[_buffer subdataWithRange:NSMakeRange(0, (_currentChunkSize - _currentParsedSize))]];
                    
                    [_buffer replaceBytesInRange:NSMakeRange(0, (_currentChunkSize - _currentParsedSize)) withBytes:NULL length:0];
                    
                    _currentParsedSize = _currentChunkSize;
                    
                    _status = AHChunkOutputStreamStatus_CRLT;
                }
                else
                {
                    _currentParsedSize += [_buffer length];
                    
                    [_rawData appendData:_buffer];
                    
                    [_buffer setLength:0];
                }
                
                break;
            }
                
            case AHChunkOutputStreamStatus_CRLT:
            {
                if ([_buffer length] >= 2)
                {
                    if ([[_buffer subdataWithRange:NSMakeRange(0, 2)] isEqualToData:crlfData])
                    {
                        [_buffer replaceBytesInRange:NSMakeRange(0, 2) withBytes:NULL length:0];
                        
                        _status = AHChunkOutputStreamStatus_Size;
                        
                        _currentParsedSize = 0;
                        
                        _currentChunkSize = -1;
                    }
                    else
                    {
                        _ok = NO;
                        
                        finishWhile = YES;
                    }
                }
                else
                {
                    finishWhile = YES;
                }
                
                break;
            }
                
            default:
                break;
        }
        
        if (finishWhile)
        {
            break;
        }
    }
}

- (NSData *)rawData
{
    return _rawData;
}

- (void)cleanRawData
{
    [_rawData setLength:0];
}

- (BOOL)isOK
{
    return _ok;
}

@end
