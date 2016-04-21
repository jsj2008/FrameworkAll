//
//  AHTrailerOutputStream.m
//  Application
//
//  Created by WW on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyTrailerParsingStream.h"

@interface AHMessageBodyTrailerParsingStream ()
{
    AHMessageStreamCode _code;
}

@property (nonatomic) NSMutableDictionary *trailerHeaderFields;

@end


@implementation AHMessageBodyTrailerParsingStream

- (id)init
{
    if (self = [super init])
    {
        _code = AHMessageStreamCode_Success;
        
        self.trailerHeaderFields = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (_code != AHMessageStreamCode_Success)
    {
        return;
    }
    
    [_buffer appendData:data];
    
    NSData *crlfData = [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    while (!_isOverFlowed && [_buffer length])
    {
        NSRange crlfRange = [_buffer rangeOfData:crlfData options:0 range:NSMakeRange(0, [_buffer length])];
        
        if (crlfRange.location != NSNotFound)
        {
            NSData *trailerData = [_buffer subdataWithRange:NSMakeRange(0, crlfRange.location)];
            
            [_buffer replaceBytesInRange:NSMakeRange(0, crlfRange.location + crlfRange.length) withBytes:NULL length:0];
            
            if (trailerData && [trailerData length])
            {
                NSString *trailerString = [[NSString alloc] initWithData:trailerData encoding:NSUTF8StringEncoding];
                
                NSArray *trailerHeaderKeyValue = [trailerString componentsSeparatedByString:@":"];
                
                if ([trailerHeaderKeyValue count] == 2)
                {
                    NSString *key = [trailerHeaderKeyValue objectAtIndex:0];
                    
                    NSString *value = [trailerHeaderKeyValue objectAtIndex:1];
                    
                    if (key && value)
                    {
                        [self.trailerHeaderFields setObject:value forKey:key];
                    }
                }
            }
            // 无数据，说明是结束符，结束拖挂
            else
            {
                _isOverFlowed = YES;
            }
        }
        else
        {
            break;
        }
    }
    
    if ([_buffer length] > AHMessageBodyTrailerParsingStreamMaxRecognizedTrailerSize)
    {
        _isOverFlowed = YES;
        
        _code = AHMessageStreamCode_UnrecognizedTrailer;
    }
}

- (NSDictionary *)trailer
{
    return [self.trailerHeaderFields count] ? self.trailerHeaderFields : nil;
}

- (AHMessageStreamCode)AHMessageStreamCode
{
    return _code;
}

@end


NSUInteger const AHMessageBodyTrailerParsingStreamMaxRecognizedTrailerSize = 64 * 1024;
