//
//  AHServerResponseBodyCompressingStream.m
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerResponseBodyCompressingStream.h"
#import "DeflateCompressor.h"
#import "GzipCompressor.h"

@implementation AHServerResponseBodyCompressingStream

- (void)dealloc
{
    [_compressor stop];
}

- (id)init
{
    if (self = [super init])
    {
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)addInputData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    [_compressor addData:data];
}

- (NSData *)readDataOfLength:(NSUInteger)length
{
    if (![_compressor runWithEnd:_toBeFinished])
    {
        _code = AHServerCode_Response_CompressError;
        
        return nil;
    }
    
    NSData *data = [NSData dataWithData:[_compressor outputData]];
    
    [_compressor cleanOutput];
    
    _over = _toBeFinished;
    
    return data;
}

- (void)finishStream
{
    _toBeFinished = YES;
}

- (BOOL)isOver
{
    return _over;
}

- (AHServerCode)streamCode
{
    return _code;
}

@end


@implementation AHServerResponseBodyIdentityCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[GeneralCompressor alloc] init];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHServerCode_Response_CompressError;
        }
    }
    
    return self;
}

@end


@implementation AHServerResponseBodyDeflateCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[DeflateCompressor alloc] initWithCompressLevel:DeflateCompressLevel_Default];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHServerCode_Response_CompressError;
        }
    }
    
    return self;
}

@end


@implementation AHServerResponseBodyGzipCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[GzipCompressor alloc] initWithCompressLevel:GzipCompressLevel_Default];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHServerCode_Response_CompressError;
        }
    }
    
    return self;
}

@end
