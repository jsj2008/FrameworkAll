//
//  EPubXML.m
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPubXML.h"

#pragma mark - NSString (EPubXML)

@implementation NSString (EPubXML)

+ (NSString *)stringWithEPubXMLChar:(const xmlChar *)xmlChar
{
    NSString *string = nil;
    
    if (xmlChar)
    {
        string = [NSString stringWithUTF8String:(const char *)xmlChar];
    }
    
    return string;
}

@end


#pragma mark - NSDate (EPubXML)

@implementation NSDate (EPubXML)

+ (NSDate *)dateFromEPubXMLDateString:(NSString *)dateString
{
    NSDate *date = nil;
    
    if ([dateString length])
    {
        NSArray *components = [dateString componentsSeparatedByString:@"-"];
        
        NSString *yearString = [components count] ? [components objectAtIndex:0] : nil;
        
        NSString *monthString = ([components count] >= 2) ? [components objectAtIndex:1] : nil;
        
        NSString *dayString = ([components count] >= 3) ? [components objectAtIndex:2] : nil;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        [dateComponents setYear:[yearString intValue]];
        
        [dateComponents setMonth:[monthString intValue]];
        
        [dateComponents setDay:[dayString intValue]];
        
        date = [calendar dateFromComponents:dateComponents];
    }
    
    return date;
}

@end


#pragma mark - EPubXMLUtility

@implementation EPubXMLUtility

+ (NSString *)valueOfPropertyNamed:(NSString *)name forNode:(xmlNodePtr)node
{
    NSString *value = nil;
    
    if (node && name)
    {
        xmlChar *valueChar = xmlGetProp(node, BAD_CAST[name UTF8String]);
        
        if (valueChar)
        {
            value = [NSString stringWithUTF8String:(const char *)valueChar];
        }
        
        xmlFree(valueChar);
    }
    
    return value;
}

+ (NSString *)contentOfNode:(xmlNodePtr)node
{
    NSString *content = nil;
    
    if (node)
    {
        xmlChar *contentChar = xmlNodeGetContent(node);
        
        if (contentChar)
        {
            content = [NSString stringWithUTF8String:(const char *)contentChar];
        }
        
        xmlFree(contentChar);
    }
    
    return content;
}

@end
