//
//  MD5Cryptor.h
//  Demo
//
//  Created by Baymax on 13-10-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PipedInputStream.h"

#pragma mark - MD5ing

/*********************************************************
 
    @protocol
        MD5ing
 
    @abstract
        MD5编码协议
 
 *********************************************************/

@protocol MD5ing <NSObject>

/*!
 * @brief MD5编码字符串并大写
 * @result 编码后字符串
 */
- (NSString *)uppercaseMD5EncodedString;

@end


#pragma mark - NSData (MD5Encode)

/*********************************************************
 
    @category
        NSData (MD5Encode)
 
    @abstract
        NSData的类别扩展，实现MD5编码
 
 *********************************************************/

@interface NSData (MD5Encode) <MD5ing>

@end


#pragma mark - NSString (MD5Encode)

/*********************************************************
 
    @category
        NSString (MD5Encode)
 
    @abstract
        NSString的类别扩展，实现MD5编码，使用UTF8编码
 
    @discussion
        内部调用NSData (MD5Encode)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (MD5Encode)实现相应功能
 
 *********************************************************/

@interface NSString (MD5Encode) <MD5ing>

@end


#pragma mark - InputStream (MD5Encode)

/*********************************************************
 
    @category
        InputStream (MD5Encode)
 
    @abstract
        InputStream的类别扩展，实现MD5编码
 
 *********************************************************/

@interface InputStream (MD5Encode) <MD5ing>

@end


#pragma mark - FileMD5Encoder

/*********************************************************
 
    @class
        FileMD5Encoder
 
    @abstract
        文件MD5编码器
 
 *********************************************************/

@interface FileMD5Encoder : NSObject <MD5ing>
{
    // 文件路径
    NSString *_filePath;
}

/*!
 * @brief 初始化
 * @param filePath 文件路径
 * @result 初始化后的对象
 */
- (id)initWithFilePath:(NSString *)filePath;

@end
