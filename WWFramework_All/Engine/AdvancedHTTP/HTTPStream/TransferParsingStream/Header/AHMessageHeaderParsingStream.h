//
//  AHHeaderOutputStream.h
//  Application
//
//  Created by WW on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHMessageHeader.h"
#import "AHMessageStreamCode.h"

@interface AHMessageHeaderParsingStream : OverFlowableOutputStream <AHMessageStreamCoding>
{
    AHMessageStreamCode _code;
    
    NSUInteger _headerSize;
}

- (AHMessageHeader *)header;

@end


extern NSUInteger const AHMessageHeaderParsingStreamMaxRecognizedHeaderSize;
