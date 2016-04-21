//
//  EPub2_OPF.m
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPub2_OPF.h"

#pragma mark - EPub2_OPF

@implementation EPub2_OPF

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"metadata"))
            {
                self.metadata = [[EPub2_OPF_Metadata alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"manifest"))
            {
                self.manifest = [[EPub2_OPF_Manifest alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"spine"))
            {
                self.spine = [[EPub2_OPF_Spine alloc] initWithXMLNode:node1];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"guide"))
            {
                self.guide = [[EPub2_OPF_Guide alloc] initWithXMLNode:node1];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_OPF_Metadata

@implementation EPub2_OPF_Metadata

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        // 这里兼容早期的规范，检查了dc-metadata节点。若存在该节点，将该节点作为metadata的根节点
        
        xmlNodePtr dcMetadataNode = NULL;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"dc-metadata"))
            {
                dcMetadataNode = node1;
                
                break;
            }
            
            node1 = node1->next;
        }
        
        if (dcMetadataNode)
        {
            node1 = dcMetadataNode;
        }
        else
        {
            node1 = node->children;
        }
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"title"))
            {
                if (!self.titles)
                {
                    self.titles = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.titles) addObject:[[EPub2_OPF_Metadata_Title alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"creator"))
            {
                if (!self.creators)
                {
                    self.creators = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.creators) addObject:[[EPub2_OPF_Metadata_Creator alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"subject"))
            {
                if (!self.subjects)
                {
                    self.subjects = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.subjects) addObject:[[EPub2_OPF_Metadata_Subject alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"description"))
            {
                if (!self.descriptions)
                {
                    self.descriptions = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.descriptions) addObject:[[EPub2_OPF_Metadata_Description alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"publisher"))
            {
                if (!self.publishers)
                {
                    self.publishers = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.publishers) addObject:[[EPub2_OPF_Metadata_Publisher alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"contributor"))
            {
                if (!self.contributors)
                {
                    self.contributors = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.contributors) addObject:[[EPub2_OPF_Metadata_Contributor alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"date"))
            {
                if (!self.dates)
                {
                    self.dates = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.dates) addObject:[[EPub2_OPF_Metadata_Date alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"type"))
            {
                if (!self.types)
                {
                    self.types = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.types) addObject:[[EPub2_OPF_Metadata_Type alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"format"))
            {
                if (!self.formats)
                {
                    self.formats = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.formats) addObject:[[EPub2_OPF_Metadata_Format alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"identifier"))
            {
                if (!self.identifiers)
                {
                    self.identifiers = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.identifiers) addObject:[[EPub2_OPF_Metadata_Identifier alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"source"))
            {
                if (!self.sources)
                {
                    self.sources = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.sources) addObject:[[EPub2_OPF_Metadata_Source alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"language"))
            {
                if (!self.languages)
                {
                    self.languages = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.languages) addObject:[[EPub2_OPF_Metadata_Language alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"relation"))
            {
                if (!self.relations)
                {
                    self.relations = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.relations) addObject:[[EPub2_OPF_Metadata_Relation alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"coverage"))
            {
                if (!self.coverages)
                {
                    self.coverages = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.coverages) addObject:[[EPub2_OPF_Metadata_Coverage alloc] initWithXMLNode:node1]];
            }
            else if (!xmlStrcmp(node1->name, BAD_CAST"rights"))
            {
                if (!self.rights)
                {
                    self.rights = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.rights) addObject:[[EPub2_OPF_Metadata_CopyRight alloc] initWithXMLNode:node1]];
            }
            else
            {
                if (!self.extensions)
                {
                    self.extensions = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.extensions) addObject:[[EPub2_OPF_Metadata_Extension alloc] initWithXMLNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Title

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.title = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Creator

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.creator = [EPubXMLUtility contentOfNode:node];
        
        self.role = [EPubXMLUtility valueOfPropertyNamed:@"role" forNode:node];
        
        self.fileAs = [EPubXMLUtility valueOfPropertyNamed:@"file-as" forNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Subject

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.keyword = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Description

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.metadataDescription = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Publisher

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.publisher = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Contributor

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.contributor = [EPubXMLUtility contentOfNode:node];
        
        self.role = [EPubXMLUtility valueOfPropertyNamed:@"role" forNode:node];
        
        self.fileAs = [EPubXMLUtility valueOfPropertyNamed:@"file-as" forNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Date

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        NSString *dateString = [EPubXMLUtility contentOfNode:node];
        
        if ([dateString length])
        {
            self.date = [NSDate dateFromEPubXMLDateString:dateString];
        }
        
        NSString *eventString = [EPubXMLUtility valueOfPropertyNamed:@"event" forNode:node];
        
        if ([eventString isEqualToString:@"creation"])
        {
            self.event = EPub2_OPF_Metadata_Date_Event_Creation;
        }
        else if ([eventString isEqualToString:@"publication"])
        {
            self.event = EPub2_OPF_Metadata_Date_Event_Publication;
        }
        else if ([eventString isEqualToString:@"modification"])
        {
            self.event = EPub2_OPF_Metadata_Date_Event_Modification;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Type

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.type = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Format

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.format = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Identifier

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.identifier = [EPubXMLUtility contentOfNode:node];
        
        self.identifierId = [EPubXMLUtility valueOfPropertyNamed:@"id" forNode:node];
        
        self.scheme = [EPubXMLUtility valueOfPropertyNamed:@"scheme" forNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Source

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.source = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Language

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.language = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Relation

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.relation = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Coverage

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.coverage = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_CopyRight

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.right = [EPubXMLUtility contentOfNode:node];
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Metadata_Extension

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.content = [EPubXMLUtility contentOfNode:node];
        
        xmlAttrPtr attribute = node->properties;
        
        if (attribute)
        {
            self.properties = [NSMutableDictionary dictionary];
        }
        
        while (attribute)
        {
            const xmlChar *propertyNameChar = attribute->name;
            
            const xmlChar *propertyValueChar = attribute->children->content;
            
            if (propertyNameChar && propertyValueChar)
            {
                [(NSMutableDictionary *)(self.properties) setObject:[NSString stringWithUTF8String:(const char *)propertyValueChar] forKey:[NSString stringWithUTF8String:(const char *)propertyNameChar]];
            }
            
            attribute = attribute->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_OPF_Manifest

@implementation EPub2_OPF_Manifest

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"item"))
            {
                if (!self.items)
                {
                    self.items = [NSMutableDictionary dictionary];
                }
                
                EPub2_OPF_ManifestItem *item = [[EPub2_OPF_ManifestItem alloc] initWithXMLNode:node1];
                
                if (item.itemId)
                {
                    [(NSMutableDictionary *)(self.items) setObject:item forKey:item.itemId];
                }
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_ManifestItem

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.itemId = [EPubXMLUtility valueOfPropertyNamed:@"id" forNode:node];
        
        self.relativeHref = [EPubXMLUtility valueOfPropertyNamed:@"href" forNode:node];
        
        self.mediaType = [EPubXMLUtility valueOfPropertyNamed:@"media-type" forNode:node];
        
        NSString *fallbackString = [EPubXMLUtility valueOfPropertyNamed:@"fallback" forNode:node];
        
        NSString *fallback_styleString = [EPubXMLUtility valueOfPropertyNamed:@"fallback-style" forNode:node];
        
        NSString *requiredNamespaceString = [EPubXMLUtility valueOfPropertyNamed:@"required-namespace" forNode:node];
        
        NSString *requiredModulesString = [EPubXMLUtility valueOfPropertyNamed:@"required-modules" forNode:node];
        
        if (fallbackString || fallback_styleString || requiredNamespaceString || requiredModulesString)
        {
            self.fallBack = [[EPub2_OPF_ManifestItem_FallBack alloc] init];
            
            self.fallBack.fallBackItemId = fallbackString;
            
            self.fallBack.fallBackStyleItemId = fallback_styleString;
            
            self.fallBack.requiredNameSpace = requiredNamespaceString;
            
            self.fallBack.requiredModules = requiredModulesString;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_ManifestItem_FallBack

@end


#pragma mark - EPub2_OPF_Spine

@implementation EPub2_OPF_Spine

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.NCXId = [EPubXMLUtility valueOfPropertyNamed:@"toc" forNode:node];
        
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"itemref"))
            {
                if (!self.items)
                {
                    self.items = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.items) addObject:[[EPub2_OPF_SpineItem alloc] initWithXMLNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_SpineItem

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.itemId = [EPubXMLUtility valueOfPropertyNamed:@"idref" forNode:node];
        
        self.linear = [[EPubXMLUtility valueOfPropertyNamed:@"linear" forNode:node] intValue];
    }
    
    return self;
}

@end


#pragma mark - EPub2_OPF_Guide

@implementation EPub2_OPF_Guide

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"reference"))
            {
                if (!self.references)
                {
                    self.references = [NSMutableArray array];
                }
                
                [(NSMutableArray *)(self.references) addObject:[[EPub2_OPF_Guide_Reference alloc] initWithXMLNode:node1]];
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


@implementation EPub2_OPF_Guide_Reference

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.type = [EPubXMLUtility valueOfPropertyNamed:@"type" forNode:node];
        
        self.title = [EPubXMLUtility valueOfPropertyNamed:@"title" forNode:node];
        
        self.href = [EPubXMLUtility valueOfPropertyNamed:@"href" forNode:node];
    }
    
    return self;
}

@end
