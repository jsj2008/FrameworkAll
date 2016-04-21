//
//  HTTPHeaderFields.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-21.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPHeaderFields.h"
#import "DateFormat.h"

@interface HTTPHeaderFields ()

/*!
 * @brief 内部首部字典
 */
@property (nonatomic) NSMutableDictionary *headerFields;

@end


@implementation HTTPHeaderFields

- (id)initWithHeaderFieldsDictionary:(NSDictionary<NSString *,NSString *> *)dictionary
{
    if (self = [super init])
    {
        self.headerFields = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    
    return self;
}

- (NSDictionary<NSString *,NSString *> *)allHeaderFields
{
    return self.headerFields;
}

- (id)initWithHTTPResponse:(NSHTTPURLResponse *)response
{
    if (self = [super init])
    {
        self.headerFields = [NSMutableDictionary dictionaryWithDictionary:[response allHeaderFields]];
    }
    
    return self;
}

- (NSDate *)date
{
    NSDate *date = nil;
    
    NSString *dateString = [self.headerFields objectForKey:@"Date"];
    
    if ([dateString length])
    {
        date = [NSDate dateWithFormatString:dateString byType:DateFormatType_HTTPHeaderDate];
    }
    
    return date;
}

- (void)setDate:(NSDate *)date
{
    if (date)
    {
        NSString *dateString = [date formatStringByType:DateFormatType_HTTPHeaderDate];
        
        if (dateString)
        {
            [self.headerFields setObject:dateString forKey:@"Date"];
        }
    }
}

- (BOOL)isChunkedTransferring
{
    NSString *value = [self.headerFields objectForKey:@"Transfer-Encoding"];
    
    return [[value lowercaseString] isEqualToString:@"chunked"];
}

- (NSString *)contentType
{
    return [self.headerFields objectForKey:@"Content-Type"];
}

- (void)setContentType:(NSString *)contentType
{
    if (contentType)
    {
        [self.headerFields setObject:contentType forKey:@"Content-Type"];
    }
}

- (unsigned long long)contentLength
{
    NSString *value = nil;
    
    NSString *contentEncoding = [self.headerFields objectForKey:@"Content-Encoding"];
    
    if (!contentEncoding || [contentEncoding isEqualToString:@"identity"])
    {
        value = [self.headerFields objectForKey:@"Content-Length"];
    }
    
    return [value longLongValue];
}

- (NSString *)contentDisposition
{
    return [self.headerFields objectForKey:@"Content-Disposition"];
}

- (void)setContentDisposition:(NSString *)contentDisposition
{
    if (contentDisposition)
    {
        [self.headerFields setObject:contentDisposition forKey:@"Content-Disposition"];
    }
}

- (BOOL)isMultipartedContentType
{
    NSString *contentType = [[self.headerFields objectForKey:@"Content-Type"] lowercaseString];
    
    return contentType && ([contentType rangeOfString:@"multipart"].location != NSNotFound);
}

- (NSString *)multipartBoundary
{
    NSString *boundary = nil;
    
    NSString *contentType = [self.headerFields objectForKey:@"Content-Type"];
    
    if (contentType && [[contentType lowercaseString] rangeOfString:@"multipart"].location != NSNotFound)
    {
        NSArray *components = [contentType componentsSeparatedByString:@";"];
        
        for (NSString *component in components)
        {
            NSRange range = [component rangeOfString:@"boundary="];
            
            if ((range.location != NSNotFound) && (range.location + range.length < [component length] - 1))
            {
                boundary = [component substringFromIndex:(range.location + range.length)];
                
                break;
            }
        }
    }
    
    return boundary;
}

@end
