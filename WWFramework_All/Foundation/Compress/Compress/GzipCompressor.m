//
//  HTTPGzipCompressor.m
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "GzipCompressor.h"
#import <zlib.h>

@interface GzipCompressor ()
{
    // zlib流
    z_stream _stream;
}

@end


@implementation GzipCompressor

- (id)initWithCompressLevel:(GzipCompressLevel)level
{
    if (self = [super init])
    {
        _compressLevel = level;
    }
    
    return self;
}

- (void)dealloc
{
    deflateEnd(&_stream);
}

- (BOOL)start
{
    _stream.zalloc = Z_NULL;
    
    _stream.zfree = Z_NULL;
    
    _stream.opaque = Z_NULL;
    
    return (deflateInit2(&_stream, _compressLevel, Z_DEFLATED, MAX_WBITS + 16, 8, Z_DEFAULT_STRATEGY) == Z_OK);
}

- (void)stop
{
    [_inputData setLength:0];
    
    [_outputData setLength:0];
    
    deflateEnd(&_stream);
}

- (BOOL)runWithEnd:(BOOL)end
{
    BOOL success = NO;
    
    _stream.avail_in = (uInt)[_inputData length];
    
    _stream.next_in = (unsigned char *)[_inputData bytes];
    
    NSUInteger outputSize = deflateBound(&_stream, [_inputData length]);
    
    unsigned char *output = malloc(sizeof(unsigned char) * outputSize);
    
    int flush = end ? Z_FINISH : Z_NO_FLUSH;
    
    int ret;
    
    do {
        
        _stream.avail_out = (uInt)outputSize;
        
        _stream.next_out = output;
        
        ret = deflate(&_stream, flush);
        
        NSInteger have = outputSize - _stream.avail_out;
        
        if (have > 0)
        {
            [_outputData appendBytes:output length:have];
        }
        
    } while (_stream.avail_out == 0);
    
    free(output);
    
    [_inputData setLength:0];
    
    success = (flush == Z_NO_FLUSH) ? YES : (ret == Z_STREAM_END);
    
    return success;
}

@end
