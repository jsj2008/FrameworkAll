//
//  AHServerRequestBodyDecompressingStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyDecompressingStream.h"
#import "DeflateDecompressor.h"
#import "GzipDecompressor.h"

@implementation AHMessageBodyDecompressingStream

- (void)dealloc
{
    [_decompressor stop];
}

- (id)init
{
    if (self = [super init])
    {
        _code = AHMessageStreamCode_Success;
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHMessageStreamCode_Success))
    {
        return;
    }
    
    [_decompressor addData:data];
    
    if (![_decompressor run])
    {
        _code = AHMessageStreamCode_DecompressError;
    }
}

- (NSData *)output
{
    return [_decompressor outputData];
}

- (void)cleanOutput
{
    [_decompressor cleanOutput];
}

- (AHMessageStreamCode)streamCode
{
    return _code;
}

@end


@implementation AHMessageBodyIdentityDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[GeneralDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHMessageStreamCode_DecompressError;
        }
    }
    
    return self;
}

@end


@implementation AHMessageBodyDeflateDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[DeflateDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHMessageStreamCode_DecompressError;
        }
    }
    
    return self;
}

@end


@implementation AHMessageBodyGzipDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[GzipDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHMessageStreamCode_DecompressError;
        }
    }
    
    return self;
}

@end
