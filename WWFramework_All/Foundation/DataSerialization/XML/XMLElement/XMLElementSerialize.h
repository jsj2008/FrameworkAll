//
//  XMLElementSerialize.h
//  FoundationProject
//
//  Created by user on 13-11-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLElement.h"

@class XMLParsingContextByElement, XMLSerailizingContextByElement;


#pragma mark - XMLParsingByElement

/*********************************************************
 
    @protocol
        XMLParsingByElement
 
    @abstract
        XML数据解析协议，将XML数据转换成数据对象
 
 *********************************************************/

@protocol XMLParsingByElement <NSObject>

/*!
 * @brief 根据XML数据初始化
 * @param node XML节点
 * @param context XML上下文
 * @result 初始化的对象
 */
- (id)initWithXMLNode:(XMLNodeElement *)node withContext:(XMLParsingContextByElement *)context;

/*!
 * @brief 根据XML数据生产对象
 * @param node XML节点
 * @param context XML上下文
 * @result 生产的对象
 */
+ (id)objectWithXMLNode:(XMLNodeElement *)node withContext:(XMLParsingContextByElement *)context;

@end


#pragma mark - XMLSerailizingByElement

/*********************************************************
 
    @protocol
        XMLSerailizingByElement
 
    @abstract
        XML数据序列化协议，将数据对象转换成XML数据
 
 *********************************************************/

@protocol XMLSerailizingByElement <NSObject>

/*!
 * @brief 将对象转换成XML数据
 * @param context XML上下文
 * @result 转换后的XML数据
 */
- (XMLNodeElement *)XMLNodeWithContext:(XMLSerailizingContextByElement *)context;

@end


#pragma mark - NSData (XMLElement)

/*********************************************************
 
    @category
        NSData (XMLElement)
 
    @abstract
        NSData的XML扩展
 
 *********************************************************/

@interface NSData (XMLElement)

/*!
 * @brief 从二进制数据解析XML文档信息
 * @result XML文档信息
 */
- (XMLDocumentElement *)XMLDocumentElement;

/*!
 * @brief 将XML文档信息转换成二进制数据
 * @param element XML文档元素
 * @param encoding 内容编码方式，若为nil，将使用UTF8编码
 * @result 二进制数据
 */
+ (NSData *)dataWithXMLDocumentElement:(XMLDocumentElement *)element usingEncoding:(NSString *)encoding;

@end


#pragma mark - NSString (XMLElement)

/*********************************************************
 
    @category
        NSString (XMLElement)
 
    @abstract
        NSString的XML扩展
 
    @discussion
        内部调用NSData (XML)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (XML)实现相应功能
 
 *********************************************************/

@interface NSString (XMLElement)

/*!
 * @brief 从字符串解析XML文档信息
 * @result XML文档信息
 */
- (XMLDocumentElement *)XMLDocumentElement;

/*!
 * @brief 将XML文档信息转换成字符串
 * @param element XML文档元素
 * @result 字符串
 */
+ (NSString *)stringWithXMLDocumentElement:(XMLDocumentElement *)element;

@end


#pragma mark - XMLParsingContextByElement

/*********************************************************
 
    @class
        XMLParsingContextByElement
 
    @abstract
        XML数据解析上下文，用于配置解析选项
 
 *********************************************************/

@interface XMLParsingContextByElement : NSObject

/*!
 * @brief 版本号，用于确定使用何种解析方式（同一数据对象可能对应多种XML数据结构）
 */
@property (nonatomic, copy) NSString *version;

@end


#pragma mark - XMLSerailizingContextByElement

/*********************************************************
 
    @class
        XMLSerailizingContextByElement
 
    @abstract
        XML数据序列化上下文，用于配置序列化选项
 
 *********************************************************/

@interface XMLSerailizingContextByElement : NSObject

/*!
 * @brief 版本号，用于确定使用何种解析方式（同一数据对象可能对应多种XML数据结构）
 */
@property (nonatomic, copy) NSString *version;

@end
