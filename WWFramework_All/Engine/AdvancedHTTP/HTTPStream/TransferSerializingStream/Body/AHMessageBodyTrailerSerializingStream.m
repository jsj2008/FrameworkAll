//
//  AHMessageBodyTrailerInputStream.m
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyTrailerSerializingStream.h"

@implementation AHMessageBodyTrailerSerializingStream

- (id)initWithTrailer:(NSDictionary *)trailer
{
    if (self = [super init])
    {
        NSMutableString *trailerString = [NSMutableString string];
        
        for (NSString *key in [trailer allKeys])
        {
            NSString *value = [trailer objectForKey:key];
            
            [trailerString appendFormat:@"%@:%@\r\n", key, value];
        }
        
        if ([trailerString length])
        {
            [_buffer appendData:[trailerString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return self;
}

- (NSData *)readAllData
{
    NSData *data = [NSData dataWithData:_buffer];
    
    [_buffer setLength:0];
    
    _over = YES;
    
    return data;
}

@end
