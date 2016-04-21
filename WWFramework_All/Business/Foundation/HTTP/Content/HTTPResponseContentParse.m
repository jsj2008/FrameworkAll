//
//  HTTPResponseContentParse.m
//  FoundationProject
//
//  Created by user on 13-11-28.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "HTTPResponseContentParse.h"
#import "HTTPHeaderFields.h"
#import "JsonSerialize.h"
#import "XMLElementSerialize.h"
#import "XMLSpriteSerialize.h"
#import "HTTPContentEncoding.h"
#import "APPDebug.h"

#pragma mark - HTTPResponseContentParser

@implementation HTTPResponseContentParser

- (id)initWithResponse:(NSHTTPURLResponse *)response content:(NSData *)content
{
    if (self = [super init])
    {
        _response = response;
        
        _content = content;
        
        _isContentValid = YES;
    }
    
    return self;
}

- (BOOL)isContentValid
{
    return _isContentValid;
}

@end


#pragma mark - HTTPResponseJsonContentParser

@implementation HTTPResponseJsonContentParser

- (id)initWithResponse:(NSHTTPURLResponse *)response content:(NSData *)content
{
    if (self = [super initWithResponse:response content:content])
    {
        NSString *contentType = [[[HTTPHeaderFields alloc] initWithHTTPResponse:response] contentType];
        
        // 标准json的contentTpye是application/json，为了兼容其他版本，这里放宽了判断条件
        if ([contentType rangeOfString:@"application/json"].location != NSNotFound ||
            [contentType rangeOfString:@"text/json"].location != NSNotFound ||
            [contentType rangeOfString:@"text/javascript"].location != NSNotFound ||
            [contentType rangeOfString:@"application/javascript"].location != NSNotFound)
        {
            _isContentValid = YES;
        }
        
        if (_isContentValid)
        {
            NSString *encoding = nil;
            
            NSArray *components = [contentType componentsSeparatedByString:@"charset="];
            
            if ([components count] >= 2)
            {
                encoding = [[components lastObject] lowercaseString];
            }
            else
            {
                encoding = @"utf-8";
            }
            
            HTTPJsonContentEncoding *HTTPEncoding = [[HTTPJsonContentEncoding alloc] initWithEncodingString:encoding];
            
            if ([HTTPEncoding isSupportable])
            {
                _rootNode = [content jsonRootNode];
            }
            else
            {
                _isContentValid = NO;
                
                [APPDebug assertWithCondition:NO string:@"HTTP Json content encoded by unsupport character set"];
            }
        }
    }
    
    return self;
}

- (id)rootNode
{
    return _isContentValid ? _rootNode : nil;
}

@end


#pragma mark - HTTPResponseXMLContentElementParser

@implementation HTTPResponseXMLContentElementParser

- (id)initWithResponse:(NSHTTPURLResponse *)response content:(NSData *)content
{
    if (self = [super initWithResponse:response content:content])
    {
        NSString *contentType = [[[HTTPHeaderFields alloc] initWithHTTPResponse:response] contentType];
        
        if ([contentType rangeOfString:@"xml"].location != NSNotFound)
        {
            _isContentValid = YES;
        }
        
        if (_isContentValid)
        {
            NSString *encoding = nil;
            
            NSArray *components = [contentType componentsSeparatedByString:@"charset="];
            
            if ([components count] >= 2)
            {
                encoding = [[components lastObject] lowercaseString];
            }
            
            NSData *documentData = content;
            
            HTTPXMLContentEncoding *HTTPEncoding = [[HTTPXMLContentEncoding alloc] initWithEncodingString:encoding];
            
            if ([HTTPEncoding isSupportable])
            {
                CFStringEncoding stringEncoding = [HTTPEncoding supportableCFStringEncoding];
                
                if (stringEncoding != kCFStringEncodingUTF8)
                {
                    NSString *string = (NSString *)CFBridgingRelease(CFStringCreateFromExternalRepresentation(kCFAllocatorDefault, (CFDataRef)content, stringEncoding));
                    
                    documentData = [string dataUsingEncoding:NSUTF8StringEncoding];
                }
            }
            else
            {
                [APPDebug assertWithCondition:NO string:@"HTTP XML content encoded by unsupport character set"];
            }
            
            if ([documentData length])
            {
                _documentElement = [[XMLDocumentElement alloc] initWithData:documentData];
                
                if (![_documentElement isDocumentValid])
                {
                    _documentElement = nil;
                    
                    _isContentValid = NO;
                }
            }
            else
            {
                _isContentValid = NO;
            }
        }
    }
    
    return self;
}

- (XMLDocumentElement *)documentElement
{
    return _isContentValid ? _documentElement : nil;
}

@end


#pragma mark - HTTPResponseXMLContentSpriteParser

@implementation HTTPResponseXMLContentSpriteParser

- (id)initWithResponse:(NSHTTPURLResponse *)response content:(NSData *)content
{
    if (self = [super initWithResponse:response content:content])
    {
        NSString *contentType = [[[HTTPHeaderFields alloc] initWithHTTPResponse:response] contentType];
        
        if ([contentType rangeOfString:@"xml"].location != NSNotFound)
        {
            _isContentValid = YES;
        }
        
        if (_isContentValid)
        {
            NSString *encoding = nil;
            
            NSArray *components = [contentType componentsSeparatedByString:@"charset="];
            
            if ([components count] >= 2)
            {
                encoding = [[components lastObject] lowercaseString];
            }
            
            NSData *documentData = content;
            
            HTTPXMLContentEncoding *HTTPEncoding = [[HTTPXMLContentEncoding alloc] initWithEncodingString:encoding];
            
            if ([HTTPEncoding isSupportable])
            {
                CFStringEncoding stringEncoding = [HTTPEncoding supportableCFStringEncoding];
                
                if (stringEncoding != kCFStringEncodingUTF8)
                {
                    NSString *string = (NSString *)CFBridgingRelease(CFStringCreateFromExternalRepresentation(kCFAllocatorDefault, (CFDataRef)content, stringEncoding));
                    
                    documentData = [string dataUsingEncoding:NSUTF8StringEncoding];
                }
            }
            else
            {
                [APPDebug assertWithCondition:NO string:@"HTTP XML content encoded by unsupport character set"];
            }
            
            if ([documentData length])
            {
                _documentSprite = [[XMLDocumentSprite alloc] initWithData:documentData];
                
                if (!_documentSprite.rootNode)
                {
                    _documentSprite = nil;
                    
                    _isContentValid = NO;
                }
            }
            else
            {
                _isContentValid = NO;
            }
        }
    }
    
    return self;
}

- (XMLDocumentSprite *)documentSprite
{
    return _isContentValid ? _documentSprite : nil;
}

@end
