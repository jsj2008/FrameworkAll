//
//  XMLElement.h
//  FoundationProject
//
//  Created by user on 13-11-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml2/libxml/tree.h>
#import <libxml2/libxml/xpath.h>


/*!
 * XMLElement族
 * 版本号0.0
 *
 * XMLElement族是基于libxml，对XML元素的一个简单封装
 *
 * XMLElement及其子类将XML元素作为内部成员变量，并不改变XML元素的任何数据和信息，通过将普通的XML指针变量改造成Objective－C对象，使得libxml中的函数操作变成对象操作，同时在方法中对libxml中输入输出的数据类型进行对象转换，最终将对XML的操作变成通用的Objective－C对象操作
 *
 * 考虑到许多XML元素需手动释放，XMLElement类对象内部实现了XML元素的计数，并提供了修改计数的接口，随着XMLElement类对象的释放，会对相应的XML元素执行正确的释放操作
 *
 * XMLElement类对象之间的关系与XML元素一致（因为XMLElement类对象只是XML元素的一个简单外壳），例如随着XML文档指针的释放，其子节点将自动释放，XMLDocumentElement对象的释放，也会将XMLNodeElement对象的内部数据全部释放
 *
 * 关于编码，节点元素使用UTF8编码，忽略文档信息中指定的编码，因此在使用XMLElement族前，请先将文档转换成UTF8编码（保存文档时除外）
 *
 * 处理XML时，做了简化，忽略了命名空间，在后续版本可以扩展
 */



#pragma mark - XMLElement

/*********************************************************
 
    @class
        XMLElement
 
    @abstract
        XML元素对象
 
    @discussion
        核心计数应当只在XMLElement及其子类内部调用（错误的计数容易造成libxml对象的内存泄漏或重复释放）
 
 *********************************************************/

@interface XMLElement : NSObject
{
    // 核心计数，纪录对应的XML元素的内部计数
    NSInteger _coreRetainCount;
}

/*!
 * @brief 增加核心计数
 */
- (void)coreRetain;

/*!
 * @brief 减少核心计数
 */
- (void)coreRelease;

@end


@class XMLNodeElement;

#pragma mark - XMLDocumentElement

/*********************************************************
 
    @class
        XMLDocumentElement
 
    @abstract
        XML文档元素，包含文档基本信息
 
 *********************************************************/

@interface XMLDocumentElement : XMLElement
{
    // XML文档元素
    xmlDocPtr _doc;
}

/*!
 * @brief 初始化
 * @param doc XML文档指针
 * @result 初始化后的对象
 */
- (id)initWithXMLDoc:(xmlDocPtr)doc;

/*!
 * @brief 初始化
 * @param data 包含XML数据的二进制数据
 * @result 初始化后的对象
 */
- (id)initWithData:(NSData *)data;

/*!
 * @brief 初始化
 * @param filePath 包含XML数据的文件路径
 * @param encoding 文档编码方式
 * @result 初始化后的对象
 */
- (id)initWithFile:(NSString *)filePath;

/*!
 * @brief 将文档元素转换成二进制数据
 * @param encoding 内容编码方式，若为nil，将使用UTF8编码
 * @result 二进制数据
 */
- (NSData *)serializedDataUsingEncoding:(NSString *)encoding;

/*!
 * @brief 将文档元素保存至文件
 * @param filePath 保存路径
 * @param encoding 内容编码方式，若为nil，将使用UTF8编码
 */
- (BOOL)saveToFile:(NSString *)filePath usingEncoding:(NSString *)encoding;

/*!
 * @brief 文档根节点
 */
@property (nonatomic, readonly) xmlDocPtr doc;

/*!
 * @brief 文档根节点
 * @result 文档根节点
 */
- (XMLNodeElement *)rootNode;

/*!
 * @brief 文档编码方式
 * @result 文档编码方式
 */
- (NSString *)stringEncoding;

/*!
 * @brief 文档是否可用
 * @result 文档是否可用
 */
- (BOOL)isDocumentValid;

@end


#pragma mark - XMLNodeElement

/*********************************************************
 
    @class
        XMLNodeElement
 
    @abstract
        XML节点元素
 
 *********************************************************/

@interface XMLNodeElement : XMLElement
{
    // XML节点
    xmlNodePtr _node;
    
    // 编码方式，采用UTF8编码
    NSStringEncoding _encoding;
}

/*!
 * @brief 初始化
 * @param node XML节点
 * @result 初始化后的对象
 */
