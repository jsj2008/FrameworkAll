//
//  EPub2_OPF.h
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPubXML.h"


/*!
 * EPub2_OPF族
 * 版本号0.0
 *
 * EPub2_OPF族遵循OPF2.0.1标准，定义了EPub档案结构
 */


#pragma mark - EPub2_OPF

@class EPub2_OPF_Metadata, EPub2_OPF_Manifest, EPub2_OPF_Spine, EPub2_OPF_Guide;

/*********************************************************
 
    @class
        EPub2_OPF
 
    @abstract
        EPub2的包裹信息
 
 *********************************************************/

@interface EPub2_OPF : NSObject <EPubXMLParsing>

/*!
 * @brief 元数据
 */
@property (nonatomic) EPub2_OPF_Metadata *metadata;

/*!
 * @brief 文件清单
 */
@property (nonatomic) EPub2_OPF_Manifest *manifest;

/*!
 * @brief 书脊目录
 */
@property (nonatomic) EPub2_OPF_Spine *spine;

/*!
 * @brief 导引
 */
@property (nonatomic) EPub2_OPF_Guide *guide;

@end


#pragma mark - EPub2_OPF_Metadata

/*********************************************************
 
    @class
        EPub2_OPF_Metadata
 
    @abstract
        EPub2的OPF的元数据
 
    @discussion
        EPub2_OPF_Metadata的数组属性均由对应名字的EPub2_OPF_Metadata_XX对象构成
 
 *********************************************************/

@interface EPub2_OPF_Metadata : NSObject <EPubXMLParsing>

/*!
 * @brief 标题
 */
@property (nonatomic) NSArray *titles;

/*!
 * @brief 创建者
 */
@property (nonatomic) NSArray *creators;

/*!
 * @brief 主题词
 */
@property (nonatomic) NSArray *subjects;

/*!
 * @brief 描述
 */
@property (nonatomic) NSArray *descriptions;

/*!
 * @brief 出版方
 */
@property (nonatomic) NSArray *publishers;

/*!
 * @brief 贡献者
 */
@property (nonatomic) NSArray *contributors;

/*!
 * @brief 日期
 */
@property (nonatomic) NSArray *dates;

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
@property (nonatomic) NSArray *identifiers;

/*!
 * @brief 来源
 */
@property (nonatomic) NSArray *sources;

/*!
 * @brief 语言
 */
@property (nonatomic) NSArray *languages;

/*!
 * @brief 相关信息
 */
@property (nonatomic) NSArray *relations;

/*!
 * @brief 覆盖范围
 */
@property (nonatomic) NSArray *coverages;

/*!
 * @brief 版权
 */
@property (nonatomic) NSArray *rights;

/*!
 * @brief 扩展数据
 */
@property (nonatomic) NSArray *extensions;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Title
 
    @abstract
        EPub2的OPF的元数据的标题
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Title : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *title;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Creator
 
    @abstract
        EPub2的OPF的元数据的创建者
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Creator : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *creator;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *fileAs;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Subject
 
    @abstract
        EPub2的OPF的元数据的主题词
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Subject : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *keyword;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Description
 
    @abstract
        EPub2的OPF的元数据的内容描述
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Description : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *metadataDescription;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Publisher
 
    @abstract
        EPub2的OPF的元数据的出版方
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Publisher : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *publisher;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Contributor
 
    @abstract
        EPub2的OPF的元数据的贡献者
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Contributor : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *contributor;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *fileAs;

@end


/*********************************************************
 
    @enum
        EPub2_OPF_Metadata_Date_Event
 
    @abstract
        EPub2_OPF_Metadata_Date的事件类型
 
 *********************************************************/

typedef enum
{
    EPub2_OPF_Metadata_Date_Event_None         = 0,
    EPub2_OPF_Metadata_Date_Event_Creation     = 1,
    EPub2_OPF_Metadata_Date_Event_Publication  = 2,
    EPub2_OPF_Metadata_Date_Event_Modification = 3
}EPub2_OPF_Metadata_Date_Event;


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Date
 
    @abstract
        EPub2的OPF的元数据的日期
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Date : NSObject <EPubXMLParsing>

@property (nonatomic) NSDate *date;

@property (nonatomic) EPub2_OPF_Metadata_Date_Event event;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Type
 
    @abstract
        EPub2的OPF的元数据的类型
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Type : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *type;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Format
 
    @abstract
        EPub2的OPF的元数据的格式
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Format : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *format;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Identifier
 
    @abstract
        EPub2的OPF的元数据的标识符
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Identifier : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *identifierId;

