//
//  EPubBookContainerHandle.h
//  FoundationProject
//
//  Created by Game_Netease on 13-12-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPubBookInfomation.h"

@class EPubPackage;

/*********************************************************
 
    @class
        EPubBookContainerHandle
 
    @abstract
        EPub书籍包裹句柄，用于承载书籍信息
 
 *********************************************************/

@interface EPubBookContainerHandle : NSObject

/*!
 * @brief 书籍id
 */
@property (nonatomic, copy) NSString *bookId;

/*!
 * @brief 书籍根目录
 */
@property (nonatomic, copy) NSString *directory;

/*!
 * @brief EPub数据包
 */
@property (nonatomic) EPubPackage *package;

/*!
 * @brief 获取书籍目录信息
 * @result 目录信息
 */
- (EPubBookContents *)contents;

/*!
 * @brief 获取指定文档的前一个播放文档
 * @param documentItem 指定文档
 * @result 文档
 */
- (EPubBookDocumentItem *)previousPlayingDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem;

/*!
 * @brief 获取指定文档的后一个播放文档
 * @param documentItem 指定文档
 * @result 文档
 */
- (EPubBookDocumentItem *)nextPlayingDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem;

/*!
 * @brief 获取指定文档的候选文档
 * @param documentItem 指定文档
 * @result 候选文档
 */
- (EPubBookDocumentItem *)fallBackDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem;

@end
