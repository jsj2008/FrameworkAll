//
//  AHMessageBodyInputStream.m
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodySerializingStream.h"
#import "AHMessageBodyChunkDataSerializingStream.h"
#import "AHMessageBodyTrailerSerializingStream.h"

@implementation AHMessageBodySerializingStream

- (void)addMessageBodyData:(NSData *)data
{
    
}

- (void)addMessageBodyTrailer:(NSDictionary *)trailer
{
    
}

- (void)finish
{
    
}

- (NSData *)readAllData
{
    NSData *data = [NSData dataWithData:_buffer];
    
    [_buffer setLength:0];
    
    _over = YES;
    
    return data;
}

@end


@implementation AHMessageFixedLengthBodySerializingStream

- (void)addMessageBodyData:(NSData *)data
{
    [_buffer appendData:data];
}

@end


@interface AHMessageChunkedBodySerializingStream()
{
    BOOL _bodyDataIsFinished;
}

- (void)finishBodyData;

@end


@implementation AHMessageChunkedBodySerializingStream

- (void)addMessageBodyData:(NSData *)data
{
    if ([data length])
    {
        AHMessageBodyChunkDataSerializingStream *chunkStream = [[AHMessageBodyChunkDataSerializingStream alloc] initWithRawData:data];
        
        [_buffer appendData:[chunkStream readAllData]];
    }
}

- (void)addMessageBodyTrailer:(NSDictionary *)trailer
{
    if (!_bodyDataIsFinished)
    {
        [self finishBodyData];
    }
    
    if ([trailer count])
    {
        AHMessageBodyTrailerSerializingStream *trailerStream = [[AHMessageBodyTrailerSerializingStream alloc] initWithTrailer:trailer];
        
        [_buffer appendData:[trailerStream readAllData]];
    }
}

- (void)finishBodyData
{
    _bodyDataIsFinished = YES;
    
    AHMessageBodyChunkDataSerializingStream *chunkStream = [[AHMessageBodyChunkDataSerializingStream alloc] initWithRawData:nil];
    
    [_buffer appendData:[chunkStream readAllData]];
}

- (void)finish
{
    if (!_bodyDataIsFinished)
    {
        [self finishBodyData];
    }
    
    [_buffer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
