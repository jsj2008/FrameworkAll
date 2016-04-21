//
//  XMLElementSerialize.m
//  FoundationProject
//
//  Created by user on 13-11-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "XMLElementSerialize.h"

#pragma mark - NSData (XMLElement)

@implementation NSData (XMLElement)

- (XMLDocumentElement *)XMLDocumentElement
{
    XMLDocumentElement *documentElement = [[XMLDocumentElement alloc] initWithData:self];
    
    return [documentElement isDocumentValid] ? documentElement : nil;
}

+ (NSData *)dataWithXMLDocumentElement:(XMLDocumentElement *)element usingEncoding:(NSString *)encoding
{
    return [element serializedDataUsingEncoding:encoding];
}

@end


#pragma mark - NSString (XMLElement)

@implementation NSString (XMLElement)

- (XMLDocumentElement *)XMLDocumentElement
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] XMLDocumentElement];
}

+ (NSString *)stringWithXMLDocumentElement:(XMLDocumentElement *)element
{
    NSData *data = [NSData dataWithXMLDocumentElement:element usingEncoding:nil];
    
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

@end


#pragma mark - XMLParsingContextByElement

@implementation XMLParsingContextByElement

@end


#pragma mark - XMLSerailizingContextByElement

@implementation XMLSerailizingContextByElement

@end
