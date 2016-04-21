//
//  HTTPMultipartFragmentEntityOutputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-20.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartFragmentEntityOutputStream.h"
#import "HTTPHeaderFields.h"
#import "HTTPMultipartBodyOutputStream.h"
#import "BufferOutputStream.h"
#import "DataOutputStream.h"
#import "FileOutputStream.h"

#pragma mark - HTTPMultipartFragmentEntityOutputStream

@interface HTTPMultipartFragmentEntityOutputStream ()

/*!
 * @brief 内部首部流
 */
@property (nonatomic) HTTPMultipartFragmentHeaderFieldOutputStream *headerFieldStream;

/*!
 * @brief 内部内容流
 */
@property (nonatomic) HTTPMultipartFragmentContentOutputStream *dataStream;

@end


@implementation HTTPMultipartFragmentEntityOutputStream

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        if (!self.headerFieldStream)
        {
            self.headerFieldStream = [[HTTPMultipartFragmentHeaderFieldOutputStream alloc] init];
        }
        
        if (![self.headerFieldStream isOverFlowed])
        {
            self.headerFieldStream.maxHeaderFieldStreamSize = self.configurationContext.maxFragmentHeaderFieldsSize;
            
            [self.headerFieldStream writeData:data];
            
            if ([self.headerFieldStream isOverFlowed])
            {
                HTTPHeaderFields *headerFields = [[HTTPHeaderFields alloc] initWithHeaderFieldsDictionary:[self.headerFieldStream allHeaderFields]];
                
                if ([headerFields isMultipartedContentType])
                {
                    NSString *boundary = [headerFields multipartBoundary];
                    
                    self.dataStream = [[HTTPMultipartFragmentMultipartedContentOutputStream alloc] initWithBoundary:boundary];
                }
                else
                {
                    self.dataStream = [[HTTPMultipartFragmentContentOutputStream alloc] init];
                }
                
                self.dataStream.configurationContext = self.configurationContext;
                
                NSData *overFlowedData = [self.headerFieldStream overFlowedData];
                
                if ([overFlowedData length])
                {
                    [self.dataStream writeData:overFlowedData];
                }
                
                [self.headerFieldStream cleanOverFlowedData];
            }
        }
        else
        {
            [self.dataStream writeData:data];
        }
    }
}

- (HTTPMultipartFragment *)fragment
{
    HTTPMultipartFragment *fragment = nil;
    
    HTTPMultipartFragmentContentOutput *output = [self.dataStream output];
    
    if ([output isKindOfClass:[HTTPMultipartFragmentDataContentOutput class]])
    {
        fragment = [[HTTPMultipartDataFragment alloc] initWithData:((HTTPMultipartFragmentDataContentOutput *)output).data];
    }
    else if ([output isKindOfClass:[HTTPMultipartFragmentFileContentOutput class]])
    {
        fragment = [[HTTPMultipartFileFragment alloc] initWithFilePath:((HTTPMultipartFragmentFileContentOutput *)output).filePath];
    }
    else if ([output isKindOfClass:[HTTPMultipartFragmentMultipartedContentOutput class]])
    {
        fragment = [[HTTPMultipartBodyFragment alloc] initWithMultipartBody:((HTTPMultipartFragmentMultipartedContentOutput *)output).multipartBody];
    }
    
    NSDictionary *headerFields = [self.headerFieldStream allHeaderFields];
    
    fragment.headerFields = headerFields;
    
    return fragment;
}

@end


#pragma mark - HTTPMultipartFragmentHeaderFieldOutputStream

@interface HTTPMultipartFragmentHeaderFieldOutputStream ()
{
    // 首部结束符
    NSData *_headerDelimiterData;
}

/*!
 * @brief 首部数据
 */
@property (nonatomic, retain) NSMutableDictionary *headerFields;

@end


@implementation HTTPMultipartFragmentHeaderFieldOutputStream

