//
//  AHMessageInputStream.m
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageTransferSerializingStream.h"
#import "AHMessageHeaderSerializingStream.h"
#import "AHMessageBodySerializingStream.h"

@interface AHMessageTransferSerializingStream ()

/*!
 * @brief 头输入流，负责头数据的转换
 */
@property (nonatomic) AHMessageHeaderSerializingStream *headerStream;

/*!
 * @brief body输入流，负责body数据的转换
 */
@property (nonatomic) AHMessageBodySerializingStream *bodyStream;

@end


@implementation AHMessageTransferSerializingStream

- (void)addMessageHeader:(AHMessageHeader *)header
{
    if (!self.headerStream)
    {
        if ([header isKindOfClass:[AHRequestMessageHeader class]])
        {
            self.headerStream = [[AHMessageHeaderSerializingStream alloc] initWithRequestMessageHeader:(AHRequestMessageHeader *)header];
        }
        else if ([header isKindOfClass:[AHResponseMessageHeader class]])
        {
            self.headerStream = [[AHMessageHeaderSerializingStream alloc] initWithResponseMessageHeader:(AHResponseMessageHeader *)header];
        }
        
        if ([[[header.headerFields objectForKey:@"Transfer-Encoding"] lowercaseString] isEqualToString:@"chunked"])
        {
            self.bodyStream = [[AHMessageChunkedBodySerializingStream alloc] init];
        }
        else
        {
            self.bodyStream = [[AHMessageFixedLengthBodySerializingStream alloc] init];
        }
    }
    
    [_buffer appendData:[self.headerStream readAllData]];
    
    self.headerStream = nil;
}

- (void)addMessageBodyData:(NSData *)data
{
    [self.bodyStream addMessageBodyData:data];
    
    [_buffer appendData:[self.bodyStream readAllData]];
}

- (void)addMessageBodyTrailer:(NSDictionary *)trailer
{
    [self.bodyStream addMessageBodyTrailer:trailer];
    
    [_buffer appendData:[self.bodyStream readAllData]];
}

- (void)addMessageEnd
{
    [self.bodyStream finish];
    
    [_buffer appendData:[self.bodyStream readAllData]];
    
    self.headerStream = nil;
    
    self.bodyStream = nil;
}

@end
