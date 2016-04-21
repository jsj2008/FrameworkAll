//
//  AHResponseHeaderOutputStream.m
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHResponseMessageHeaderParsingStream.h"
#import "AHMessageHeader.h"

@interface AHResponseMessageHeaderParsingStream ()
{
    CFHTTPMessageRef _message;
}

@property (nonatomic) AHResponseMessageHeader *parsedHeader;

@end


@implementation AHResponseMessageHeaderParsingStream

- (void)dealloc
{
    CFRelease(_message);
}

- (id)init
{
    if (self = [super init])
    {
        _message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, NO);
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
            
            AHResponseMessageHeader *header = [[AHResponseMessageHeader alloc] init];
            
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
            
            header.statusCode = (NSInteger)CFHTTPMessageGetResponseStatusCode(_message);
            
            NSString *statusLine = (__bridge NSString *)CFHTTPMessageCopyResponseStatusLine(_message);
            
            NSArray *statusLineComponents = [statusLine componentsSeparatedByString:@" "];
            
            if ([statusLineComponents count] == 3)
            {
                header.statusDescription = [statusLineComponents objectAtIndex:2];
            }
            
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
