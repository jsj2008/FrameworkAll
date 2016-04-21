//
//  EPub.h
//  FoundationProject
//
//  Created by user on 13-12-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPub2_Package.h"

#pragma mark - EPubPackage

@class EPubMeta, EPubDocument, EPubPlayList, EPubNavigation, EPubGuide;

/*********************************************************
 
    @class
        EPubPackage
 
    @abstract
        EPub书籍包，承载书籍的所有数据信息
 
 *********************************************************/

@interface EPubPackage : NSObject

/*!
 * @brief 元信息
 */
@property (nonatomic) EPubMeta *meta;

/*!
 * @brief 文档数据
 */
@property (nonatomic) EPubDocument *document;

/*!
 * @brief 播放列表
 */
@property (nonatomic) EPubPlayList *playList;

/*!
 * @brief 导航
 */
@property (nonatomic) EPubNavigation *navigation;

/*!
 * @brief 导引
 */
@property (nonatomic) EPubGuide *guide;

/*!
 * @brief 初始化
 * @discussion 初始化过程中将更新各个属性
 * @param package EPub2包
 * @result 初始化后的对象
 */
- (id)initWithEPub2Package:(EPub2_Package *)package;

/*!
 * @brief 初始化
 * @discussion 初始化过程中，将解析部分必须的文件，生成文档信息
 * @param directory EPub文档所在的根目录
 * @result 初始化后的对象
 */
- (id)initWithEPubDirectory:(NSString *)directory;

@end


#pragma mark - EPubMeta

/*********************************************************
 
    @class
        EPubMeta
 
    @abstract
        EPub书籍的元信息，承载书籍的基本信息
 
    @discussion
        EPubMeta的数组属性均由NSString对象构成
 
 *********************************************************/

@interface EPubMeta : NSObject

/*!
 * @brief 标题
 */
@property (nonatomic) NSArray *titles;

/*!
 * @brief 作者
 */
@property (nonatomic) NSArray *authors;

/*!
 * @brief 主题词
 */
@property (nonatomic) NSArray *subjects;

/*!
 * @brief 描述
 */
@property (nonatomic, copy) NSString *bookDescription;

/*!
 * @brief 出版方
 */
@property (nonatomic) NSArray *publishers;

/*!
 * @brief 创建日期
 */
@property (nonatomic) NSDate *creationDate;

/*!
 * @brief 出版日期
 */
@property (nonatomic) NSDate *publicationDate;

/*!
 * @brief 类型
 */
@property (nonatomic) NSArray *types;

/*!
 * @brief 媒体类型
 */
@property (nonatomic) NSArray *formats;

/*!
 * @brief 标识符
 */
@property (nonatomic, copy) NSString *identifier;

/*!
 * @brief 语言
 */
@property (nonatomic) NSArray *languages;

/*!
 * @brief 覆盖范围
 */
@property (nonatomic) NSArray *coverages;

/*!
 * @brief 版权
 */
@property (nonatomic) NSArray *rights;

@end


#pragma mark - EPubDocument

/*********************************************************
 
    @class
        EPubDocument
 
    @abstract
        EPub书籍的文档信息，承载书籍文件的基本信息
 
 *********************************************************/

@class EPubDocumentItem;

@interface EPubDocument : NSObject

/*!
 * @brief 文档条目
 * @discussion 字典键为条目id
 */
@property (nonatomic) NSDictionary *documents;

/*!
 * @brief 获取指定路径的文档
 * @param path 文档路径
 * @result 文档条目
 */
- (EPubDocumentItem *)itemPathed:(NSString *)path;

@end


/*********************************************************
 
    @class
        EPubDocumentItem
 
    @abstract
        EPub书籍的文档信息条目
 
 *********************************************************/

@interface EPubDocumentItem : NSObject

/*!
 * @brief 条目id
 */
@property (nonatomic, copy) NSString *itemId;

/*!
 * @brief 在清单中对应的文档条目相对路径（已经合并OEBPS目录）
 */
@property (nonatomic, copy) NSString *path;

/*!
 * @brief 媒体类型
 */
@property (nonatomic, copy) NSString *mediaType;

/*!
 * @brief 候选条目id
 */
@property (nonatomic, copy) NSString *fallBackId;

@end


#pragma mark - EPubPlayList

/*********************************************************
 
    @class
        EPubPlayList
 
    @abstract
        EPub书籍的播放列表
 
 *********************************************************/

@interface EPubPlayList : NSObject

/*!
 * @brief 播放列表条目id
 */
@property (nonatomic) NSArray *itemIds;

@end


#pragma mark - EPubNavigation

/*********************************************************
 
    @class
        EPubNavigation
 
    @abstract
        EPub书籍的导航信息，可用作目录
 
 *********************************************************/

@interface EPubNavigation : NSObject

/*!
 * @brief 标题
 */
@property (nonatomic) NSArray *titles;

/*!
 * @brief 作者
 */
@property (nonatomic) NSArray *authors;

/*!
 * @brief 导航条目
 */
@property (nonatomic) NSArray *items;

@end


/*********************************************************
 
    @class
        EPubNavigationItem
 
    @abstract
        EPub书籍的导航条目
 
    @discussion
        层级从1开始计算
 
 *********************************************************/

@interface EPubNavigationItem : NSObject

/*!
 * @brief 条目id
 */
@property (nonatomic ,copy) NSString *itemId;

/*!
 * @brief 名字
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 在清单中对应的文档条目相对路径（已经合并OEBPS目录）
 */
@property (nonatomic, copy) NSString *path;

/*!
 * @brief 锚点
 */
@property (nonatomic, copy) NSString *anchor;

/*!
 * @brief 层级
 */
@property (nonatomic) NSUInteger level;

/*!
 * @brief 子条目
 */
@property (nonatomic) NSArray *items;

@end


#pragma mark - EPubGuide

/*********************************************************
 
    @class
        EPubGuide
 
    @abstract
        EPub书籍的导引
 
 *********************************************************/

@interface EPubGuide : NSObject

/*!
 * @brief 导引条目
 */
@property (nonatomic) NSArray *items;

@end


/*********************************************************
 
    @class
        EPubGuideItem
 
    @abstract
        EPub书籍的导引条目
 
 *********************************************************/

@interface EPubGuideItem : NSObject

/*!
 * @brief 类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 * @brief 标题
 */
@property (nonatomic, copy) NSString *title;

/*!
 * @brief 在清单中对应的文档条目相对路径（已经合并OEBPS目录）
 */
@property (nonatomic, copy) NSString *path;

/*!
 * @brief 锚点
 */
@property (nonatomic ,copy) NSString *anchor;

@end
