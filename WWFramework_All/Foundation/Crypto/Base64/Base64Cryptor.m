//
//  Base64Cryptor.m
//  Application
//
//  Created by Baymax on 14-2-20.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "Base64Cryptor.h"
#import "GTMBase64.h"

@implementation NSData (Base64)

- (NSString *)base64EncodedString
{
    return [GTMBase64 stringByEncodingData:self];
}

- (NSData *)base64DecodedData
{
    return [GTMBase64 decodeData:self];
}

@end


@implementation NSString (Base64)

- (NSString *)base64EncodedString
{
    return [GTMBase64 stringByEncodingData:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)base64DecodedData
{
    return [GTMBase64 decodeString:self];
}

@end
