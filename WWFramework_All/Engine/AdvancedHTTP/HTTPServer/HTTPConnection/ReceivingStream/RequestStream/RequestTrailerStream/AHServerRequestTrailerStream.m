//
//  AHServerRequestTrailerStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestTrailerStream.h"

NSUInteger const AHServerRequestTrailerHeaderMaxLength = 256 * 1024;


@interface AHServerRequestTrailerStream ()
{
    AHServerCode _code;
}

@property (nonatomic) NSArray *trailerHeaderFieldNames;

@property (nonatomic) NSMutableDictionary *trailerHeaderFields;

@end


@implementation AHServerRequestTrailerStream

- (id)init
{
    if (self = [super init])
    {
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)startWithHeader:(AHRequestHeader *)header
{
    if ([[[header.headerFields objectForKey:@"Transfer-Encoding"] lowercaseString] isEqualToString:@"chunked"])
    {
        NSString *trailerString = [header.headerFields objectForKey:@"Trailer"];
        
        if (trailerString)
        {
            NSArray *components = [trailerString componentsSeparatedByString:@","];
            
            self.trailerHeaderFieldNames = components;
        }
        
        self.trailerHeaderFields = [NSMutableDictionary dictionary];
    }
    else
    {
        _isOverFlowed = YES;
    }
}

- (void)writeData:(NSData *)data
{
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
    
    if ([_buffer length] > AHServerRequestTrailerHeaderMaxLength)
    {
        _isOverFlowed = YES;
        
        _code = AHServerCode_Request_UnrecognizedTrailer;
    }
}

- (NSDictionary *)output
{
    return self.trailerHeaderFields;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
