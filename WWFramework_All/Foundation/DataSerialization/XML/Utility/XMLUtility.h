//
//  XMLUtility.h
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml2/libxml/tree.h>

#pragma mark - NSString (XMLString)

/*********************************************************
 
    @category
        NSString (XMLString)
 
    @abstract
        NSString的扩展，负责NSString和XML字符之间的转换
 
 *********************************************************/

@interface NSString (XMLString)

/*!
 * @brief 将XML字符串转换成NSString对象
 * @param xmlChar XML字符串
 * @result 转换后的NSString对象
 */
+ (NSString *)stringWithXMLChar:(const xmlChar *)xmlChar withStringEncoding:(NSStringEncoding)encoding;

@end
