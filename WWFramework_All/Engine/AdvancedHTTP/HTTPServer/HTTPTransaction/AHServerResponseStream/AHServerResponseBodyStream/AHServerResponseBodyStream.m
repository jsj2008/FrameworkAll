//
//  AHServerResponseBodyStream.m
//  Application
//
//  Created by WW on 14-3-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerResponseBodyStream.h"
#import "AHServerResponseBodyTransferringStream.h"
#import "AHServerResponseBodyCompressingStream.h"

@interface AHServerResponseBodyStream ()
{
    // 处理后的数据缓存
    NSMutableData *_buffer;
    
    // 响应主体数据已读长度
    unsigned long long _rawDataReadSize;
    
    // 流状态码
    AHServerCode _code;
}

/*!
 * @brief 响应主体原始数据流
 */
@property (nonatomic) InputStream *bodyDataStream;

/*!
 * @brief 传输流
 */
@property (nonatomic) AHServerResponseBodyTransferringStream *transferringStream;

/*!
 * @brief 压缩流
 */
@property (nonatomic) AHServerResponseBodyCompressingStream *compressingStream;

@end


@implementation AHServerResponseBodyStream

- (id)initWithBody:(AHBody *)body
{
    if (self = [super init])
    {
        _buffer = [[NSMutableData alloc] init];
        
        self.bodyDataStream = [body bodyInputStream];
        
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)startWithHeaderFields:(NSDictionary *)headerFields
{
    if ([[[headerFields objectForKey:@"Transfer-Encoding"] lowercaseString] isEqualToString:@"chunked"])
    {
        self.transferringStream = [[AHServerResponseBodyChunkTransferringStream alloc] init];
    }
    else
    {
        self.transferringStream = [[AHServerResponseBodyTransferringStream alloc] init];
    }
    
    NSString *contentEncoding = [headerFields objectForKey:@"Content-Encoding"];
    
    if ([[contentEncoding lowercaseString] isEqualToString:@"deflate"])
    {
        self.compressingStream = [[AHServerResponseBodyDeflateCompressingStream alloc] init];
    }
    else if ([[contentEncoding lowercaseString] isEqualToString:@"gzip"])
    {
        self.compressingStream = [[AHServerResponseBodyGzipCompressingStream alloc] init];
    }
    else if ([[contentEncoding lowercaseString] isEqualToString:@"identity"] || !contentEncoding)
    {
        self.compressingStream = [[AHServerResponseBodyIdentityCompressingStream alloc] init];
    }
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    while (([_buffer length] < length) && (self.bodyDataStream || self.transferringStream || self.compressingStream))
    {
        NSData *rawData = [self.bodyDataStream readDataOfMaxLength:length];
        
        _rawDataReadSize += [rawData length];;
        
        [self.compressingStream addInputData:rawData];
        
        if (self.bodyDataStream && [self.bodyDataStream isOver])
        {
            self.bodyDataStream = nil;
            
            [self.compressingStream finishStream];
        }
        
        [self.transferringStream addInputData:[self.compressingStream readDataOfLength:length]];
        
        if (self.compressingStream)
        {
            _code = [self.compressingStream streamCode];
            
            if (_code != AHServerCode_OK)
            {
                return nil;
            }
        }
        
        if (self.compressingStream && [self.compressingStream isOver])
        {
            self.compressingStream = nil;
            
            [self.transferringStream finishStream];
        }
        
        [_buffer appendData:[self.transferringStream readDataOfLength:length]];
        
        if (self.transferringStream && [self.transferringStream isOver])
        {
            self.transferringStream = nil;
        }
    }
    
    NSData *data = nil;
    
    if ([_buffer length] > length)
    {
        data = [_buffer subdataWithRange:NSMakeRange(0, length)];
        
        [_buffer replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
    }
    else
    {
        data = [NSData dataWithData:_buffer];
        
        [_buffer setLength:0];
    }
    
    _over = !self.bodyDataStream && !self.transferringStream && !self.compressingStream && ![_buffer length];
    
    return [data length] ? data : nil;
}

- (unsigned long long)readRawDataSize
{
    return _rawDataReadSize;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end
