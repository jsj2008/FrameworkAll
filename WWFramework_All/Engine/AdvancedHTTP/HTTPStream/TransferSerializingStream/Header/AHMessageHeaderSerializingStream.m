//
//  AHMessageHeaderSerializingStream.m
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageHeaderSerializingStream.h"

@implementation AHMessageHeaderSerializingStream

- (id)initWithRequestMessageHeader:(AHRequestMessageHeader *)header
{
    if (self = [super init])
    {
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (__bridge CFStringRef)(header.method), (__bridge CFURLRef)(header.URL), (header.version == AHMessageVersion_1_0) ? kCFHTTPVersion1_0 : kCFHTTPVersion1_1);
        
        for (NSString *key in [header.headerFields allKeys])
        {
            NSString *value = [header.headerFields objectForKey:key];
            
            CFHTTPMessageSetHeaderFieldValue(messageRef, (__bridge CFStringRef)key, (__bridge CFStringRef)value);
        }
        
        [_buffer appendData:(__bridge NSData *)CFHTTPMessageCopySerializedMessage(messageRef)];
        
        CFRelease(messageRef);
    }
    
    return self;
}

- (id)initWithResponseMessageHeader:(AHResponseMessageHeader *)header
{
    if (self = [super init])
    {
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateResponse(kCFAllocatorDefault, (CFIndex)(header.statusCode), (__bridge CFStringRef)(header.statusDescription), (header.version == AHMessageVersion_1_0) ? kCFHTTPVersion1_0 : kCFHTTPVersion1_1);
        
        for (NSString *key in [header.headerFields allKeys])
        {
            NSString *value = [header.headerFields objectForKey:key];
            
            CFHTTPMessageSetHeaderFieldValue(messageRef, (__bridge CFStringRef)key, (__bridge CFStringRef)value);
        }
        
        [_buffer appendData:(__bridge NSData *)CFHTTPMessageCopySerializedMessage(messageRef)];
        
        CFRelease(messageRef);
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
