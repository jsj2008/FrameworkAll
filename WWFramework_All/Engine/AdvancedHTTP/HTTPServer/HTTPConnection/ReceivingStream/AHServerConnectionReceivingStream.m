//
//  AHServerConnectionReceivingStream.m
//  Application
//
//  Created by WW on 14-3-13.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerConnectionReceivingStream.h"
#import "AHServerRequestStream.h"

@interface AHServerConnectionReceivingStream ()
{
    // 内部输出缓存
    NSMutableArray *_outputs;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 请求解析流
 */
@property (nonatomic) AHServerRequestStream *requestStream;

@end


@implementation AHServerConnectionReceivingStream

- (id)init
{
    if (self = [super init])
    {
        self.requestStream = [[AHServerRequestStream alloc] init];
        
        _outputs = [[NSMutableArray alloc] init];
        
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)resetOutput
{
    [_outputs removeAllObjects];
    
    self.requestStream = [[AHServerRequestStream alloc] init];
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    [self.requestStream writeData:data];
    
    _code = [self.requestStream streamCode];
    
    if (_code == AHServerCode_OK)
    {
        NSArray *outputs = [self.requestStream outputs];
        
        if ([outputs count])
        {
            [_outputs addObjectsFromArray:outputs];
            
            [self.requestStream cleanOutputs];
        }
        
        if ([self.requestStream isOverFlowed])
        {
            AHServerRequestStream *stream = [[AHServerRequestStream alloc] init];
            
            if ([self.requestStream overFlowedDataSize])
            {
                [stream writeData:[self.requestStream overFlowedData]];
                
                _code = [self.requestStream streamCode];
            }
            
            self.requestStream = stream;
        }
    }
}

- (AHServerConnectionRequestOutput *)output
{
    AHServerConnectionRequestOutput *output = nil;
    
    if ([_outputs count])
    {
        output = [_outputs objectAtIndex:0];
        
        [_outputs removeObjectAtIndex:0];
    }
    
    return output;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
