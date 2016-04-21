//
//  HTTPContentEncoding.h
//  FoundationProject
//
//  Created by user on 13-12-2.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - HTTPContentEncoding

/*********************************************************
 
    @class
        HTTPContentEncoding
 
    @abstract
        HTTP内容编码格式，将编码字符串转换成可用的编码格式
 
 *********************************************************/

@interface HTTPContentEncoding : NSObject
{
    // CFStringEncoding编码格式
    CFStringEncoding _stringEncoding;
}

/*!
 * @brief 初始化
 * @discussion 初始化过程中，会将编码字符串转换成可用的编码格式
 * @param encodingString 编码字符串
 * @result 初始化后的对象
 */
- (id)initWithEncodingString:(NSString *)encodingString;

/*!
 * @brief 本编码方式是否被支持
 * @result 编码方式是否被支持
 */
- (BOOL)isSupportable;

/*!
 * @brief 本编码方式对应的可被支持的CFStringEncoding编码格式
 * @result CFStringEncoding编码格式，若返回－1，表明编码方式不被支持（等价于－isSupportable返回NO）
 */
- (CFStringEncoding)supportableCFStringEncoding;

@end


#pragma mark - HTTPJsonContentEncoding

/*********************************************************
 
    @class
        HTTPJsonContentEncoding
 
    @abstract
        HTTPContentEncoding的子类，Json内容的编码格式
 
    @discussion
        Json内容只支持UTF－8，UTF－16，UTF－16LE，UTF－16BE，UTF－32，UTF－32LE，UTF－32BE等编码方式
 
 *********************************************************/

@interface HTTPJsonContentEncoding : HTTPContentEncoding

@end


#pragma mark - HTTPXMLContentEncoding

/*********************************************************
 
    @class
        HTTPXMLContentEncoding
 
    @abstract
        HTTPContentEncoding的子类，XML内容的编码格式
 
    @discussion
        XML内容只支持UTF－8，GB2312等编码方式
 
 *********************************************************/

@interface HTTPXMLContentEncoding : HTTPContentEncoding

@end
