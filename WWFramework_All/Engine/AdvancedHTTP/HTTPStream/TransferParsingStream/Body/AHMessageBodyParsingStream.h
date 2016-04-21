//
//  AHBodyOutputStream.h
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHMessageHeader.h"
#import "AHMessageStreamCode.h"

@class AHMessageBodyParsingStreamOutput;


@interface AHMessageBodyParsingStream : OverFlowableOutputStream <AHMessageStreamCoding>
{
    NSMutableArray *_outputs;
    
    AHMessageStreamCode _code;
}

- (NSArray *)outputs;

- (void)cleanOutputs;

@end


@interface AHMessageFixedLengthBodyParsingStream : AHMessageBodyParsingStream

- (id)initWithFixedLength:(unsigned long long)length;

@end


@interface AHMessageChunkedBodyParsingStream : AHMessageBodyParsingStream

@end


@interface AHMessageBodyParsingStreamOutput : NSObject

@end


@interface AHMessageBodyParsingStreamDataOutput : AHMessageBodyParsingStreamOutput

@property (nonatomic) NSData *data;

@end


@interface AHMessageBodyParsingStreamTrailerOutput : AHMessageBodyParsingStreamOutput

@property (nonatomic) NSDictionary *trailer;

@end
