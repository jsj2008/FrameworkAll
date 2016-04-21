//
//  AHMessageBodyTrailerInputStream.h
//  Application
//
//  Created by WW on 14-4-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferInputStream.h"

@interface AHMessageBodyTrailerSerializingStream : BufferInputStream

- (id)initWithTrailer:(NSDictionary *)trailer;

- (NSData *)readAllData;

@end