- (id)init
{
    if (self = [super init])
    {
        _headerDelimiterData = [@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        [_buffer appendData:data];
        
        if (!_isOverFlowed)
        {
            if ([_buffer length] > self.maxHeaderFieldStreamSize)
            {
                [_buffer setLength:self.maxHeaderFieldStreamSize];
            }
            
            NSRange range = [_buffer rangeOfData:_headerDelimiterData options:0 range:NSMakeRange(0, [_buffer length])];
            
            if (range.location != NSNotFound)
            {
                self.headerFields = [NSMutableDictionary dictionary];
                
                NSData *headerFieldsData = [_buffer subdataWithRange:NSMakeRange(0, range.location)];
                
                NSString *headerFieldsString = [[NSString alloc] initWithData:headerFieldsData encoding:NSUTF8StringEncoding];
                
                NSArray *headerFieldStrings = [headerFieldsString componentsSeparatedByString:@"\r\n"];
                
                for (NSString *headerFieldString in headerFieldStrings)
                {
                    if ([headerFieldString length])
                    {
                        NSRange separateRange = [headerFieldString rangeOfString:@":"];
                        
                        if (separateRange.location != NSNotFound)
                        {
                            NSString *key = [headerFieldString substringToIndex:separateRange.location];
                            
                            NSString *value = [headerFieldString substringFromIndex:separateRange.location + 1];
                            
                            if ([key length] && [value length])
                            {
                                [self.headerFields setObject:value forKey:key];
                            }
                        }
                    }
                }
                
                [_buffer replaceBytesInRange:NSMakeRange(0, range.location + range.length) withBytes:NULL length:0];
                
                _isOverFlowed = YES;
            }
        }
    }
}

- (NSDictionary<NSString *,NSString *> *)allHeaderFields
{
    return [self.headerFields count] ? self.headerFields : nil;
}

@end


#pragma mark - HTTPMultipartFragmentContentOutputStream

@implementation HTTPMultipartFragmentContentOutputStream

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        if (!self.outputStream)
        {
            self.outputStream = [[DataOutputStream alloc] init];
        }
        
        [self.outputStream writeData:data];
        
        if ([self.outputStream isKindOfClass:[DataOutputStream class]])
        {
            NSUInteger bufferSize = [(DataOutputStream *)self.outputStream dataSize];
            
            if (bufferSize > self.configurationContext.fragmentSizeLimitToFile)
            {
                NSString *filePath = [self.configurationContext validFilePathForSaving];
                
                NSFileManager *fm = [[NSFileManager alloc] init];
                
                [fm removeItemAtPath:filePath error:nil];
                
                FileOutputStream *stream = [[FileOutputStream alloc] initWithFilePath:filePath];
                
                [stream writeData:[(DataOutputStream *)self.outputStream data]];
                
                self.outputStream = stream;
            }
        }
    }
}

- (HTTPMultipartFragmentContentOutput *)output
{
    HTTPMultipartFragmentContentOutput *output = nil;
    
    if ([self.outputStream isKindOfClass:[DataOutputStream class]])
    {
        HTTPMultipartFragmentDataContentOutput *dataOutput = [[HTTPMultipartFragmentDataContentOutput alloc] init];
        
        dataOutput.data = [(DataOutputStream *)self.outputStream data];
        
        output = dataOutput;
    }
    else if ([self.outputStream isKindOfClass:[FileOutputStream class]])
    {
        HTTPMultipartFragmentFileContentOutput *fileOutput = [[HTTPMultipartFragmentFileContentOutput alloc] init];
        
        fileOutput.filePath = ((FileOutputStream *)self.outputStream).filePath;
        
        output = fileOutput;
    }
    
    return output;
}

@end


@interface HTTPMultipartFragmentMultipartedContentOutputStream ()
{
    // 分隔符
    NSString *_boundary;
}

@end


@implementation HTTPMultipartFragmentMultipartedContentOutputStream

- (id)initWithBoundary:(NSString *)boundary
{
    if (self = [super init])
    {
        _boundary = [boundary copy];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        if (!self.outputStream)
        {
            HTTPMultipartBodyOutputStream *bodyOutputStream = [[HTTPMultipartBodyOutputStream alloc] initWithBoundary:_boundary];
            
            bodyOutputStream.configurationContext = self.configurationContext;
            
            self.outputStream = bodyOutputStream;
        }
        
        [self.outputStream writeData:data];
    }
}

- (HTTPMultipartFragmentContentOutput *)output
{
    HTTPMultipartFragmentMultipartedContentOutput *multipartOutput = [[HTTPMultipartFragmentMultipartedContentOutput alloc] init];
    
    multipartOutput.multipartBody = [(HTTPMultipartBodyOutputStream *)self.outputStream multipartBody];
    
    return multipartOutput;
}

@end


#pragma mark - HTTPMultipartFragmentContentOutput

@implementation HTTPMultipartFragmentContentOutput

@end


@implementation HTTPMultipartFragmentDataContentOutput

@end


@implementation HTTPMultipartFragmentFileContentOutput

@end


@implementation HTTPMultipartFragmentMultipartedContentOutput

@end
