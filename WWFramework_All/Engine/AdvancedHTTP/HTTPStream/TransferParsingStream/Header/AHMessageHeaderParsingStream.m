//
//  AHHeaderOutputStream.m
//  Application
//
//  Created by WW on 14-4-22.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageHeaderParsingStream.h"

@implementation AHMessageHeaderParsingStream

- (id)init
{
    if (self = [super init])
    {
        _code = AHMessageStreamCode_Success;
    }
    
    return self;
}

- (AHMessageHeader *)header
{
    return nil;
}

- (AHMessageStreamCode)AHMessageStreamCode
{
    return _code;
}

@end


NSUInteger const AHMessageHeaderParsingStreamMaxRecognizedHeaderSize = 256 * 1024;
