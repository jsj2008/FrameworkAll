//
//  AHMessageHeaderSerializingStream.h
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"
#import "AHMessageHeader.h"

@interface AHMessageHeaderSerializingStream : BufferInputStream

- (id)initWithRequestMessageHeader:(AHRequestMessageHeader *)header;

- (id)initWithResponseMessageHeader:(AHResponseMessageHeader *)header;

- (NSData *)readAllData;

@end
