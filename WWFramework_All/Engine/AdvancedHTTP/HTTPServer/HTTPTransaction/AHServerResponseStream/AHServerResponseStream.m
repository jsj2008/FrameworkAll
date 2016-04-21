//
//  AHServerResponseStream.m
//  Application
//
//  Created by WW on 14-3-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerResponseStream.h"
#import "DataInputStream.h"
#import "AHServerResponseBodyStream.h"

@interface AHServerResponseStream ()
{
    // 响应主体数据的已读长度
    unsigned long long _bodyReadSize;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 首部流
 */
@property (nonatomic) InputStream *headerStream;

/*!
 * @brief 主体流
 */
@property (nonatomic) InputStream *bodyStream;

@end


@implementation AHServerResponseStream

- (id)initWithResponse:(AHResponse *)response
{
    if (self = [super init])
    {
        _code = AHServerCode_OK;
        
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateResponse(kCFAllocatorDefault, response.header.statusCode, (__bridge CFStringRef)(response.header.statusDescription), (response.header.statusCode == AHVersion_1_0) ? kCFHTTPVersion1_0 : kCFHTTPVersion1_1);
        
        NSMutableDictionary *headerFields = [NSMutableDictionary dictionaryWithDictionary:response.header.headerFields];
        
        if ([response.body isKindOfClass:[AHDataBody class]])
        {
            [headerFields removeObjectForKey:@"Transfer-Encoding"];
            
            AHServerResponseBodyStream *stream = [[AHServerResponseBodyStream alloc] initWithBody:response.body];
            
            [stream startWithHeaderFields:headerFields];;
            
            NSMutableData *newBodyData = [NSMutableData data];
            
            while (![stream isOver])
            {
                [newBodyData appendData:[stream readDataOfMaxLength:16 * 1024]];
            }
            
            [headerFields setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[newBodyData length]] forKey:@"Content-Length"];
            
            self.bodyStream = [[DataInputStream alloc] initWithData:newBodyData];
        }
        else if (response.body)
        {
            [headerFields setObject:@"chunked" forKey:@"Transfer-Encoding"];
            
            [headerFields removeObjectForKey:@"Content-Length"];
            
            AHServerResponseBodyStream *stream = [[AHServerResponseBodyStream alloc] initWithBody:response.body];
            
            [stream startWithHeaderFields:headerFields];
            
            self.bodyStream = stream;
        }
        
        for (NSString *key in [headerFields allKeys])
        {
            NSString *value = [headerFields objectForKey:key];
            
            CFHTTPMessageSetHeaderFieldValue(messageRef, (__bridge CFStringRef)key, (__bridge CFStringRef)value);
        }
        
        NSData *headerData = (__bridge NSData *)CFHTTPMessageCopySerializedMessage(messageRef);
        
        if ([headerData length])
        {
            self.headerStream = [[DataInputStream alloc] initWithData:headerData];
        }
        else
        {
            _code = AHServerCode_Response_InvalidResponse;
            
            self.bodyStream = nil;
        }
        
        CFRelease(messageRef);
        
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if (self.headerStream)
    {
        data = [self.headerStream readDataOfMaxLength:length];
        
        if ([self.headerStream isOver])
        {
            self.headerStream = nil;
        }
    }
    
    if (![data length] && self.bodyStream)
    {
        data = [self.bodyStream readDataOfMaxLength:length];
        
        if ([self.bodyStream isKindOfClass:[DataInputStream class]])
        {
            _bodyReadSize += [(DataInputStream *)(self.bodyStream) readSize];
        }
        else if ([self.bodyStream isKindOfClass:[AHServerResponseBodyStream class]])
        {
            _bodyReadSize += [(AHServerResponseBodyStream *)(self.bodyStream) readRawDataSize];
            
            _code = [(AHServerResponseBodyStream *)(self.bodyStream) streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return nil;
            }
        }
        
        if ([self.bodyStream isOver])
        {
            self.bodyStream = nil;
        }
    }
    
    if (!self.headerStream && !self.bodyStream)
    {
        _over = YES;
    }
    
    return data;
}

- (unsigned long long)bodyTotalReadSize
{
    return _bodyReadSize;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
