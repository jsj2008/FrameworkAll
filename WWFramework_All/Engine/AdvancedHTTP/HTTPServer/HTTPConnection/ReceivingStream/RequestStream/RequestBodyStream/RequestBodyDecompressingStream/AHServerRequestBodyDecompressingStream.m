//
//  AHServerRequestBodyDecompressingStream.m
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerRequestBodyDecompressingStream.h"
#import "DeflateDecompressor.h"
#import "GzipDecompressor.h"

@implementation AHServerRequestBodyDecompressingStream

- (void)dealloc
{
    [_decompressor stop];
}

- (id)init
{
    if (self = [super init])
    {
        _code = AHServerCode_OK;
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (![data length] || (_code != AHServerCode_OK))
    {
        return;
    }
    
    [_decompressor addData:data];
    
    if (![_decompressor run])
    {
        _code = AHServerCode_Request_DecompressError;
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

- (AHServerCode)streamCode
{
    return _code;
}

@end


@implementation AHServerRequestBodyIdentityDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[GeneralDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHServerCode_Request_DecompressError;
        }
    }
    
    return self;
}

@end


@implementation AHServerRequestBodyDeflateDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[DeflateDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHServerCode_Request_DecompressError;
        }
    }
    
    return self;
}

@end


@implementation AHServerRequestBodyGzipDecompressingStream

- (id)init
{
    if (self = [super init])
    {
        _decompressor = [[GzipDecompressor alloc] init];
        
        if (![_decompressor start])
        {
            _decompressor = nil;
            
            _code = AHServerCode_Request_DecompressError;
        }
    }
    
    return self;
}

@end
