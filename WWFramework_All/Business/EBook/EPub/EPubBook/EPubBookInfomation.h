//
//  EPubBookInfomation.h
//  FoundationProject
//
//  Created by Game_Netease on 13-12-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - EPubBookDocumentItem

/*********************************************************
 
    @class
        EPubBookDocumentItem
 
    @abstract
        EPub书籍文档条目
 
 *********************************************************/

@interface EPubBookDocumentItem : NSObject

/*!
 * @brief 条目id
 */
@property (nonatomic, copy) NSString *itemId;

/*!
 * @brief 文档全路径
 */
@property (nonatomic, copy) NSString *contentLink;

/*!
 * @brief 媒体类型
 */
@property (nonatomic, copy) NSString *mediaType;

@end


#pragma mark - EPubBookContentNode

/*********************************************************
 
    @class
        EPubBookContentNode
 
    @abstract
        EPub书籍目录节点，用于指向目录中的文档章节
 
 *********************************************************/

@interface EPubBookContentNode : NSObject

/*!
 * @brief 节点id
 */
@property (nonatomic, copy) NSString *nodeId;

/*!
 * @brief 名字
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 文档
 */
@property (nonatomic) EPubBookDocumentItem *documentItem;

/*!
 * @brief 目录层级
 */
@property (nonatomic) NSUInteger level;

/*!
 * @brief 锚点
 */
@property (nonatomic, copy) NSString *anchor;

/*!
 * @brief 子节点
 * @discussion 子节点由EPubBookContentNode构成
 */
@property (nonatomic) NSArray *nodes;

@end


#pragma mark - EPubBookContents

/*********************************************************
 
    @class
        EPubBookContents
 
    @abstract
        EPub书籍目录
 
 *********************************************************/

@interface EPubBookContents : NSObject

/*!
 * @brief 标题
 */
@property (nonatomic) NSArray *titles;

/*!
 * @brief 作者
 */
@property (nonatomic) NSArray *authors;

/*!
 * @brief 目录节点（顺序）
 * @discussion 子节点由EPubBookContentNode构成
 */
@property (nonatomic) NSArray *nodes;

@end
