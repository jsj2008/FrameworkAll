//
//  AHServerRequestBodyStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestBodyStream.h"
#import "AHServerRequestBodyTransferringStream.h"
#import "AHServerRequestBodyDecompressingStream.h"

@interface AHServerRequestBodyStream ()
{
    // 解析结果缓存
    NSMutableData *_outputData;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 请求头
 */
@property (nonatomic) AHRequestHeader *requestHeader;

/*!
 * @brief 传输解析流
 */
@property (nonatomic) AHServerRequestBodyTransferringStream *transferringStream;

/*!
 * @brief 解压流
 */
@property (nonatomic) AHServerRequestBodyDecompressingStream *decompressingStream;

@end


@implementation AHServerRequestBodyStream

- (id)init
{
    if (self = [super init])
    {
        _outputData = [[NSMutableData alloc] init];
        
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)startWithHeader:(AHRequestHeader *)header
{
    self.requestHeader = header;
    
    self.transferringStream = nil;
    
    self.decompressingStream = nil;
    
    NSString *transferEncoding = [header.headerFields objectForKey:@"Transfer-Encoding"];
    
    if ([[transferEncoding lowercaseString] isEqualToString:@"chunked"])
    {
        self.transferringStream = [[AHServerRequestBodyChunkTransferringStream alloc] init];
    }
    else if (transferEncoding)
    {
        _code = AHServerCode_Request_UnsupportedTransferringEncoding;
        
        return;
    }
    
    if (!self.transferringStream)
    {
        NSString *contentLength = [header.headerFields objectForKey:@"Content-Length"];
        
        if ([contentLength length])
        {
            unsigned long long length = [contentLength longLongValue];
            
            self.transferringStream = [[AHServerRequestBodyFixedLengthTransferringStream alloc] initWithFixedLength:length];
        }
        else
        {
            _code = AHServerCode_Request_UnknownContentLength;
            
            return;
        }
    }
    
    if (self.transferringStream)
    {
        NSString *contentEncoding = [header.headerFields objectForKey:@"Content-Encoding"];
        
        if ([[contentEncoding lowercaseString] isEqualToString:@"deflate"])
        {
            self.decompressingStream = [[AHServerRequestBodyDeflateDecompressingStream alloc] init];
        }
        else if ([[contentEncoding lowercaseString] isEqualToString:@"gzip"])
        {
            self.decompressingStream = [[AHServerRequestBodyGzipDecompressingStream alloc] init];
        }
        else if ([[contentEncoding lowercaseString] isEqualToString:@"identity"] || !contentEncoding)
        {
            self.decompressingStream = [[AHServerRequestBodyIdentityDecompressingStream alloc] init];
        }
        else
        {
            _code = AHServerCode_Request_UnsupportedContentEncoding;
            
            return;
        }
        
        if (self.decompressingStream)
        {
            _code = [self.decompressingStream streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return;
            }
        }
    }
    
    [_buffer setLength:0];
}

- (AHRequestHeader *)header
{
    return self.requestHeader;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    if (self.requestHeader && !_isOverFlowed)
    {
        if (![self.transferringStream isOverFlowed])
        {
            [self.transferringStream writeData:data];
            
            _code = [self.transferringStream streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return;
            }
            
            NSData *transferredData = [self.transferringStream output];
            
            if ([transferredData length])
            {
                [self.decompressingStream writeData:transferredData];
            }
            
            [self.transferringStream cleanOutput];
            
            _code = [self.decompressingStream streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return;
            }
            
            NSData *decompressedData = [self.decompressingStream output];
            
            [_outputData appendData:decompressedData];
            
            [self.decompressingStream cleanOutput];
            
            if ([self.transferringStream isOverFlowed])
            {
                if ([self.transferringStream overFlowedDataSize])
                {
                    [_buffer appendData:[self.transferringStream overFlowedData]];
                }
                
                self.transferringStream = nil;
                
                self.decompressingStream = nil;
                
                _isOverFlowed = YES;
            }
        }
    }
    else
    {
        [_buffer appendData:data];
    }
}

- (NSData *)output
{
    return _outputData;
}

- (void)cleanOutput
{
    [_outputData setLength:0];
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