- (id)initWithXMLNode:(xmlNodePtr)node;

/*!
 * @brief 初始化
 * @param name XML节点名字
 * @result 初始化后的对象
 */
- (id)initWithName:(NSString *)name;

/*!
 * @brief 自身节点
 */
@property (nonatomic, readonly) xmlNodePtr node;

/*!
 * @brief 拷贝节点
 * @param withList 是否连同链一起拷贝，如果YES，将连同子节点一起拷贝，如果NO，仅拷贝属性和命名空间
 * @result 新的节点
 */
- (XMLNodeElement *)copyWithList:(BOOL)withList;

/*!
 * @brief 前一个兄弟节点
 * @result 节点元素，若无返回nil
 */
- (XMLNodeElement *)previousNode;

/*!
 * @brief 后一个兄弟节点
 * @result 节点元素，若无返回nil
 */
- (XMLNodeElement *)nextNode;

/*!
 * @brief 第一个子节点
 * @result 节点元素，若无返回nil
 */
- (XMLNodeElement *)firstChildNode;

/*!
 * @brief 指定名称的子节点集合
 * @param name 节点名称
 * @result 节点集合，若内容为空，返回nil
 */
- (NSArray *)childNodesNamed:(NSString *)name;

/*!
 * @brief 添加前一个兄弟节点
 * @param node 兄弟节点
 */
- (void)addPreviousNode:(XMLNodeElement *)node;

/*!
 * @brief 添加后一个兄弟节点
 * @param node 兄弟节点
 */
- (void)addNextNode:(XMLNodeElement *)node;

/*!
 * @brief 添加子节点
 * @param childNodes 子节点，由XMLNodeElement构成
 */
- (void)addChildNodes:(NSArray *)childNodes;

/*!
 * @brief 添加子节点
 * @param name 子节点名称
 * @param content 子节点文本内容
 * @result 新添加的子节点
 */
- (XMLNodeElement *)addChildNodeWithName:(NSString *)name content:(NSString *)content;

/*!
 * @brief 从文档中解链，移除本节点和文档的关系，本节点将作为独立节点存在
 */
- (void)unlinkFromDoc;

/*!
 * @brief 在本节点的上下文中用新节点替换本节点，本节点自动从上下文中解链，本节点将作为独立节点存在
 * @discussion 若新节点和本节点是同一节点，不执行操作
 */
- (void)replaceByNode:(XMLNodeElement *)node;

/*!
 * @brief 节点名字
 * @result 节点名字
 */
- (NSString *)name;

/*!
 * @brief 编码方式
 * @result 编码方式
 */
- (NSString *)encoding;

/*!
 * @brief 获取属性的值
 * @param name 属性名字
 * @result 属性值
 */
- (NSString *)valueOfAttributeNamed:(NSString *)name;

/*!
 * @brief 设置属性
 * @param name 属性名字
 * @param value 属性值
 */
- (void)setValue:(NSString *)value ofAttributeNamed:(NSString *)name;

/*!
 * @brief 查询是否含有指定名字的属性
 * @param name 属性名字
 * @result 是否含有属性
 */
- (BOOL)hasAttributeNamed:(NSString *)name;

/*!
 * @brief 移除指定名字的属性
 * @param name 属性名字
 */
- (void)removeAttributeNamed:(NSString *)name;

/*!
 * @brief 获取文本内容
 * @result 文本内容
 */
- (NSString *)content;

/*!
 * @brief 设置文本内容
 * @param content 文本内容
 */
- (void)setContent:(NSString *)content;

/*!
 * @brief 移除文本内容
 */
- (void)removeContent;

@end


#pragma mark - XMLXPathElement

/*********************************************************
 
    @class
        XMLXPathElement
 
    @abstract
        XML Path元素
 
 *********************************************************/

@interface XMLXPathElement : XMLElement
{
    // 查询结果集
    xmlXPathObjectPtr _result;
}

/*!
 * @brief 初始化
 * @param doc 文档
 * @param expression 正则表达式
 * @result 初始化后的对象
 */
- (id)initWithDocument:(xmlDocPtr)doc expression:(NSString *)expression;

/*!
 * @brief 查询结果集
 */
@property (nonatomic, readonly) xmlXPathObjectPtr result;

/*!
 * @brief 查询结果集中的节点集合
 * @result 节点集合，由XMLNodeElement对象构成
 */
- (NSArray *)resultNodes;

@end
