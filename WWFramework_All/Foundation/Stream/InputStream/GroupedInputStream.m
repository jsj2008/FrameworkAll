//
//  GroupedInputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-16.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "GroupedInputStream.h"

@interface GroupedInputStream ()
{
    // 当前流在流集合中的索引位置
    NSUInteger _currentStreamIndex;
}

/*!
 * @brief 当前数据流
 */
@property (nonatomic) InputStream *currentStream;

@end


@implementation GroupedInputStream

- (id)initWithStreamGroup:(NSArray *)group
{
    if (self = [super init])
    {
        _streamGroup = [[NSMutableArray alloc] initWithArray:group];
        
        if ([group isKindOfClass:[NSMutableArray class]])
        {
            _streamGroup = [[NSArray alloc] initWithArray:group];
        }
        else
        {
            _streamGroup = group;
        }
        
        _over = !([_streamGroup count] > 0);
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSMutableData *data = [NSMutableData data];
    
    if (!_over)
    {
        while ([data length] < length)
        {
            @autoreleasepool
            {
                if (self.currentStream)
                {
                    if ([self.currentStream isOver])
                    {
                        self.currentStream = nil;
                    }
                    else
                    {
                        NSData *streamData = [self.currentStream readDataOfMaxLength:(length - [data length])];
                        
                        if ([streamData length])
                        {
                            [data appendData:streamData];
                        }
                    }
                }
                
                if (!self.currentStream)
                {
                    if ([_streamGroup count])
                    {
                        _currentStreamIndex ++;
                        
                        self.currentStream = [_streamGroup objectAtIndex:_currentStreamIndex];
                    }
                    else
                    {
                        _over = YES;
                        
                        break;
                    }
                }
            }
        }
        
        if (![data length])
        {
            _over = YES;
        }
    }
    
    return [data length] ? data : nil;
}

- (void)resetInput
{
    _over = !([_streamGroup count] > 0);;
    
    _currentStreamIndex = 0;
    
    for (InputStream *stream in _streamGroup)
    {
        if ([stream conformsToProtocol:@protocol(InputStreamResetting)])
        {
            [(id<InputStreamResetting>)stream resetInput];
        }
    }
}

@end
