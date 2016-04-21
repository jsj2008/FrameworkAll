//
//  HTTPMultipartTruncatingStream.m
//  FoundationProject
//
//  Created by Baymax on 14-1-18.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartBodyTruncatingStream.h"

@interface HTTPMultipartBodyTruncatingStream ()
{
    NSString *_boundary;
    
    NSData *_startSeparator;
    
    NSData *_fragmentSeparator;
    
    NSData *_endSeparator;
    
    HTTPMultipartBodyTruncateStatus _truncateStatus;
    
    NSMutableArray *_truncatedFragmentDatas;
}

@end


@implementation HTTPMultipartBodyTruncatingStream

- (id)initWithBoundary:(NSString *)boundary
{
    if (self = [super init])
    {
        _boundary = [boundary copy];
        
        _startSeparator = [[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
        
        _fragmentSeparator = [[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
        
        _endSeparator = [[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
        
        _truncateStatus = HTTPMultipartBodyTruncateStatus_Start;
        
        _truncatedFragmentDatas = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        [_buffer appendData:data];
        
        // 注意：这里即使截断的字节数据长度为0，也必须为其生成一份HTTPMultipartBodyTruncatedFragmentData对象，上层调用者需要使用该对象的完成属性来完成数据控制
        
        if (_truncateStatus == HTTPMultipartBodyTruncateStatus_Start)
        {
            NSRange range = [_buffer rangeOfData:_startSeparator options:0 range:NSMakeRange(0, [_buffer length])];
            
            if (range.location != NSNotFound)
            {
                _truncateStatus = HTTPMultipartBodyTruncateStatus_Fragment;
                
                [_buffer replaceBytesInRange:NSMakeRange(0, range.location + range.length) withBytes:NULL length:0];
            }
        }
        
        if (_truncateStatus == HTTPMultipartBodyTruncateStatus_Fragment)
        {
            NSRange subRange = NSMakeRange(0, 0);
            
            do {
                subRange = [_buffer rangeOfData:_fragmentSeparator options:0 range:NSMakeRange(0, [_buffer length])];
                
                if (subRange.location != NSNotFound)
                {
                    HTTPMultipartBodyTruncatedFragmentData *fragmentData = [[HTTPMultipartBodyTruncatedFragmentData alloc] init];
                    
                    fragmentData.isComplete = YES;
                    
                    fragmentData.data = [_buffer subdataWithRange:NSMakeRange(0, subRange.location)];
                    
                    [_truncatedFragmentDatas addObject:fragmentData];
                    
                    [_buffer replaceBytesInRange:NSMakeRange(0, subRange.location + subRange.length) withBytes:NULL length:0];
                }
                else
                {
                    break;
                }
            } while (1);
            
            subRange = [_buffer rangeOfData:_endSeparator options:0 range:NSMakeRange(0, [_buffer length])];
            
            if (subRange.location != NSNotFound)
            {
                HTTPMultipartBodyTruncatedFragmentData *fragmentData = [[HTTPMultipartBodyTruncatedFragmentData alloc] init];
                
                fragmentData.isComplete = YES;
                
                fragmentData.data = [_buffer subdataWithRange:NSMakeRange(0, subRange.location)];
                
                [_truncatedFragmentDatas addObject:fragmentData];
                
                [_buffer replaceBytesInRange:NSMakeRange(0, subRange.location + subRange.length) withBytes:NULL length:0];
                
                _truncateStatus = HTTPMultipartBodyTruncateStatus_End;
            }
            else
            {
                if ([_buffer length] > [_endSeparator length])
                {
                    NSUInteger validLength = [_buffer length] - [_endSeparator length];
                    
                    HTTPMultipartBodyTruncatedFragmentData *fragmentData = [[HTTPMultipartBodyTruncatedFragmentData alloc] init];
                    
                    fragmentData.isComplete = NO;
                    
                    fragmentData.data = [_buffer subdataWithRange:NSMakeRange(0, validLength)];
                    
                    [_truncatedFragmentDatas addObject:fragmentData];
                    
                    [_buffer replaceBytesInRange:NSMakeRange(0, validLength) withBytes:NULL length:0];
                }
            }
        }
    }
}

- (HTTPMultipartBodyTruncateStatus)truncatingStatus
{
    return _truncateStatus;
}

- (NSArray<HTTPMultipartBodyTruncatedFragmentData *> *)truncatedFragmentDatas
{
    return _truncatedFragmentDatas;
}

- (void)cleanTruncatedFragmentDatas
{
    [_truncatedFragmentDatas removeAllObjects];
}

- (NSData *)untruncatedData
{
    return _buffer;
}

@end


@implementation HTTPMultipartBodyTruncatedFragmentData

@end
