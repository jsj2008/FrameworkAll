//
//  AHMessageBodyInputStream.h
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"

@interface AHMessageBodySerializingStream : BufferInputStream

- (void)addMessageBodyData:(NSData *)data;

- (void)addMessageBodyTrailer:(NSDictionary *)trailer;

- (void)finish;

- (NSData *)readAllData;

@end


@interface AHMessageFixedLengthBodySerializingStream : AHMessageBodySerializingStream

@end


@interface AHMessageChunkedBodySerializingStream : AHMessageBodySerializingStream

@end
