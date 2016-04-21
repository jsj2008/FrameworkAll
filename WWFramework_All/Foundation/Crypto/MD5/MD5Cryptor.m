//
//  MD5Cryptor.m
//  Demo
//
//  Created by Baymax on 13-10-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "MD5Cryptor.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark - NSData (MD5Encode)

@implementation NSData (MD5Encode)

- (NSString *)uppercaseMD5EncodedString
{
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_CTX context;
    
    CC_MD5_Init(&context);
    
    CC_MD5_Update(&context, [self bytes], (CC_LONG)[self length]);
    
    CC_MD5_Final(md, &context);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", md[i]];
    }
    
    return [hash uppercaseString];
}

@end


#pragma mark - NSString (MD5Encode)

@implementation NSString (MD5Encode)

- (NSString *)uppercaseMD5EncodedString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] uppercaseMD5EncodedString];
}

@end


#pragma mark - InputStream (MD5Encode)

@implementation InputStream (MD5Encode)

- (NSString *)uppercaseMD5EncodedString
{
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_CTX context;
    
    CC_MD5_Init(&context);
    
    NSData *data = nil;
    
    do {
        
        @autoreleasepool
        {
            data = [self readDataOfMaxLength:1024];
            
            CC_MD5_Update(&context, [data bytes], (CC_LONG)[data length]);
        }
        
    } while (![self isOver]);
    
    CC_MD5_Final(md, &context);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", md[i]];
    }
    
    return [hash uppercaseString];
}

@end


#pragma mark - FileMD5Encoder

@implementation FileMD5Encoder

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
    }
    
    return self;
}

- (NSString *)uppercaseMD5EncodedString
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    
    if (!fileHandle)
    {
        return nil;
    }
    
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_CTX context;
    
    CC_MD5_Init(&context);
    
    NSData *data = nil;
    
    do {
        
        @autoreleasepool
        {
            data = [fileHandle readDataOfLength:1024];
            
            CC_MD5_Update(&context, [data bytes], (CC_LONG)[data length]);
        }
        
    } while ([data length]);
    
    CC_MD5_Final(md, &context);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", md[i]];
    }
    
    return [hash uppercaseString];
}

@end
