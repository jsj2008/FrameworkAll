//
//  AHChunkInputStream.m
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyChunkDataSerializingStream.h"

@implementation AHMessageBodyChunkDataSerializingStream

- (id)initWithRawData:(NSData *)rawData
{
    if (self = [super init])
    {
        [_buffer appendData:[[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"%lx\r\n", (unsigned long)[rawData length]] dataUsingEncoding:NSUTF8StringEncoding]]];
        
        [_buffer appendData:rawData];
        
        [_buffer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
