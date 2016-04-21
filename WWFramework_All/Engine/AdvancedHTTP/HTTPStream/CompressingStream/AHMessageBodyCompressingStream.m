//
//  AHServerResponseBodyCompressingStream.m
//  Application
//
//  Created by WW on 14-3-19.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyCompressingStream.h"
#import "DeflateCompressor.h"
#import "GzipCompressor.h"

@implementation AHMessageBodyCompressingStream

- (void)dealloc
{
    [_compressor stop];
}

- (id)init
{
    if (self = [super init])
    {
        _code = AHMessageStreamCode_Success;
    }
    
    return self;
}

- (void)addInputData:(NSData *)data
{
    if (![data length] || (_code != AHMessageStreamCode_Success))
    {
        return;
    }
    
    [_compressor addData:data];
}

- (NSData *)readAllData
{
    if (![_compressor runWithEnd:_toBeFinished])
    {
        _code = AHMessageStreamCode_CompressError;
        
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

- (AHMessageStreamCode)streamCode
{
    return _code;
}

@end


@implementation AHMessageBodyIdentityCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[GeneralCompressor alloc] init];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHMessageStreamCode_CompressError;
        }
    }
    
    return self;
}

@end


@implementation AHMessageBodyDeflateCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[DeflateCompressor alloc] initWithCompressLevel:DeflateCompressLevel_Default];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHMessageStreamCode_CompressError;
        }
    }
    
    return self;
}

@end


@implementation AHMessageBodyGzipCompressingStream

- (id)init
{
    if (self = [super init])
    {
        _compressor = [[GzipCompressor alloc] initWithCompressLevel:GzipCompressLevel_Default];
        
        if (![_compressor start])
        {
            _compressor = nil;
            
            _code = AHMessageStreamCode_CompressError;
        }
    }
    
    return self;
}

@end
