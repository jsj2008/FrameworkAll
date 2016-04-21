//
//  HTTPMultipartBody.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-16.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartBody.h"
#import "DataInputStream.h"
#import "FileInputStream.h"
#import "GroupedInputStream.h"

#pragma mark - HTTPMultipartBody

@implementation HTTPMultipartBody

@synthesize boundary = _boundary;
@synthesize fragments = _fragments;

- (id)initWithBoundary:(NSString *)boundary fragments:(NSArray<HTTPMultipartFragment *> *)fragments
{
    if (self = [super init])
    {
        _boundary = [boundary copy];
        
        _fragments = fragments;
    }
    
    return self;
}

- (NSData *)serializedData
{
    if (![_fragments count])
    {
        return nil;
    }
    
    NSMutableData *data = [NSMutableData data];
    
    NSData *headData = [[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *separateData = [[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *endData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    [data appendData:headData];
    
    NSUInteger count = [_fragments count];
    
    for (int i = 0; i < count; i ++)
    {
        HTTPMultipartFragment *fragment = [_fragments objectAtIndex:i];
        
        NSDictionary *headerFields = fragment.headerFields;
        
        // 按照规范，每个表单片段都必须含有Content-Disposition首部
        if ([headerFields count] == 0)
        {
            headerFields = [NSDictionary dictionaryWithObject:@"" forKey:@"Content-Disposition"];
        }
        
        NSMutableString *headerFieldString = [NSMutableString string];
        
        for (NSString *key in [headerFields allKeys])
        {
            NSString *value = [headerFields objectForKey:key];
            
            [headerFieldString appendFormat:@"%@:%@\r\n", key, value];
        }
        
        if ([headerFieldString length])
        {
            [data appendData:[headerFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [data appendData:[fragment data]];
        
        if (i < (count - 1))
        {
            [data appendData:separateData];
        }
        else
        {
            [data appendData:endData];
        }
    }
    
    return data;
}

- (GroupedInputStream *)stream
{
    if (![_fragments count])
    {
        return nil;
    }
    
    NSMutableArray *group = [NSMutableArray array];
    
    [group addObject:[[DataInputStream alloc] initWithData:[[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]]];
    
    NSUInteger count = [_fragments count];
    
    for (int i = 0; i < count; i ++)
    {
        HTTPMultipartFragment *fragment = [_fragments objectAtIndex:i];
        
        NSDictionary *headerFields = fragment.headerFields;
        
        // 按照规范，每个表单片段都必须含有Content-Disposition首部
        if ([headerFields count] == 0)
        {
            headerFields = [NSDictionary dictionaryWithObject:@"" forKey:@"Content-Disposition"];
        }
        
        NSMutableString *headerFieldString = [NSMutableString string];
        
        for (NSString *key in [headerFields allKeys])
        {
            NSString *value = [headerFields objectForKey:key];
            
            [headerFieldString appendFormat:@"%@:%@\r\n", key, value];
        }
        
        if ([headerFieldString length])
        {
            [headerFieldString appendString:@"\r\n"];
            
            DataInputStream *stream = [[DataInputStream alloc] initWithData:[headerFieldString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [group addObject:stream];
        }
        
        InputStream *dataStream = [fragment dataStream];
        
        if (dataStream)
        {
            [group addObject:dataStream];
        }
        
        if (i < (count - 1))
        {
            [group addObject:[[DataInputStream alloc] initWithData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]]];
        }
        else
        {
            [group addObject:[[DataInputStream alloc] initWithData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    
    return [group count] ? [[GroupedInputStream alloc] initWithStreamGroup:group] : nil;
}

@end


#pragma mark - HTTPMultipartFragment

@implementation HTTPMultipartFragment

- (NSData *)data
{
    return nil;
}

- (InputStream *)dataStream
{
    return nil;
}

@end


#pragma mark - HTTPMultipartDataFragment

@interface HTTPMultipartDataFragment ()
{
    // 字节数据
    NSData *_data;
}

@end


@implementation HTTPMultipartDataFragment

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _data = data;
    }
    
    return self;
}

- (NSData *)data
{
    return _data;
}

- (InputStream *)dataStream
{
    DataInputStream *stream = [[DataInputStream alloc] initWithData:_data];
    
    return stream;
}

@end


#pragma mark - HTTPMultipartFileFragment

@implementation HTTPMultipartFileFragment

@synthesize filePath = _filePath;

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
    }
    
    return self;
}

- (NSData *)data
{
    NSData *data = nil;
    
    if (self.endLocation)
    {
        if (self.startLocation < self.endLocation)
        {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
            
            [fileHandle seekToFileOffset:self.startLocation];
            
            data = [fileHandle readDataOfLength:(self.endLocation - self.startLocation)];
        }
    }
    else
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        
        [fileHandle seekToFileOffset:self.startLocation];
        
        data = [fileHandle readDataToEndOfFile];
    }
    
    return [data length] ? data : nil;
}

- (InputStream *)dataStream
{
    FileInputStream *stream = [[FileInputStream alloc] initWithFilePath:_filePath];
    
    stream.startLocation = self.startLocation;
    
    stream.endLocation = self.endLocation;
    
    return stream;
}

@end


#pragma mark - HTTPMultipartBodyFragment

@implementation HTTPMultipartBodyFragment

@synthesize multipartBody = _multipartBody;

- (id)initWithMultipartBody:(HTTPMultipartBody *)multipartBody
{
    if (self = [super init])
    {
        _multipartBody = multipartBody;
    }
    
    return self;
}

- (NSData *)data
{
    return [_multipartBody serializedData];
}

- (InputStream *)dataStream
{
    return [_multipartBody stream];
}

@end
