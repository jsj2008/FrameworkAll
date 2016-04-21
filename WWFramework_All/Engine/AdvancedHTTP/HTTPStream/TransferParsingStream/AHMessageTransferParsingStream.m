//
//  AHHTTPDataOutputStream.m
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHMessageTransferParsingStream.h"
#import "AHRequestMessageHeaderParsingStream.h"
#import "AHResponseMessageHeaderParsingStream.h"
#import "AHMessageBodyParsingStream.h"

@interface AHMessageTransferParsingStream ()
{
    NSMutableArray *_outputs;
    
    AHMessageStreamCode _code;
    
    BOOL _isRequestType;
}

@property (nonatomic) AHMessageHeaderParsingStream *headerStream;

@property (nonatomic) AHMessageBodyParsingStream *bodyStream;

@end


@implementation AHMessageTransferParsingStream

- (id)initWithRequestOrResponseType:(BOOL)requestType
{
    if (self = [super init])
    {
        _outputs = [[NSMutableArray alloc] init];
        
        _isRequestType = requestType;
    }
    
    return self;
}

- (NSArray *)outputs
{
    return _outputs;
}

- (void)cleanOutputs
{
    [_outputs removeAllObjects];
}

- (AHMessageTransferParsingStreamOutput *)firstOutputByRemovingItFromOutupts
{
    AHMessageTransferParsingStreamOutput *output = nil;
    
    if ([_outputs count])
    {
        output = [_outputs objectAtIndex:0];
        
        [_outputs removeObjectAtIndex:0];
    }
    
    return output;
}

- (void)writeData:(NSData *)data
{
    if (_code != AHMessageStreamCode_Success)
    {
        return;
    }
    
    [_buffer appendData:data];
    
    while (!_isOverFlowed && [_buffer length])
    {
        if (self.headerStream)
        {
            [self.headerStream writeData:_buffer];
            
            [_buffer setLength:0];
            
            _code = [self.headerStream AHMessageStreamCode];
            
            if (_code != AHMessageStreamCode_Success)
            {
                return;
            }
            
            if ([self.headerStream isOverFlowed])
            {
                AHMessageHeader *header = [self.headerStream header];
                
                if (header)
                {
                    AHMessageTransferParsingStreamHeaderOutput *output = [[AHMessageTransferParsingStreamHeaderOutput alloc] init];
                    
                    output.header = header;
                    
                    [_outputs addObject:output];
                }
                
                [_buffer appendData:[self.headerStream overFlowedData]];
                
                self.headerStream = nil;
                
                if ([[[header.headerFields objectForKey:@"Transfer-Encoding"] lowercaseString] isEqualToString:@"chunked"])
                {
                    self.bodyStream = [[AHMessageChunkedBodyParsingStream alloc] init];
                }
                else if ([header.headerFields objectForKey:@"Content-Length"])
                {
                    unsigned long long contentLength = [(NSString *)[header.headerFields objectForKey:@"Content-Length"] longLongValue];
                    
                    self.bodyStream = [[AHMessageFixedLengthBodyParsingStream alloc] initWithFixedLength:contentLength];
                }
                else
                {
                    _code = AHMessageStreamCode_UnknownLength;
                    
                    return;
                }
            }
        }
        else if (self.bodyStream)
        {
            [self.bodyStream writeData:_buffer];
            
            [_buffer setLength:0];
            
            _code = [self.bodyStream AHMessageStreamCode];
            
            if (_code != AHMessageStreamCode_Success)
            {
                return;
            }
            
            NSArray *bodyOutputs = [self.bodyStream outputs];
            
            for (AHMessageBodyParsingStreamOutput *bodyOutput in bodyOutputs)
            {
                if ([bodyOutput isKindOfClass:[AHMessageBodyParsingStreamDataOutput class]])
                {
                    AHMessageTransferParsingStreamBodyDataOutput *output = [[AHMessageTransferParsingStreamBodyDataOutput alloc] init];
                    
                    output.data = ((AHMessageBodyParsingStreamDataOutput *)bodyOutput).data;
                    
                    [_outputs addObject:output];
                }
                else if ([bodyOutput isKindOfClass:[AHMessageBodyParsingStreamTrailerOutput class]])
                {
                    AHMessageTransferParsingStreamBodyTrailerOutput *output = [[AHMessageTransferParsingStreamBodyTrailerOutput alloc] init];
                    
                    output.trailer = ((AHMessageBodyParsingStreamTrailerOutput *)bodyOutput).trailer;
                    
                    [_outputs addObject:output];
                }
            }
            
            [self.bodyStream cleanOutputs];
            
            if ([self.bodyStream isOverFlowed])
            {
                [_buffer appendData:[self.bodyStream overFlowedData]];
                
                AHMessageTransferParsingStreamFinishingOutput *output = [[AHMessageTransferParsingStreamFinishingOutput alloc] init];
                
                [_outputs addObject:output];
                
                self.bodyStream = nil;
            }
        }
        else
        {
            if (_isRequestType)
            {
                self.headerStream = [[AHRequestMessageHeaderParsingStream alloc] init];
            }
            else
            {
                self.headerStream = [[AHResponseMessageHeaderParsingStream alloc] init];
            }
        }
    }
}

- (AHMessageStreamCode)AHMessageStreamCode
{
    return _code;
}

@end
