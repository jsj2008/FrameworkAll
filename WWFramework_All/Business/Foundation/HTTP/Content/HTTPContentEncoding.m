//
//  HTTPContentEncoding.m
//  FoundationProject
//
//  Created by user on 13-12-2.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "HTTPContentEncoding.h"

#pragma mark - HTTPContentEncoding

@implementation HTTPContentEncoding

- (id)initWithEncodingString:(NSString *)encodingString
{
    if (self = [super init])
    {
        _stringEncoding = -1;
    }
    
    return self;
}

- (BOOL)isSupportable
{
    return ((long)_stringEncoding > -1);
}

- (CFStringEncoding)supportableCFStringEncoding
{
    return _stringEncoding;
}

@end


#pragma mark - HTTPJsonContentEncoding

@implementation HTTPJsonContentEncoding

- (id)initWithEncodingString:(NSString *)encodingString
{
    if (self = [super initWithEncodingString:encodingString])
    {
        NSString *lowercaseEncodingString = [encodingString lowercaseString];
        
        if ([lowercaseEncodingString isEqualToString:@"utf-8"] || [lowercaseEncodingString isEqualToString:@"utf8"])
        {
            _stringEncoding = kCFStringEncodingUTF8;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-16"] || [lowercaseEncodingString isEqualToString:@"utf16"])
        {
            _stringEncoding = kCFStringEncodingUTF16;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-16le"] || [lowercaseEncodingString isEqualToString:@"utf16le"])
        {
            _stringEncoding = kCFStringEncodingUTF16LE;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-16be"] || [lowercaseEncodingString isEqualToString:@"utf16be"])
        {
            _stringEncoding = kCFStringEncodingUTF16BE;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-32"] || [lowercaseEncodingString isEqualToString:@"utf32"])
        {
            _stringEncoding = kCFStringEncodingUTF32;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-32le"] || [lowercaseEncodingString isEqualToString:@"utf32le"])
        {
            _stringEncoding = kCFStringEncodingUTF32LE;
        }
        else if ([lowercaseEncodingString isEqualToString:@"utf-32be"] || [lowercaseEncodingString isEqualToString:@"utf32be"])
        {
            _stringEncoding = kCFStringEncodingUTF32BE;
        }
    }
    
    return self;
}

@end


#pragma mark - HTTPXMLContentEncoding

@implementation HTTPXMLContentEncoding

- (id)initWithEncodingString:(NSString *)encodingString
{
    if (self = [super initWithEncodingString:encodingString])
    {
        NSString *lowercaseEncodingString = [encodingString lowercaseString];
        
        if ([lowercaseEncodingString isEqualToString:@"utf-8"] || [lowercaseEncodingString isEqualToString:@"utf8"])
        {
            _stringEncoding = kCFStringEncodingUTF8;
        }
        else if ([lowercaseEncodingString isEqualToString:@"gb2312"])
        {
            _stringEncoding = kCFStringEncodingGB_2312_80;
        }
    }
    
    return self;
}

@end
