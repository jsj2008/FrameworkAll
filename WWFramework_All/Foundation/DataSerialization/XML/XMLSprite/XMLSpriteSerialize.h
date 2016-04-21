//
//  XMLSpriteSerialize.h
//  FoundationProject
//
//  Created by user on 13-11-30.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLSprite.h"

@class XMLParsingContextBySprite, XMLSerailizingContextBySprite;


#pragma mark - XMLParsingBySprite

/*********************************************************
 
    @protocol
        XMLParsingBySprite
 
    @abstract
        XML数据解析协议，将XML数据转换成数据对象
 
 *********************************************************/

@protocol XMLParsingBySprite <NSObject>

/*!
 * @brief 根据XML数据初始化
 * @param node XML节点
 * @param context XML上下文
 * @result 初始化的对象
 */
- (id)initWithXMLNode:(XMLNodeSprite *)node withContext:(XMLParsingContextBySprite *)context;

/*!
 * @brief 根据XML数据生产对象
 * @param node XML节点
 * @param context XML上下文
 * @result 生产的对象
 */
+ (id)objectWithXMLNode:(XMLNodeSprite *)node withContext:(XMLParsingContextBySprite *)context;

@end


#pragma mark - XMLSerailizingBySprite

/*********************************************************
 
    @protocol
        XMLSerailizingBySprite
 
    @abstract
        XML数据序列化协议，将数据对象转换成XML数据
 
 *********************************************************/

@protocol XMLSerailizingBySprite <NSObject>

/*!
 * @brief 将对象转换成XML数据
 * @param context XML上下文
 * @result 转换后的XML数据
 */
- (XMLNodeSprite *)XMLNodeWithContext:(XMLSerailizingContextBySprite *)context;

@end


#pragma mark - NSData (XMLSprite)

/*********************************************************
 
    @category
        NSData (XMLSprite)
 
    @abstract
        NSData的XML扩展
 
 *********************************************************/

@interface NSData (XMLSprite)

/*!
 * @brief 从二进制数据解析XML文档信息
 * @result XML文档信息
 */
- (XMLDocumentSprite *)XMLDocumentSprite;

/*!
 * @brief 将XML文档信息转换成二进制数据
 * @param Sprite XML文档元素
 * @param encoding 内容编码方式，若为nil，将使用UTF8编码
 * @result 二进制数据
 */
+ (NSData *)dataWithXMLDocumentSprite:(XMLDocumentSprite *)Sprite usingEncoding:(NSString *)encoding;

@end


#pragma mark - NSString (XMLSprite)

/*********************************************************
 
    @category
        NSString (XMLSprite)
 
    @abstract
        NSString的XML扩展
 
    @discussion
        内部调用NSData (XML)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (XML)实现相应功能
 
 *********************************************************/

@interface NSString (XMLSprite)

/*!
 * @brief 从字符串解析XML文档信息
 * @result XML文档信息
 */
- (XMLDocumentSprite *)XMLDocumentSprite;

/*!
 * @brief 将XML文档信息转换成字符串
 * @param Sprite XML文档元素
 * @result 字符串
 */
+ (NSString *)stringWithXMLDocumentSprite:(XMLDocumentSprite *)Sprite;

@end


#pragma mark - XMLParsingContextBySprite

/*********************************************************
 
    @class
        XMLParsingContextBySprite
 
    @abstract
        XML数据解析上下文，用于配置解析选项
 
 *********************************************************/

@interface XMLParsingContextBySprite : NSObject

/*!
 * @brief 版本号，用于确定使用何种解析方式（同一数据对象可能对应多种XML数据结构）
 */
@property (nonatomic, copy) NSString *version;

@end


#pragma mark - XMLSerailizingContextBySprite

/*********************************************************
 
    @class
        XMLSerailizingContextBySprite
 
    @abstract
        XML数据序列化上下文，用于配置序列化选项
 
 *********************************************************/

@interface XMLSerailizingContextBySprite : NSObject

/*!
 * @brief 版本号，用于确定使用何种解析方式（同一数据对象可能对应多种XML数据结构）
 */
@property (nonatomic, copy) NSString *version;

@end
