//
//  XMLSprite.h
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml2/libxml/tree.h>


/*!
 * XMLSprite族
 * 版本号0.0
 *
 * XMLSprite族是对XML数据的封装，按照XML树形结构设置了文档和节点等数据对象来描述XML文档内容
 *
 * 关于编码，XMLSprite族内部使用UTF8编码，忽略文档信息中指定的编码，因此在使用XMLSprite族前，请先将文档转换成UTF8编码（保存文档时除外）
 *
 * 处理XML时，做了简化，忽略了命名空间，在后续版本可以扩展
 *
 * XMLSprite支持对CDATA数据的解析和构建
 *
 * XMLSprite做了扩展，支持和Json对象之间的互相转换（通过XMLSpriteConvertingToJson和XMLSpriteConvertingFromJson两个协议实现）
 */




#pragma mark - XMLSpriteConvertingToJson

/*********************************************************
 
    @protocol
        XMLSpriteConvertingToJson
 
    @abstract
        XMLSprite类对象转换成Json数据对象的协议
 
 *********************************************************/

@protocol XMLSpriteConvertingToJson <NSObject>

/*!
 * @brief 将对象转换成json节点
 * @result json节点，可以是NSDictionary或NSString对象
 */
- (id)jsonNode;

@end


#pragma mark - XMLSpriteConvertingFromJson

/*********************************************************
 
    @protocol
        XMLSpriteConvertingFromJson
 
    @abstract
        Json数据对象转换成XMLSprite类对象的协议
 
 *********************************************************/

@protocol XMLSpriteConvertingFromJson <NSObject>

/*!
 * @brief 初始化
 * @param jsonNode json节点，可以是NSDictionary，NSString或NSNumber对象
 * @result 初始化后的对象
 */
- (id)initWithJsonNode:(id)jsonNode;

@end


#pragma mark - XMLSprite

/*********************************************************
 
    @class
        XMLSprite
 
    @abstract
        XML精灵对象，实现XML数据的封装及其处理
 
 *********************************************************/

@interface XMLSprite : NSObject

@end


#pragma mark - XMLDocumentSprite

@class XMLNodeSprite;

/*********************************************************
 
    @class
        XMLDocumentSprite
 
    @abstract
        XML文档精灵
 
    @discussion
        XMLDocumentSprite的XMLSpriteConvertingToJson和XMLSpriteConvertingFromJson协议只生成根节点的数据，默认XML版本号是1.0，默认生成的根节点名字是root
 
 *********************************************************/

@interface XMLDocumentSprite : XMLSprite  <XMLSpriteConvertingToJson, XMLSpriteConvertingFromJson>

/*!
 * @brief XML版本号
 */
@property (nonatomic, copy) NSString *XMLVersion;

/*!
 * @brief XML根节点
 */
@property (nonatomic) XMLNodeSprite *rootNode;

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

@end


@class XMLContentSprite;

#pragma mark - XMLNodeSprite

/*********************************************************
 
    @class
        XMLNodeSprite
 
    @abstract
        XML节点精灵
 
    @discussion
        XMLSpriteConvertingToJson协议的实现中，若节点包含文本内容，将生成一对key/value值，忽略其它子节点，若不含文本内容，将生成一个json字典节点
 
 *********************************************************/

@interface XMLNodeSprite : XMLSprite  <XMLSpriteConvertingToJson, XMLSpriteConvertingFromJson>
{
    // 属性
    NSMutableDictionary *_properties;
    
    // 子节点
    NSMutableArray *_childNodes;
}

/*!
 * @brief 创建LibXML节点
 * @result LibXML节点
 */
- (xmlNodePtr)createLibXMLNode;

/*!
 * @brief 初始化
 * @param node LibXML节点
 * @result 初始化后的对象
 */
- (id)initWithLibXMLNode:(xmlNodePtr)node;

/*!
 * @brief 节点名字
 */
@property (nonatomic, copy) NSString *nodeName;

/*!
 * @brief 父节点
 */
@property (nonatomic, weak) XMLNodeSprite *parentNode;

/*!
 * @brief 拷贝节点
 * @param withList 是否连同链一起拷贝，如果YES，将连同子节点一起拷贝，如果NO，仅拷贝属性和命名空间
 * @result 新的节点
 */
- (XMLNodeSprite *)copyWithList:(BOOL)withList;

/*!
 * @brief 前一个兄弟节点
 * @result 节点精灵，若无返回nil
 */
- (XMLNodeSprite *)previousNode;

/*!
 * @brief 后一个兄弟节点
 * @result 节点精灵，若无返回nil
 */
- (XMLNodeSprite *)nextNode;

/*!
 * @brief 第index个子节点
 * @result 节点精灵，若无返回nil
 */
- (XMLNodeSprite *)childNodeAtIndex:(NSUInteger)index;

/*!
 * @brief 查询子节点的位置
 * @param node 待查询子节点
 * @result 位置。若子节点集合中不包含待查询子节点，返回-1
 */
- (NSInteger)indexOfChildNode:(XMLNodeSprite *)node;

/*!
 * @brief 查询所有子节点
 * @result 节点集合，若集合为空，返回nil
 */
- (NSArray *)allChildNodes;

/*!
 * @brief 查询所有指定名称的子节点
 * @param name 子节点名称
 * @result 节点集合，若集合为空，返回nil
 */
