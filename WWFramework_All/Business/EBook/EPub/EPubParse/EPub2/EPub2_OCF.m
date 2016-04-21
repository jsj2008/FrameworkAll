//
//  EPub2_METAINF.m
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPub2_OCF.h"

#pragma mark - EPub2_OCF

@implementation EPub2_OCF

@end


#pragma mark - EPub2_OCF_Container

@implementation EPub2_OCF_Container

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.version = [EPubXMLUtility valueOfPropertyNamed:@"version" forNode:node];
        
        xmlNodePtr node1 = node->children;
        
        while (node1)
        {
            if (!xmlStrcmp(node1->name, BAD_CAST"rootfiles"))
            {
                NSMutableArray *rootFileArray = [NSMutableArray array];
                
                xmlNodePtr node2 = node1->children;
                
                while (node2)
                {
                    if (!xmlStrcmp(node2->name, BAD_CAST"rootfile"))
                    {
                        EPub2_OCF_Container_RootFile *rootFile = [[EPub2_OCF_Container_RootFile alloc] initWithXMLNode:node2];
                        
                        if (rootFile)
                        {
                            [rootFileArray addObject:rootFile];
                        }
                    }
                    
                    node2 = node2->next;
                }
                
                if ([rootFileArray count])
                {
                    self.rootFiles = rootFileArray;
                    
                    break;
                }
            }
            
            node1 = node1->next;
        }
    }
    
    return self;
}

@end


#pragma mark - EPub2_OCF_Container_RootFile

@implementation EPub2_OCF_Container_RootFile

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        self.fullPath = [EPubXMLUtility valueOfPropertyNamed:@"full-path" forNode:node];
        
        self.mediaType = [EPubXMLUtility valueOfPropertyNamed:@"media-type" forNode:node];
    }
    
    return self;
}

@end
