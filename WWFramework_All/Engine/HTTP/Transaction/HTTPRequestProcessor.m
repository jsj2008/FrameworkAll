//
//  HTTPRequestProcessor.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPRequestProcessor.h"
#import "GeneralCompressor.h"
#import "DeflateCompressor.h"
#import "GzipCompressor.h"
#import "DataInputStream.h"

@interface HTTPRequestProcessor ()
{
    HTTPRequest *_request;
}

@property (nonatomic) NSOutputStream *outputStream;

@property (nonatomic) GeneralCompressor *compressor;

@end


@implementation HTTPRequestProcessor

- (void)dealloc
{
    [self.outputStream close];
    
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.compressor stop];
}

- (id)initWithRequest:(HTTPRequest *)request
{
    if (self = [super init])
    {
        _request = request;
    }
    
    return self;
}

- (NSURLRequest *)URLRequest
{
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:_request.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_request.timeout];
    
    URLRequest.HTTPMethod = _request.method;
    
    URLRequest.allHTTPHeaderFields = _request.headerFields;
    
    if (_request.bodyStream)
    {
        NSString *contentEncoding = [_request.headerFields objectForKey:@"Content-Encoding"];
        
        if ([[contentEncoding lowercaseString] isEqualToString:@"deflate"])
        {
            self.compressor = [[DeflateCompressor alloc] initWithCompressLevel:DeflateCompressLevel_Default];
        }
        else if ([[contentEncoding lowercaseString] isEqualToString:@"gzip"])
        {
            self.compressor = [[GzipCompressor alloc] initWithCompressLevel:GzipCompressLevel_Default];
        }
        else
        {
            self.compressor = [[GeneralCompressor alloc] init];
        }
        
        [self.compressor start];
        
        if ([_request.bodyStream isKindOfClass:[DataInputStream class]])
        {
            NSData *data = [((DataInputStream *)(_request.bodyStream)) readAllData];
            
            [self.compressor addData:data];
            
            if ([self.compressor runWithEnd:YES])
            {
                [URLRequest setHTTPBody:[NSData dataWithData:[self.compressor outputData]]];
                
                [self.compressor cleanOutput];
            }
        }
        else
        {
            CFReadStreamRef readStreamCF;
            
            CFWriteStreamRef writeStreamCF;
            
            CFStreamCreateBoundPair(kCFAllocatorDefault, &readStreamCF, &writeStreamCF, 10 * 1024);
            
            NSInputStream *readStream = (__bridge NSInputStream *)readStreamCF;
            
            NSOutputStream *writeStream = (__bridge NSOutputStream *)writeStreamCF;
            
            writeStream.delegate = self;
            
            [writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            [writeStream open];
            
            self.outputStream = writeStream;
            
            [URLRequest setHTTPBodyStream:readStream];
        }
    }
    
    return URLRequest;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasSpaceAvailable:
        {
            NSMutableData *data = [NSMutableData data];
            
            while ([data length] < 10 * 1024 && ![_request.bodyStream isOver])
            {
                NSData *streamData = [_request.bodyStream readDataOfMaxLength:10 * 1024];
                
                [self.compressor addData:streamData];
                
                if ([self.compressor runWithEnd:[_request.bodyStream isOver]])
                {
                    NSData *compressedData = [self.compressor outputData];
                    
                    if ([compressedData length])
                    {
                        [data appendData:compressedData];
                    }
                    
                    [self.compressor cleanOutput];
                }
                else
                {
                    break;
                }
            }
            
            if ([data length] && [aStream isKindOfClass:[NSOutputStream class]])
            {
                [(NSOutputStream *)aStream write:[data bytes] maxLength:[data length]];
            }
            else
            {
                aStream.delegate = nil;
                
                [aStream close];
                
                [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            }
            
            break;
        }
            
        case NSStreamEventErrorOccurred:
        {
            aStream.delegate = nil;
            
            [aStream close];
            
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
        }
            
        default:
            break;
    }
}

@end
