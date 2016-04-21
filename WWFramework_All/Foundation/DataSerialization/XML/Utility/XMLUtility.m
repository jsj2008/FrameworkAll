//
//  XMLUtility.m
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "XMLUtility.h"

#pragma mark - NSString (XMLString)

@implementation NSString (XMLString)

+ (NSString *)stringWithXMLChar:(const xmlChar *)xmlChar withStringEncoding:(NSStringEncoding)encoding
{
    NSString *string = nil;
    
    if (xmlChar)
    {
        string = [NSString stringWithCString:(const char *)xmlChar encoding:encoding];
    }
    
    return string;
}

@end