- (NSArray *)allChildNodesNamed:(NSString *)name;

/*!
 * @brief 查询指定名称的子节点中的第一个
 * @param name 子节点名称
 * @result 节点
 */
- (XMLNodeSprite *)firstChildNodeNamed:(NSString *)name;

/*!
 * @brief 查询指定名称的子节点中的最后一个
 * @param name 子节点名称
 * @result 节点
 */
- (XMLNodeSprite *)lastChildNodeNamed:(NSString *)name;

/*!
 * @brief 在原子节点后添加子节点
 * @param childNodes 待添加的子节点
 */
- (void)addChildNodes:(NSArray *)childNodes;

/*!
 * @brief 在指定位置添加子节点
 * @discussion 该位置的原子节点向后移动一个位置，若添加位置超过原子节点总数，将作为最后一个子节点添加
 * @param childNode 子节点
 * @param index 位置索引
 */
- (void)addChildNode:(XMLNodeSprite *)childNode atIndex:(NSUInteger)index;

/*!
 * @brief 移除子节点
 * @param childNodes 待移除的子节点
 */
- (void)removeChildNodes:(NSArray *)childNodes;

/*!
 * @brief 替换节点
 * @discussion 若被替换的子节点位置超过原子节点总数，将不执行操作
 * @param index 待替换子节点的位置
 * @param newNode 新子节点
 */
- (void)replaceChildNodeAtIndex:(NSUInteger)index byNewNode:(XMLNodeSprite *)newNode;

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
 * @brief 设置属性
 * @param attributes 属性字典
 */
- (void)setAttributesDictionary:(NSDictionary *)attributes;

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
 * @brief 获取内容
 * @result 内容
 */
- (XMLContentSprite *)content;

/*!
 * @brief 设置内容
 * @discussion 设置内容将清空所有子节点
 * @param content 内容
 */
- (void)setContent:(XMLContentSprite *)content;

/*!
 * @brief 移除文本内容
 */
- (void)removeContent;

@end


/*********************************************************
 
    @category
        XMLNodeSprite (Shortcut)
 
    @abstract
        XML节点精灵的快捷函数
 
 *********************************************************/

@interface XMLNodeSprite (Shortcut)

/*!
 * @brief 设置文本型内容
 * @discussion 设置内容将清空所有子节点
 * @param content 文本内容
 */
- (void)setTextContent:(NSString *)content;

@end


#pragma mark - XMLContentSprite

/*********************************************************
 
    @class
        XMLContentSprite
 
    @abstract
        XML内容精灵
 
 *********************************************************/

@interface XMLContentSprite : NSObject

/*!
 * @brief 内容
 */
@property (nonatomic, copy) NSString *content;

@end


/*********************************************************
 
    @class
        XMLContentSprite
 
    @abstract
        XML文本型内容精灵
 
 *********************************************************/

@interface XMLTextContentSprite : XMLContentSprite

@end


/*********************************************************
 
    @class
        XMLContentSprite
 
    @abstract
        XML CData型内容精灵
 
 *********************************************************/

@interface XMLCDataContentSprite : XMLContentSprite

@end


#pragma mark - XMLNodeSpriteSearchContext

/*********************************************************
 
    @class
        XMLNodeSpriteSearchContext
 
    @abstract
        XML节点搜索上下文
 
    @discussion
        XML节点搜索是用来替代XPath的方法，但搜索功能有限，仅能查询当前节点下拥有指定名字，属性和文本内容的子节点
 
 *********************************************************/

@interface XMLNodeSpriteSearchContext : NSObject

/*!
 * @brief 节点名字
 */
@property (nonatomic, copy) NSString *nodeName;

/*!
 * @brief 节点属性
 */
@property (nonatomic) NSDictionary *nodeProperties;

/*!
 * @brief 节点内容，包括文本内容和CDATA内容
 */
@property (nonatomic, copy) NSString *nodeContent;

@end


#pragma mark - XMLDocumentSprite (Search)

/*********************************************************
 
    @category
        XMLDocumentSprite (Search)
 
    @abstract
        XMLDocumentSprite的扩展，用于处理在当前文档下搜索符合特定条件的子孙节点
 
 *********************************************************/

@interface XMLDocumentSprite (Search)

/*!
 * @brief 搜索符合特定条件的子孙节点
 * @param context 搜索条件
 * @result 符合条件的子孙节点，若搜索结果为空，返回nil
 */
- (NSArray *)subNodesSearchedWithContext:(XMLNodeSpriteSearchContext *)context;

@end


#pragma mark - XMLNodeSprite (Search)

/*********************************************************
 
    @category
        XMLNodeSprite (Search)
 
    @abstract
        XMLNodeSprite的扩展，用于处理在当前节点下搜索符合特定条件的子孙节点
 
 *********************************************************/

@interface XMLNodeSprite (Search)

/*!
 * @brief 搜索符合特定条件的子孙节点
 * @param context 搜索条件
 * @param including 节点自身是否也需要进行匹配
 * @result 符合条件的子孙节点，若搜索结果为空，返回nil
 */
- (NSArray *)subNodesSearchedWithContext:(XMLNodeSpriteSearchContext *)context includingSelfNode:(BOOL)including;

@end
