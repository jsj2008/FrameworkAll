//
//  EPub2_NCX.h
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPubXML.h"


/*!
 * EPub2_NCX族
 * 版本号0.0
 *
 * EPub2_NCX族遵循OPF2.0.1标准
 */


#pragma mark - EPub2_NCX

@class EPub2_NCX_Meta, EPub2_NCX_DocTitle, EPub2_NCX_DocAuthor, EPub2_NCX_NavMap;

/*********************************************************
 
    @class
        EPub2_NCX
 
    @abstract
        EPub2的导航信息
 
    @discussion
        NCX文档的pageList和navList两项无实际使用意义，这里忽略
 
 *********************************************************/

@interface EPub2_NCX : NSObject <EPubXMLParsing>

/*!
 * @brief 元信息
 */
@property (nonatomic) EPub2_NCX_Meta *meta;

/*!
 * @brief 标题
 */
@property (nonatomic) EPub2_NCX_DocTitle *title;

/*!
 * @brief 作者
 */
@property (nonatomic) EPub2_NCX_DocAuthor *author;

/*!
 * @brief 导航地图
 */
@property (nonatomic) EPub2_NCX_NavMap *navMap;

@end


#pragma mark - EPub2_NCX_Meta

/*********************************************************
 
    @class
        EPub2_NCX_Meta
 
    @abstract
        EPub2的导航信息的元信息
 
 *********************************************************/

@interface EPub2_NCX_Meta : NSObject <EPubXMLParsing>

/*!
 * @brief 唯一标识id
 * @discussion 本id必须与opf中的identifier匹配
 */
@property (nonatomic, copy) NSString *uid;

/*!
 * @brief 导航深度（嵌套层级）
 * @discussion 本项无实际使用意义，调用者根据导航地图将自动获取实际的导航深度
 */
@property (nonatomic) NSUInteger depth;

/*!
 * @brief 总页数
 * @discussion 只适用于纸质书
 */
@property (nonatomic) NSUInteger totalPageCount;

/*!
 * @brief 最大页数
 * @discussion 只适用于纸质书
 */
@property (nonatomic) NSUInteger maxPageNumber;

@end


#pragma mark - EPub2_NCX_DocTitle

/*********************************************************
 
    @class
        EPub2_NCX_DocTitle
 
    @abstract
        EPub2的导航信息的标题信息
 
 *********************************************************/

@interface EPub2_NCX_DocTitle : NSObject <EPubXMLParsing>

/*!
 * @brief 标题
 */
@property (nonatomic) NSArray *titles;

@end


#pragma mark - EPub2_NCX_DocAuthor

/*********************************************************
 
    @class
        EPub2_NCX_DocAuthor
 
    @abstract
        EPub2的导航信息的作者信息
 
 *********************************************************/

@interface EPub2_NCX_DocAuthor : NSObject <EPubXMLParsing>

/*!
 * @brief 作者
 */
@property (nonatomic) NSArray *authors;

@end


#pragma mark - EPub2_NCX_NavMap

/*********************************************************
 
    @class
        EPub2_NCX_NavMap
 
    @abstract
        EPub2的导航信息的导航地图
 
 *********************************************************/

@interface EPub2_NCX_NavMap : NSObject <EPubXMLParsing>

/*!
 * @brief 导航点
 */
@property (nonatomic) NSArray *navPoints;

@end


#pragma mark - EPub2_NCX_NavPoint

@class EPub2_NCX_NavPoint_Label;

/*********************************************************
 
    @class
        EPub2_NCX_NavPoint
 
    @abstract
        EPub2的导航信息的导航点
 
 *********************************************************/

@interface EPub2_NCX_NavPoint : NSObject <EPubXMLParsing>

/*!
 * @brief id
 */
@property (nonatomic, copy) NSString *pointId;

/*!
 * @brief 等级
 */
@property (nonatomic, copy) NSString *pointClass;

/*!
 * @brief 播放序号
 * @discussion 一般情况下本属性应当被忽略
 */
@property (nonatomic) NSUInteger playOrder;

/*!
 * @brief 标签
 */
@property (nonatomic) EPub2_NCX_NavPoint_Label *label;

/*!
 * @brief 内容链接（支持锚点）
 */
@property (nonatomic, copy) NSString *contentHref;

/*!
 * @brief 子导航点
 */
@property (nonatomic) NSArray *navPoints;

@end


#pragma mark - EPub2_NCX_NavPoint_Label

/*********************************************************
 
    @class
        EPub2_NCX_NavPoint_Label
 
    @abstract
        EPub2的导航信息的导航点标签
 
 *********************************************************/

@interface EPub2_NCX_NavPoint_Label : NSObject <EPubXMLParsing>

/*!
 * @brief 标签
 */
@property (nonatomic) NSArray *labels;

@end
