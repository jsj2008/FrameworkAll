//
//  EPubBookContainerHandle.m
//  FoundationProject
//
//  Created by Game_Netease on 13-12-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPubBookContainerHandle.h"
#import "EPub.h"

@interface EPubBookContainerHandle (Convertion)

/*!
 * @brief 将导航信息转换成目录信息
 * @param item 导航条目
 * @result 目录节点
 */
- (EPubBookContentNode *)contentNodeFromEPubNavigationItem:(EPubNavigationItem *)item;

/*!
 * @brief 将EPub包中的文档信息转换成实际可用的文档信息
 * @param item EPub包中的文档信息
 * @result 处理后的文档信息
 */
- (EPubBookDocumentItem *)bookDocumentItemFromEPubDocumentItem:(EPubDocumentItem *)item;

@end


@implementation EPubBookContainerHandle

- (EPubBookContents *)contents
{
    EPubBookContents *contents = nil;
    
    if (self.package.navigation)
    {
        contents = [[EPubBookContents alloc] init];
        
        contents.titles = self.package.navigation.titles;
        
        contents.authors = self.package.navigation.authors;
        
        NSMutableArray *nodes = [NSMutableArray array];
        
        for (EPubNavigationItem *item in self.package.navigation.items)
        {
            EPubBookContentNode *node = [self contentNodeFromEPubNavigationItem:item];
            
            [nodes addObject:node];
        }
        
        contents.nodes = [nodes count] ? nodes : nil;
    }
    
    return contents;
}

- (EPubBookDocumentItem *)previousPlayingDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem
{
    EPubBookDocumentItem *previousDocumentItem = nil;
    
    NSUInteger currentIndex = [self.package.playList.itemIds indexOfObject:documentItem.itemId];
    
    if (currentIndex > 0)
    {
        previousDocumentItem = [self bookDocumentItemFromEPubDocumentItem:[self.package.document.documents objectForKey:[self.package.playList.itemIds objectAtIndex:(currentIndex - 1)]]];
    }
    
    return previousDocumentItem;
}

- (EPubBookDocumentItem *)nextPlayingDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem
{
    EPubBookDocumentItem *nextDocumentItem = nil;
    
    NSUInteger currentIndex = [self.package.playList.itemIds indexOfObject:documentItem.itemId];
    
    if (currentIndex < ([self.package.playList.itemIds count] - 1))
    {
        nextDocumentItem = [self bookDocumentItemFromEPubDocumentItem:[self.package.document.documents objectForKey:[self.package.playList.itemIds objectAtIndex:(currentIndex - 1)]]];
    }
    
    return nextDocumentItem;
}

- (EPubBookDocumentItem *)fallBackDocumentItemOfCurrentDocumentItem:(EPubBookDocumentItem *)documentItem
{
    EPubBookDocumentItem *fallBackDocumentItem = nil;
    
    if ([self.package.document.documents count])
    {
        EPubDocumentItem *item = [self.package.document.documents objectForKey:documentItem.itemId];
        
        if (item.fallBackId)
        {
            fallBackDocumentItem = [self bookDocumentItemFromEPubDocumentItem:[self.package.document.documents objectForKey:item.fallBackId]];
        }
    }
    
    return fallBackDocumentItem;
}

@end


@implementation EPubBookContainerHandle (Convertion)

- (EPubBookContentNode *)contentNodeFromEPubNavigationItem:(EPubNavigationItem *)item
{
    EPubBookContentNode *contentNode = [[EPubBookContentNode alloc] init];
    
    contentNode.nodeId = item.itemId;
    
    contentNode.name = item.name;
    
    contentNode.level = item.level;
    
    EPubDocumentItem *documentItem = [self.package.document itemPathed:item.path];
    
    contentNode.documentItem = [self bookDocumentItemFromEPubDocumentItem:documentItem];
    
    contentNode.anchor = item.anchor;
    
    NSMutableArray *subNodes = [NSMutableArray array];
    
    for (EPubNavigationItem *subItem in item.items)
    {
        EPubBookContentNode *subNode = [self contentNodeFromEPubNavigationItem:subItem];
        
        if (subNode)
        {
            [subNodes addObject:subNode];
        }
    }
    
    contentNode.nodes = [subNodes count] ? subNodes : nil;
    
    return contentNode;
}

- (EPubBookDocumentItem *)bookDocumentItemFromEPubDocumentItem:(EPubDocumentItem *)item
{
    EPubBookDocumentItem *bookItem = nil;
    
    if (item)
    {
        bookItem = [[EPubBookDocumentItem alloc] init];
        
        bookItem.itemId = item.itemId;
        
        if (item.path)
        {
            NSString *contentPath = self.directory ? [self.directory stringByAppendingPathComponent:item.path] : nil;
            
            if (contentPath)
            {
                bookItem.contentLink = contentPath;
            }
        }
        
        bookItem.mediaType = item.mediaType;
    }
    
    return bookItem;
}

@end
