//
//  HTTPCompressor.m
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "GeneralCompressor.h"

@implementation GeneralCompressor

- (id)init
{
    if (self = [super init])
    {
        _inputData = [[NSMutableData alloc] init];
        
        _outputData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (BOOL)start
{
    return YES;
}

- (void)stop
{
    [_inputData setLength:0];
    
    [_outputData setLength:0];
}

- (void)addData:(NSData *)data
{
    if (data && [data length])
    {
        [_inputData appendData:data];
    }
}

- (BOOL)runWithEnd:(BOOL)end
{
    [_outputData appendData:_inputData];
    
    [_inputData setLength:0];
    
    return YES;
}

- (NSData *)outputData
{
    return _outputData;
}

- (void)cleanOutput
{
    [_outputData setLength:0];
}

@end
