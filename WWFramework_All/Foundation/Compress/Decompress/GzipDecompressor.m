//
//  HTTPGzipDecompressor.m
//  HTTPServer
//
//  Created by Baymax on 13-8-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "GzipDecompressor.h"
#import <zlib.h>

@interface GzipDecompressor ()
{
    // zlib流
    z_stream _stream;
    
    // gzip头
    char dummy_head[2];
}

@end


@implementation GzipDecompressor

- (void)dealloc
{
    inflateEnd(&_stream);
}

- (BOOL)start
{
    _stream.zalloc = Z_NULL;
    
    _stream.zfree = Z_NULL;
    
    _stream.opaque = Z_NULL;
    
    _stream.avail_in = 0;
    
    _stream.next_in = Z_NULL;
    
    dummy_head[0] = 0x8 + 0x7 * 0x10;
    
    dummy_head[1] = (((0x8 + 0x7 * 0x10) * 0x100 + 30) / 31 * 31) & 0xFF;
    
    return (inflateInit2(&_stream, MAX_WBITS + 16) == Z_OK);
}

- (void)stop
{
    inflateEnd(&_stream);
}

- (BOOL)run
{
    BOOL success = NO;
    
    unsigned char *input = (unsigned char *)[_inputData bytes];
    
    unsigned char output[1024];
    
    _stream.avail_in = (uInt)[_inputData length];
    
    _stream.next_in = input;
    
    int ret;
    
    int have;
    
    do {
        
        _stream.avail_out = 1024;
        
        _stream.next_out = output;
        
        ret = inflate(&_stream, Z_NO_FLUSH);
        
        if (ret == Z_OK || ret == Z_STREAM_END)
        {
            have = 1024 - _stream.avail_out;
            
            if (have)
            {
                [_outputData appendBytes:output length:have];
            }
        }
        else if (ret == Z_DATA_ERROR)
        {
            _stream.avail_in = sizeof(dummy_head);
            
            _stream.next_in = (Bytef *)dummy_head;
            
            ret = inflate(&_stream, Z_NO_FLUSH);
            
            if (ret != Z_OK)
            {
                break;
            }
            else
            {
                _stream.avail_in = (uInt)[_inputData length];
                
                _stream.next_in = input;
            }
        }
        else
        {
            break;
        }
        
    } while (_stream.avail_out == 0);
    
    [_inputData setLength:0];
    
    success = (ret == Z_OK || ret == Z_STREAM_END);
    
    _over = (ret == Z_STREAM_END);
    
    return success;
}

@end
