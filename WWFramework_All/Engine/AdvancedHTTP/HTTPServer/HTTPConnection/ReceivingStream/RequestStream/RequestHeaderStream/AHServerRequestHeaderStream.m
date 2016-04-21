//
//  AHServerRequestHeaderStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestHeaderStream.h"

NSUInteger const AHServerRequestHeaderMaxLength = 256 * 1024;


@interface AHServerRequestHeaderStream ()
{
    // 请求消息结构体，用来承载和解析请求头
    CFHTTPMessageRef _message;
    
    // 请求头长度，用来判断是否超过长度限制
    NSUInteger _headerSize;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 解析出的请求头
 */
@property (nonatomic) AHRequestHeader *requestHeader;

@end


@implementation AHServerRequestHeaderStream

- (void)dealloc
{
    CFRelease(_message); _message = NULL;
}

- (id)init
{
    if (self = [super init])
    {
        _message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, YES);
        
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
    
    if (!_isOverFlowed)
    {
        CFHTTPMessageAppendBytes(_message, [data bytes], [data length]);
        
        _headerSize += [data length];
        
        if (CFHTTPMessageIsHeaderComplete(_message))
        {
            _isOverFlowed = YES;
            
            NSData *bodyData = (__bridge NSData *)CFHTTPMessageCopyBody(_message);
            
            [_buffer appendData:bodyData];
            
            AHRequestHeader *header = [[AHRequestHeader alloc] init];
            
            NSString *versionString = (__bridge NSString *)CFHTTPMessageCopyVersion(_message);
            
            if ([versionString isEqualToString:(NSString *)kCFHTTPVersion1_0])
            {
                header.version = AHVersion_1_0;
            }
            else if ([versionString isEqualToString:(NSString *)kCFHTTPVersion1_1])
            {
                header.version = AHVersion_1_1;
            }
            else
            {
                header.version = AHVersion_Undefined;
            }
            
            header.URL = (__bridge NSURL *)CFHTTPMessageCopyRequestURL(_message);
            
            header.method = (__bridge NSString *)CFHTTPMessageCopyRequestMethod(_message);
            
            header.headerFields = (__bridge NSDictionary *)CFHTTPMessageCopyAllHeaderFields(_message);
            
            self.requestHeader = header;
        }
        else
        {
            if (_headerSize > AHServerRequestHeaderMaxLength)
            {
                _code = AHServerCode_Request_UnrecognizedHeader;
            }
        }
    }
    else
    {
        [_buffer appendData:data];
    }
}

- (AHRequestHeader *)header
{
    return self.requestHeader;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
