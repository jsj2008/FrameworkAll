//
//  EPubXML.h
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml2/libxml/tree.h>

#pragma mark - NSString (EPubXML)

/*********************************************************
 
    @category
        NSString (EPubXML)
 
    @abstract
        NSString的扩展，负责在EPub的XML解析中的接口
 
 *********************************************************/

@interface NSString (EPubXML)

/*!
 * @brief 将EPub中的XML字符串转换成NSString对象
 * @param xmlChar XML字符串
 * @result NSString对象
 */
+ (NSString *)stringWithEPubXMLChar:(const xmlChar *)xmlChar;

@end


#pragma mark - NSDate (EPubXML)

/*********************************************************
 
    @category
        NSDate (EPubXML)
 
    @abstract
        NSDate的扩展，负责在EPub的XML解析中的接口
 
 *********************************************************/

@interface NSDate (EPubXML)

/*!
 * @brief 将EPub中的时间字符串转换成NSDate对象
 * @param dateString 时间字符串
 * @result NSDate对象
 */
+ (NSDate *)dateFromEPubXMLDateString:(NSString *)dateString;

@end


#pragma mark - EPubXMLUtility

/*********************************************************
 
    @class
        EPubXMLUtility
 
    @abstract
        EPub的XML实用工具，提供一些XML处理时的便捷方法
 
 *********************************************************/

@interface EPubXMLUtility : NSObject

/*!
 * @brief 从XML节点获取指定名称的属性值
 * @param name 属性名称
 * @param node XML节点
 * @result 属性值
 */
+ (NSString *)valueOfPropertyNamed:(NSString *)name forNode:(xmlNodePtr)node;

/*!
 * @brief 从XML节点获取文本
 * @param node XML节点
 * @result 文本
 */
+ (NSString *)contentOfNode:(xmlNodePtr)node;

@end


#pragma mark - EPubXMLParsing

/*********************************************************
 
    @protocol
        EPubXMLParsing
 
    @abstract
        EPub的XML解析协议
 
 *********************************************************/

@protocol EPubXMLParsing <NSObject>

/*!
 * @brief 初始化
 * @discussion 以XML节点中的数据来初始化对象
 * @param node XML节点
 * @result 初始化后的对象
 */
- (id)initWithXMLNode:(xmlNodePtr)node;

@end


#pragma mark - EPubXMLSerializing

/*********************************************************
 
    @protocol
        EPubXMLSerializing
 
    @abstract
        EPub的XML序列化协议
 
 *********************************************************/

@protocol EPubXMLSerializing <NSObject>

/*!
 * @brief 将对象转换成XML节点
 * @result XML节点
 */
- (xmlNodePtr *)XMLNode;

@end