@property (nonatomic, copy) NSString *scheme;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Source
 
    @abstract
        EPub2的OPF的元数据的来源
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Source : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *source;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Language
 
    @abstract
        EPub2的OPF的元数据的语言
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Language : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *language;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Relation
 
    @abstract
        EPub2的OPF的元数据的相关信息
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Relation : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *relation;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Coverage
 
    @abstract
        EPub2的OPF的元数据的覆盖范围
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Coverage : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *coverage;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_CopyRight
 
    @abstract
        EPub2的OPF的元数据的版权
 
 *********************************************************/

@interface EPub2_OPF_Metadata_CopyRight : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *right;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Metadata_Extension
 
    @abstract
        EPub2的OPF的元数据的额外项
 
 *********************************************************/

@interface EPub2_OPF_Metadata_Extension : NSObject <EPubXMLParsing>

@property (nonatomic, copy) NSString *content;

@property (nonatomic) NSDictionary *properties;

@end


#pragma mark - EPub2_OPF_Manifest

/*********************************************************
 
    @class
        EPub2_OPF_Manifest
 
    @abstract
        EPub2的OPF的文件清单
 
 *********************************************************/

@interface EPub2_OPF_Manifest : NSObject <EPubXMLParsing>

@property (nonatomic) NSDictionary *items;

@end


/*********************************************************
 
    @class
        EPub2_OPF_ManifestItem
 
    @abstract
        EPub2的OPF的文件清单条目
 
 *********************************************************/

@class EPub2_OPF_ManifestItem_FallBack;

@interface EPub2_OPF_ManifestItem : NSObject <EPubXMLParsing>

/*!
 * @brief 文件id
 */
@property (nonatomic, copy) NSString *itemId;

/*!
 * @brief 文件相对路径
 */
@property (nonatomic, copy) NSString *relativeHref;

/*!
 * @brief 文件媒体类型
 */
@property (nonatomic, copy) NSString *mediaType;

/*!
 * @brief 候选项
 */
@property (nonatomic, copy) EPub2_OPF_ManifestItem_FallBack *fallBack;

@end


/*********************************************************
 
    @class
        EPub2_OPF_ManifestItem_FallBack
 
    @abstract
        EPub2的OPF的文件清单条目的候选项
 
 *********************************************************/

@interface EPub2_OPF_ManifestItem_FallBack : NSObject

/*!
 * @brief 候选项id
 */
@property (nonatomic, copy) NSString *fallBackItemId;

/*!
 * @brief 候选项id（针对CSS条目）
 */
@property (nonatomic, copy) NSString *fallBackStyleItemId;

/*!
 * @brief XML岛命名空间
 */
@property (nonatomic, copy) NSString *requiredNameSpace;

/*!
 * @brief XML岛模块名字，总是跟随requiredNameSpace一起出现
 */
@property (nonatomic, copy) NSString *requiredModules;

@end


#pragma mark - EPub2_OPF_Spine

/*********************************************************
 
    @class
        EPub2_OPF_Spine
 
    @abstract
        EPub2的OPF的书脊
 
 *********************************************************/

@interface EPub2_OPF_Spine : NSObject <EPubXMLParsing>

/*!
 * @brief 书脊使用的NCX文档在清单中的id
 */
@property (nonatomic, copy) NSString *NCXId;

/*!
 * @brief 书脊条目
 */
@property (nonatomic) NSArray *items;

@end


/*********************************************************
 
    @class
        EPub2_OPF_SpineItem
 
    @abstract
        EPub2的OPF的书脊条目
 
 *********************************************************/
@interface EPub2_OPF_SpineItem : NSObject <EPubXMLParsing>

/*!
 * @brief 书脊条目在清单中的id
 */
@property (nonatomic, copy) NSString *itemId;

/*!
 * @brief 是否为主要文件
 * @discussion YES表征主要文件，NO表征辅助文件，默认为YES。一般情况下本属性应当被忽略
 */
@property (nonatomic) BOOL linear;

@end


#pragma mark - EPub2_OPF_Guide

/*********************************************************
 
    @class
        EPub2_OPF_Guide
 
    @abstract
        EPub2的OPF的导引
 
 *********************************************************/

@interface EPub2_OPF_Guide : NSObject <EPubXMLParsing>

/*!
 * @brief 参考条目
 */
@property (nonatomic) NSArray *references;

@end


/*********************************************************
 
    @class
        EPub2_OPF_Guide_Reference
 
    @abstract
        EPub2的OPF的导引的参考条目
 
 *********************************************************/

@interface EPub2_OPF_Guide_Reference : NSObject <EPubXMLParsing>

/*!
 * @brief 类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 * @brief 标题
 */
@property (nonatomic, copy) NSString *title;

/*!
 * @brief 在清单中对应的文档条目路径（可以附带锚点）
 */
@property (nonatomic, copy) NSString *href;

@end
