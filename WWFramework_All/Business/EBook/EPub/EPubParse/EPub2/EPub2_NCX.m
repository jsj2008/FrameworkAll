//
//  EPub2_NCX.m
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPub2_NCX.h"

#pragma mark - EPub2_NCX

@implementation EPub2_NCX

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"head"))
            {
                self.meta = [[EPub2_NCX_Meta alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"docTitle"))
            {
                self.title = [[EPub2_NCX_DocTitle alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"docAuthor"))
            {
                self.author = [[EPub2_NCX_DocAuthor alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"navMap"))
            {
                self.navMap = [[EPub2_NCX_NavMap alloc] initWithXMLNode:node1];
            }
            
            node1 = node1->children;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_Meta

@implementation EPub2_NCX_Meta

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"meta"))
            {
                NSString *name = nil;
                
                NSString *content = nil;
                
                xmlAttrPtr attribute = node1->properties;
                
                while (attribute)
                {
                    if (!xmlStrcmp(attribute->name, BAD_CAST"name"))
                    {
                        name = [NSString stringWithEPubXMLChar:attribute->children->content];
                    }
                    else if (!xmlStrcmp(attribute->name, BAD_CAST"content"))
                    {
                        content = [NSString stringWithEPubXMLChar:attribute->children->content];
                    }
                    
                    attribute = attribute->next;
                }
                
                if (name && [name rangeOfString:@"uid"].location != NSNotFound)
                {
                    self.uid = content;
                }
                else if (name && [name rangeOfString:@"depth"].location != NSNotFound)
                {
                    self.depth = [content intValue];
                }
                else if (name && [name rangeOfString:@"totalPageCount"].location != NSNotFound)
                {
                    self.totalPageCount = [content intValue];
                }
                else if (name && [name rangeOfString:@"maxPageNumber"].location != NSNotFound)
                {
                    self.maxPageNumber = [content intValue];
                }
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_DocTitle

@implementation EPub2_NCX_DocTitle

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"text"))
            {
                if (!self.titles)
                {
                    self.titles = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.titles) addObject:[EPubXMLUtility contentOfNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_DocAuthor

@implementation EPub2_NCX_DocAuthor

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"text"))
            {
                if (!self.authors)
                {
                    self.authors = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.authors) addObject:[EPubXMLUtility contentOfNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_NavMap

@implementation EPub2_NCX_NavMap

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"navPoint"))
            {
                if (!self.navPoints)
                {
                    self.navPoints = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.navPoints) addObject:[[EPub2_NCX_NavPoint alloc] initWithXMLNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_NavPoint

@implementation EPub2_NCX_NavPoint

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.pointId = [EPubXMLUtility valueOfPropertyNamed:@"id" forNode:node];
        
        self.pointClass = [EPubXMLUtility valueOfPropertyNamed:@"class" forNode:node];
        
        self.playOrder = [[EPubXMLUtility valueOfPropertyNamed:@"playOrder" forNode:node] intValue];
        
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"navLabel"))
            {
                self.label = [[EPub2_NCX_NavPoint_Label alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"content"))
            {
                self.contentHref = [EPubXMLUtility valueOfPropertyNamed:@"src" forNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"navPoint"))
            {
                if (!self.navPoints)
                {
                    self.navPoints = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.navPoints) addObject:[[EPub2_NCX_NavPoint alloc] initWithXMLNode:node1]];
            }
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_NCX_NavPoint_Label

@implementation EPub2_NCX_NavPoint_Label

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"text"))
            {
                if (!self.labels)
                {
                    self.labels = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.labels) addObject:[EPubXMLUtility contentOfNode:node1]];
            }
        }
    }
    
    return self;
}

@end
