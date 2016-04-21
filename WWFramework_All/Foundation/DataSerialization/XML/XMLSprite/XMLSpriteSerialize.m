//
//  XMLSpriteSerialize.m
//  FoundationProject
//
//  Created by user on 13-11-30.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "XMLSpriteSerialize.h"

#pragma mark - NSData (XMLSprite)

@implementation NSData (XMLSprite)

- (XMLDocumentSprite *)XMLDocumentSprite
{
    XMLDocumentSprite *documentSprite = [[XMLDocumentSprite alloc] initWithData:self];
    
    return documentSprite.rootNode ? documentSprite : nil;
}

+ (NSData *)dataWithXMLDocumentSprite:(XMLDocumentSprite *)Sprite usingEncoding:(NSString *)encoding
{
    return [Sprite serializedDataUsingEncoding:encoding];
}

@end


#pragma mark - NSString (XMLSprite)

@implementation NSString (XMLSprite)

- (XMLDocumentSprite *)XMLDocumentSprite
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] XMLDocumentSprite];
}

+ (NSString *)stringWithXMLDocumentSprite:(XMLDocumentSprite *)Sprite
{
    NSData *data = [NSData dataWithXMLDocumentSprite:Sprite usingEncoding:nil];
    
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

@end


#pragma mark - XMLParsingContextBySprite

@implementation XMLParsingContextBySprite

@end


#pragma mark - XMLSerailizingContextBySprite

@implementation XMLSerailizingContextBySprite

@end
