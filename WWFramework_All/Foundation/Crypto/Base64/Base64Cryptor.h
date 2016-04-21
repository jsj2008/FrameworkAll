//
//  Base64Cryptor.h
//  Application
//
//  Created by Baymax on 14-2-20.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @protocol
        Base64ing
 
    @abstract
        Base64编解码协议
 
 *********************************************************/

@protocol Base64ing <NSObject>

/*!
 * @brief Base64编码后的字符串
 * @result 字符串
 */
- (NSString *)base64EncodedString;

/*!
 * @brief Base64解码后的字节数据
 * @result 字节数据
 */
- (NSData *)base64DecodedData;

@end


/*********************************************************
 
    @category
        NSData (Base64)
 
    @abstract
        NSData的Base64编解码扩展
 
 *********************************************************/

@interface NSData (Base64) <Base64ing>

@end


/*********************************************************
 
    @category
        NSString (Base64)
 
    @abstract
        NSString的Base64编解码扩展
 
    @discussion
        内部调用NSData (Base64)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (Base64)实现编码功能
 
 *********************************************************/

@interface NSString (Base64) <Base64ing>

@end
