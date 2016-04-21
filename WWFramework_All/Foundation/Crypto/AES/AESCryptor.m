//
//  AESCryptor.m
//  DuomaiFrameWork
//
//  Created by Baymax on 5/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "AESCryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AESBase)

/*!
 * @brief AES128编解码
 * @discussion 采用kCCOptionPKCS7Padding方式编解码
 * @param operation 编解码操作
 * @param key 编解码密钥，要求长度为16位
 * @param iv 初始向量，要求长度为16位
 * @result 编解码后的数据
 */
- (NSData *)AES128CryptedDataByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv;

/*!
 * @brief AES256编解码
 * @discussion 采用kCCOptionPKCS7Padding方式编解码
 * @param operation 编解码操作
 * @param key 编解码密钥，要求长度为32位
 * @param iv 初始向量，要求长度为16位
 * @result 编解码后的数据
 */
- (NSData *)AES256CryptedDataByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv;

@end


@implementation NSData (AESBase)

- (NSData *)AES128CryptedDataByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 16 bytes for AES128
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    
    bzero( keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getBytes:keyPtr length:[key length]];
    
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = kCCSuccess;
    
    NSData *cryptedData = nil;
    
    if ([iv length])
    {
        char ivPtr[kCCBlockSizeAES128 + 1]; // room for terminator (unused)
        
        bzero( ivPtr, sizeof(ivPtr)); // fill with zeroes (for padding)
        
        [iv getBytes:ivPtr length:[iv length]];
        
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES128,
                              ivPtr /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    else
    {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES128,
                              NULL /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    
    
    
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        cryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    
    return cryptedData;
}

- (NSData *)AES256CryptedDataByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 16 bytes for AES128
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    
    bzero( keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getBytes:keyPtr length:[key length]];
    
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = kCCSuccess;
    
    NSData *cryptedData = nil;
    
    if ([iv length])
    {
        char ivPtr[kCCBlockSizeAES128 + 1]; // room for terminator (unused)
        
        bzero( ivPtr, sizeof(ivPtr)); // fill with zeroes (for padding)
        
        [iv getBytes:ivPtr length:[iv length]];
        
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES256,
                              ivPtr /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    else
    {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES256,
                              NULL /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    
    
    
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        cryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    
    return cryptedData;
}

@end



@implementation NSData (AES)

- (NSData *)AES128EncryptedDataWithKey:(NSData *)key
{
    return [self AES128CryptedDataByOperation:kCCEncrypt withKey:key iv:nil];
}

- (NSData *)AES128DecryptedDataWithKey:(NSData *)key
{
    return [self AES128CryptedDataByOperation:kCCDecrypt withKey:key iv:nil];
}

- (NSData *)AES256EncryptedDataWithKey:(NSData *)key
{
    return [self AES256CryptedDataByOperation:kCCEncrypt withKey:key iv:nil];
}

- (NSData *)AES256DecryptedDataWithKey:(NSData *)key
{
    return [self AES256CryptedDataByOperation:kCCDecrypt withKey:key iv:nil];
}

@end


@implementation NSString (AES)

- (NSData *)AES128EncryptedDataWithKey:(NSData *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key];
}

- (NSData *)AES128DecryptedDataWithKey:(NSData *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES128CryptedDataByOperation:kCCDecrypt withKey:key iv:nil];
}

- (NSData *)AES256EncryptedDataWithKey:(NSData *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES256CryptedDataByOperation:kCCEncrypt withKey:key iv:nil];
}

- (NSData *)AES256DecryptedDataWithKey:(NSData *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES256CryptedDataByOperation:kCCDecrypt withKey:key iv:nil];
}

@end
