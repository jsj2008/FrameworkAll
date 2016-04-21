//
//  AHMessageInputStream.h
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"
#import "AHMessageHeader.h"

@interface AHMessageTransferSerializingStream : BufferInputStream

- (void)addMessageHeader:(AHMessageHeader *)header;

- (void)addMessageBodyData:(NSData *)data;

- (void)addMessageBodyTrailer:(NSDictionary *)trailer;

- (void)addMessageEnd;

@end
