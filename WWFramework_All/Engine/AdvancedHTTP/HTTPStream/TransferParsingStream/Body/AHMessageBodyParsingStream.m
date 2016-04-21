//
//  AHBodyOutputStream.m
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageBodyParsingStream.h"
#import "AHMessageBodyChunkDataParsingStream.h"
#import "AHMessageBodyTrailerParsingStream.h"

@implementation AHMessageBodyParsingStream

- (id)init
{
    if (self = [super init])
    {
        _code = AHMessageStreamCode_Success;
        
        _outputs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (AHMessageStreamCode)AHMessageStreamCode
{
    return _code;
}

- (NSArray *)outputs
{
    return _outputs;
}

- (void)cleanOutputs
{
    [_outputs removeAllObjects];
}

@end


@interface AHMessageFixedLengthBodyParsingStream ()
{
    unsigned long long _length;
    
    unsigned long long _parsedLength;
}

@end


@implementation AHMessageFixedLengthBodyParsingStream

- (id)initWithFixedLength:(unsigned long long)length
{
    if (self = [super init])
    {
        _length = length;
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (_code != AHMessageStreamCode_Success)
    {
        return;
    }
    
    if (!_isOverFlowed)
    {
        unsigned long long readSize = _length - _parsedLength;
        
        NSData *parsedData = nil;
        
        if ([data length] > readSize)
        {
            parsedData = [data subdataWithRange:NSMakeRange(0, readSize)];
            
            _parsedLength += readSize;
            
            [_buffer appendData:[data subdataWithRange:NSMakeRange(readSize, [data length] - readSize)]];
        }
        else
        {
            parsedData = [NSData dataWithData:data];
            
            _parsedLength += [data length];
        }
        
        if ([parsedData length])
        {
            AHMessageBodyParsingStreamDataOutput *output = [[AHMessageBodyParsingStreamDataOutput alloc] init];
            
            output.data = parsedData;
            
            [_outputs addObject:output];
        }
        
        if (_parsedLength >= _length)
        {
            _isOverFlowed = YES;
        }
    }
}

@end


@interface AHMessageChunkedBodyParsingStream ()

@property (nonatomic) AHMessageBodyChunkDataParsingStream *chunkStream;

@property (nonatomic) AHMessageBodyTrailerParsingStream *trailerStream;

@end


@implementation AHMessageChunkedBodyParsingStream

- (id)init
{
    if (self = [super init])
    {
        self.chunkStream = [[AHMessageBodyChunkDataParsingStream alloc] init];
        
        self.trailerStream = [[AHMessageBodyTrailerParsingStream alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (_code != AHMessageStreamCode_Success)
    {
        return;
    }
    
    [_buffer appendData:data];
    
    if (!_isOverFlowed)
    {
        while ([_buffer length])
        {
            if (self.chunkStream)
            {
                [self.chunkStream writeData:_buffer];
                
                [_buffer setLength:0];
                
                if (![self.chunkStream isOK])
                {
                    _code = AHMessageStreamCode_ChunkedParsingError;
                    
                    return;
                }
                
                NSData *rawData = [self.chunkStream rawData];
                
                if ([rawData length])
                {
                    AHMessageBodyParsingStreamDataOutput *dataOutput = [[AHMessageBodyParsingStreamDataOutput alloc] init];
                    
                    dataOutput.data = rawData;
                    
                    [_outputs addObject:dataOutput];
                }
                
                [self.chunkStream cleanRawData];
                
                if ([self.chunkStream isOverFlowed])
                {
                    [_buffer appendData:[self.chunkStream overFlowedData]];
                    
                    self.chunkStream = nil;
                }
            }
            else if (self.trailerStream)
            {
                [self.trailerStream writeData:_buffer];
                
                [_buffer setLength:0];
                
                _code = [self.trailerStream AHMessageStreamCode];
                
                if (_code != AHMessageStreamCode_Success)
                {
                    return;
                }
                
                if ([self.trailerStream isOverFlowed])
                {
                    NSDictionary *trailer = [self.trailerStream trailer];
                    
                    if ([trailer count])
                    {
                        AHMessageBodyParsingStreamTrailerOutput *trailerOutput = [[AHMessageBodyParsingStreamTrailerOutput alloc] init];
                        
                        trailerOutput.trailer = trailer;
                        
                        [_outputs addObject:trailerOutput];
                    }
                    
                    [_buffer appendData:[self.trailerStream overFlowedData]];
                    
                    self.trailerStream = nil;
                    
                    _isOverFlowed = YES;
                }
            }
        }
    }
}

@end


@implementation AHMessageBodyParsingStreamOutput

@end


@implementation AHMessageBodyParsingStreamDataOutput

@end


@implementation AHMessageBodyParsingStreamTrailerOutput

@end
