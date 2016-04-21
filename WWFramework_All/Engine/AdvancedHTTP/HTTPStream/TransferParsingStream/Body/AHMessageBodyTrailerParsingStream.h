//
//  AHTrailerOutputStream.h
//  Application
//
//  Created by WW on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHMessageStreamCode.h"

@interface AHMessageBodyTrailerParsingStream : OverFlowableOutputStream <AHMessageStreamCoding>

- (NSDictionary *)trailer;

@end


extern NSUInteger const AHMessageBodyTrailerParsingStreamMaxRecognizedTrailerSize;
