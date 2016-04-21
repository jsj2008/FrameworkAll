//
//  AESCryptor.h
//  DuomaiFrameWork
//
//  Created by Baymax on 5/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @protocol
        AESing
 
    @abstract
        AES编解码协议
 
 *********************************************************/

@protocol AESing <NSObject>

/*!
 * @brief AES128编码
 * @discussion 采用kCCOptionPKCS7Padding方式编码，无初始向量
 * @param key 编码密钥，要求长度为16位
 * @result 编码后的数据
 */
- (NSData *)AES128EncryptedDataWithKey:(NSData *)key;

/*!
 * @brief AES128解码
 * @discussion 采用kCCOptionPKCS7Padding方式解码，无初始向量
 * @param key 解码密钥，要求长度为16位
 * @result 解码后的数据
 */
- (NSData *)AES128DecryptedDataWithKey:(NSData *)key;

/*!
 * @brief AES256编码
 * @discussion 采用kCCOptionPKCS7Padding方式编码，无初始向量
 * @param key 编码密钥，要求长度为32位
 * @result 编码后的数据
 */
- (NSData *)AES256EncryptedDataWithKey:(NSData *)key;

/*!
 * @brief AES256解码
 * @discussion 采用kCCOptionPKCS7Padding方式解码，无初始向量
 * @param key 解码密钥，要求长度为32位
 * @result 解码后的数据
 */
- (NSData *)AES256DecryptedDataWithKey:(NSData *)key;

@end


/*********************************************************
 
    @category
        NSData (AES)
 
    @abstract
        NSData的AES编解码扩展
 
 *********************************************************/

@interface NSData (AES) <AESing>

@end


/*********************************************************
 
    @category
        NSString (AES)
 
    @abstract
        NSString的AES编解码扩展
 
    @discussion
        内部调用NSData (AES)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (AES)实现编码功能
 
 *********************************************************/

@interface NSString (AES) <AESing>

@end
