//
//  AHRequestHeaderOutputStream.m
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHRequestMessageHeaderParsingStream.h"
#import "AHMessageHeader.h"

@interface AHRequestMessageHeaderParsingStream ()
{
    CFHTTPMessageRef _message;
}

@property (nonatomic) AHRequestMessageHeader *parsedHeader;

@end


@implementation AHRequestMessageHeaderParsingStream

- (void)dealloc
{
    CFRelease(_message);
}

- (id)init
{
    if (self = [super init])
    {
        _message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, YES);
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
    
    if (!_isOverFlowed)
    {
        CFHTTPMessageAppendBytes(_message, [_buffer bytes], [_buffer length]);
        
        _headerSize += [_buffer length];
        
        [_buffer setLength:0];
        
        if (CFHTTPMessageIsHeaderComplete(_message))
        {
            _isOverFlowed = YES;
            
            NSData *bodyData = (__bridge NSData *)CFHTTPMessageCopyBody(_message);
            
            [_buffer appendData:bodyData];
            
            AHRequestMessageHeader *header = [[AHRequestMessageHeader alloc] init];
            
            NSString *versionString = (__bridge NSString *)CFHTTPMessageCopyVersion(_message);
            
            if ([versionString isEqualToString:(NSString *)kCFHTTPVersion1_0])
            {
                header.version = AHMessageVersion_1_0;
            }
            else if ([versionString isEqualToString:(NSString *)kCFHTTPVersion1_1])
            {
                header.version = AHMessageVersion_1_1;
            }
            else
            {
                header.version = AHMessageVersion_Undefined;
            }
            
            header.URL = (__bridge NSURL *)CFHTTPMessageCopyRequestURL(_message);
            
            header.method = (__bridge NSString *)CFHTTPMessageCopyRequestMethod(_message);
            
            header.headerFields = (__bridge NSDictionary *)CFHTTPMessageCopyAllHeaderFields(_message);
            
            self.parsedHeader = header;
        }
        else
        {
            if (_headerSize > AHMessageHeaderParsingStreamMaxRecognizedHeaderSize)
            {
                _code = AHMessageStreamCode_UnrecognizedHeader;
            }
        }
    }
}

- (AHMessageHeader *)header
{
    return self.parsedHeader;
}

@end
