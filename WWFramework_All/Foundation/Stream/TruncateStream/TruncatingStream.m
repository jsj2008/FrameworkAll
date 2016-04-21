//
//  TruncatingStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "TruncatingStream.h"

@interface TruncatingStream ()
{
    // 预留缓冲区大小，用于在缓冲区中保存一定长度数据用于后续判断分隔符
    NSUInteger _reservedBufferSize;
}

@end


@implementation TruncatingStream

- (id)initWithSeparators:(NSArray<NSData *> *)separators
{
    if (self = [super init])
    {
        _buffer = [[NSMutableData alloc] init];
        
        _truncatedComponents = [[NSMutableArray alloc] init];
        
        _separators = [separators copy];
        
        _reservedBufferSize = 0;
        
        for (NSData *data in separators)
        {
            NSUInteger length = [data length];
            
            if (length > _reservedBufferSize)
            {
                _reservedBufferSize = length;
            }
        }
    }
    
    return self;
}

- (void)appendData:(NSData *)data
{
    [_buffer appendData:data];
}

- (void)truncate
{
    BOOL flag = NO;
    
    NSRange subRange = NSMakeRange(0, 0);
    
    NSRange searchRange = NSMakeRange(0, 0);
    
    do
    {
        flag = NO;
        
        searchRange = NSMakeRange(0, [_buffer length]);
        
        for (NSData *separator in _separators)
        {
            subRange = [_buffer rangeOfData:separator options:0 range:searchRange];
            
            if (subRange.location != NSNotFound)
            {
                flag = YES;
                
                TruncatingStreamTruncatedComponent *component = [[TruncatingStreamTruncatedComponent alloc] init];
                
                component.truncatingSeparator = separator;
                
                component.truncatedData = [_buffer subdataWithRange:NSMakeRange(0, subRange.location)];
                
                [_truncatedComponents addObject:component];
                
                [_buffer replaceBytesInRange:NSMakeRange(0, subRange.location + subRange.length) withBytes:NULL length:0];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(truncatingStream:shouldContinueTruncatingOnDidTruncateOneComponent:)])
                {
                    flag = [self.delegate truncatingStream:self shouldContinueTruncatingOnDidTruncateOneComponent:component];
                }
                
                break;
            }
        }
    } while (flag);
}

- (NSArray<TruncatingStreamTruncatedComponent *> *)truncatedComponents
{
    return _truncatedComponents;
}

- (void)cleanTruncatedComponents
{
    [_truncatedComponents removeAllObjects];
}

- (NSData *)untruncatedData
{
    return _buffer;
}

- (NSData *)readAvailableUntruncatedData
{
    NSData *data = nil;
    
    NSInteger readLegnth = [_buffer length] - _reservedBufferSize;
    
    if (readLegnth > 0)
    {
        data = [_buffer subdataWithRange:NSMakeRange(0, readLegnth)];
        
        [_buffer replaceBytesInRange:NSMakeRange(0, readLegnth) withBytes:NULL length:0];
    }
    
    return data;
}

@end


@implementation TruncatingStreamTruncatedComponent

@end
