//
//  HTTPResponse.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPResponse.h"
#import "DateFormat.h"
#import "DataOutputStream.h"

@implementation HTTPResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.URLResponse forKey:@"URLResponse"];
    
    if ([self.bodyStream isKindOfClass:[DataOutputStream class]])
    {
        NSData *data = [(DataOutputStream *)self.bodyStream data];
        
        if ([data length])
        {
            [aCoder encodeObject:data forKey:@"data"];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.URLResponse = [aDecoder decodeObjectForKey:@"URLResponse"];
        
        NSData *data = [aDecoder decodeObjectForKey:@"data"];
        
        if ([data length])
        {
            self.bodyStream = [[DataOutputStream alloc] init];
            
            [self.bodyStream writeData:data];
        }
    }
    
    return self;
}

@end


@implementation NSHTTPURLResponse (Expire)

- (NSDate *)expireDate
{
    NSDate *expireDate = nil;
    
    NSDictionary *headerFields = [self allHeaderFields];
    
    if ([headerFields count])
    {
        NSString *cacheControl = [headerFields objectForKey:@"Cache-Control"];
        
        NSString *expires = [headerFields objectForKey:@"Expires"];
        
        if (cacheControl)
        {
            long long cacheControlMaxAge = 0;
            
            if ([cacheControl hasPrefix:@"s-maxage="])
            {
                cacheControlMaxAge = [[cacheControl stringByReplacingOccurrencesOfString:@"s-maxage=" withString:@""] longLongValue];
            }
            else if ([cacheControl hasPrefix:@"max-age="])
            {
                cacheControlMaxAge = [[cacheControl stringByReplacingOccurrencesOfString:@"max-age=" withString:@""] longLongValue];
            }
            
            if (cacheControlMaxAge)
            {
                NSDate *date = [NSDate dateWithFormatString:[headerFields objectForKey:@"Date"] byType:DateFormatType_HTTPHeaderDate];
                
                expireDate = [date dateByAddingTimeInterval:cacheControlMaxAge];
            }
        }
        else if (expires)
        {
            expireDate = [NSDate dateWithFormatString:expires byType:DateFormatType_HTTPHeaderDate];
        }
    }
    
    return expireDate;
}

@end


@implementation NSHTTPURLResponse (Content)

- (unsigned long long)rawContentLength
{
    unsigned long long totalSize = 0;
    
    NSDictionary *headerFields = [self allHeaderFields];
    
    NSString *contentRange = [headerFields objectForKey:@"Content-Range"];
    
    if ([contentRange length])
    {
        //            long long firstBytes = 0;
        //            long long lastBytes = 0;
        
        if ([contentRange hasPrefix:@"bytes "])
        {
            NSString *bytesString = [contentRange stringByReplacingOccurrencesOfString:@"bytes " withString:@""];
            
            NSArray *strings1 = [bytesString componentsSeparatedByString:@"-"];
            if ([strings1 count] == 2)
            {
                //                    firstBytes = [(NSString *)[strings1 objectAtIndex:0] longLongValue];
                
                NSArray *strings2 = [bytesString componentsSeparatedByString:@"/"];
                if ([strings2 count] == 2)
                {
                    //                        lastBytes = [(NSString *)[strings2 objectAtIndex:0] longLongValue];
                    totalSize = [(NSString *)[strings2 objectAtIndex:1] longLongValue];
                }
            }
        }
    }
    else
    {
        NSString *contentEncoding = [headerFields objectForKey:@"Content-Encoding"];
        
        if (!contentEncoding || [contentEncoding isEqualToString:@"identity"])
        {
            NSString *contentLength = [headerFields objectForKey:@"Content-Length"];
            
            if ([contentLength length])
            {
                totalSize = [contentLength longLongValue];
            }
        }
    }
    
    return totalSize;
}

@end
