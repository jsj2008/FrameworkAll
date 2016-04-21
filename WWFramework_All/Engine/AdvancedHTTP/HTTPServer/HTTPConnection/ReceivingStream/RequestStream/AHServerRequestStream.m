//
//  AHServerRequestStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestStream.h"
#import "AHServerRequestHeaderStream.h"
#import "AHServerRequestBodyStream.h"
#import "AHServerRequestTrailerStream.h"

@interface AHServerRequestStream ()
{
    // 内部输出缓存
    NSMutableArray *_outputs;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief HTTP请求头解析流
 */
@property (nonatomic) AHServerRequestHeaderStream *headerStream;

/*!
 * @brief HTTP请求主体数据解析流
 */
@property (nonatomic) AHServerRequestBodyStream *bodyStream;

/*!
 * @brief HTTP请求拖挂解析流
 */
@property (nonatomic) AHServerRequestTrailerStream *trailerStream;

@end


@implementation AHServerRequestStream

- (id)init
{
    if (self = [super init])
    {
        self.headerStream = [[AHServerRequestHeaderStream alloc] init];
        
        self.bodyStream = [[AHServerRequestBodyStream alloc] init];
        
        self.trailerStream = [[AHServerRequestTrailerStream alloc] init];
        
        _outputs = [[NSMutableArray alloc] init];
        
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    NSData *remainingData = data;
    
    if (self.headerStream && ![self.headerStream isOverFlowed])
    {
        [self.headerStream writeData:remainingData];
        
        remainingData = nil;
        
        _code = [self.headerStream streamCode];
        
        if (_code != AHServerCode_OK)
        {
            return;
        }
        
        if ([self.headerStream isOverFlowed])
        {
            AHRequestHeader *header = [self.headerStream header];
            
            AHServerConnectionRequestHeaderOutput *element = [[AHServerConnectionRequestHeaderOutput alloc] init];
            
            element.header = header;
            
            [_outputs addObject:element];
            
            if ([self.headerStream overFlowedDataSize])
            {
                remainingData = [NSData dataWithData:[self.headerStream overFlowedData]];
            }
            
            self.headerStream = nil;
            
            [self.bodyStream startWithHeader:header];
            
            _code = [self.bodyStream streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return;
            }
        }
    }
    
    if (self.bodyStream && ![self.bodyStream isOverFlowed] && [remainingData length])
    {
        [self.bodyStream writeData:remainingData];
        
        remainingData = nil;
        
        _code = [self.bodyStream streamCode];
        
        if (_code != AHServerCode_OK)
        {
            return;
        }
        
        NSData *bodyData = [self.bodyStream output];
        
        if ([bodyData length])
        {
            AHServerConnectionRequestBodyDataOutput *element = [[AHServerConnectionRequestBodyDataOutput alloc] init];
            
            element.data = bodyData;
            
            [_outputs addObject:element];
        }
        
        if ([self.bodyStream isOverFlowed])
        {
            if ([self.bodyStream overFlowedDataSize])
            {
                remainingData = [NSData dataWithData:[self.bodyStream overFlowedData]];
            }
            
            [self.trailerStream startWithHeader:[self.bodyStream header]];
            
            self.bodyStream = nil;
            
            if ([self.trailerStream isOverFlowed])
            {
                self.trailerStream = nil;
            }
        }
    }
    
    if (self.trailerStream && ![self.trailerStream isOverFlowed] && [remainingData length])
    {
        [self.trailerStream writeData:remainingData];
        
        remainingData = nil;
        
        _code = [self.trailerStream streamCode];
        
        if (_code != AHServerCode_OK)
        {
            return;
        }
        
        NSDictionary *trailer = [self.trailerStream output];
        
        if ([trailer count])
        {
            AHServerConnectionRequestTrailerOutput *element = [[AHServerConnectionRequestTrailerOutput alloc] init];
            
            element.trailer = trailer;
            
            [_outputs addObject:element];
        }
        
        if ([self.trailerStream isOverFlowed])
        {
            if ([self.trailerStream overFlowedDataSize])
            {
                remainingData = [NSData dataWithData:[self.trailerStream overFlowedData]];
            }
            
            self.trailerStream = nil;
        }
    }
    
    if ([remainingData length])
    {
        [_buffer appendData:remainingData];
    }
    
    BOOL beforeOverFlowed = _isOverFlowed;
    
    _isOverFlowed = !self.headerStream && !self.bodyStream && !self.trailerStream;
    
    if (!beforeOverFlowed && _isOverFlowed)
    {
        AHServerConnectionRequestFinishingOutput *element = [[AHServerConnectionRequestFinishingOutput alloc] init];
        
        [_outputs addObject:element];
    }
}

- (NSArray *)outputs
{
    return _outputs;
}

- (void)cleanOutputs
{
    [_outputs removeAllObjects];
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
