//
//  EPub2_Package.m
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPub2_Package.h"
#import "EPubXML.h"

@interface EPub2_Package ()

- (void)updateInfoWithPackageDirectory:(NSString *)directory;

@end


@implementation EPub2_Package

- (id)initWithEPubDirectory:(NSString *)directory
{
    if (self = [super init])
    {
        [self updateInfoWithPackageDirectory:directory];
    }
    
    return self;
}

- (void)updateInfoWithPackageDirectory:(NSString *)directory
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:directory isDirectory:&isDir] && isDir)
    {
        // ocf
        
        self.ocf = [[EPub2_OCF alloc] init];
        
        NSString *containerPath = [directory stringByAppendingPathComponent:@"META-INF/container.xml"];
        
        if ([fm fileExistsAtPath:containerPath])
        {
            xmlDocPtr doc = xmlReadFile([containerPath UTF8String], NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
            
            if (doc)
            {
                xmlNodePtr rootNode = xmlDocGetRootElement(doc);
                
                if (!xmlStrcmp(rootNode->name, BAD_CAST"container"))
                {
                    EPub2_OCF_Container *container = [[EPub2_OCF_Container alloc] initWithXMLNode:rootNode];
                    
                    self.ocf.container = container;
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        // opf
        
        EPub2_OCF_Container_RootFile *rootFile = [self.ocf.container.rootFiles count] ? [self.ocf.container.rootFiles objectAtIndex:0] : nil;
        
        if (rootFile.fullPath)
        {
            NSString *opfPath = [directory stringByAppendingPathComponent:rootFile.fullPath];
            
            if ([fm fileExistsAtPath:opfPath])
            {
                xmlDocPtr doc = xmlReadFile([opfPath UTF8String], NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
                
                if (doc)
                {
                    xmlNodePtr rootNode = xmlDocGetRootElement(doc);
                    
                    if (!xmlStrcmp(rootNode->name, BAD_CAST"package"))
                    {
                        self.opf = [[EPub2_OPF alloc] initWithXMLNode:rootNode];
                        
                        self.ocfDirectory = [rootFile.fullPath stringByDeletingLastPathComponent];
                    }
                }
                
                xmlFreeDoc(doc);
            }
        }
        
        // ncx
        
        if (self.opf)
        {
            // 通常来说，ncx文件的目录总是需要通过opf文件查找得到，但为了兼容不规范的EPub文档，这里强制指定了ncx文件位置
            NSString *ncxPath = [[directory stringByAppendingPathComponent:self.ocfDirectory] stringByAppendingPathComponent:@"toc.ncx"];
            
            if ([fm fileExistsAtPath:ncxPath])
            {
                xmlDocPtr doc = xmlReadFile([ncxPath UTF8String], NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
                
                if (doc)
                {
                    xmlNodePtr rootNode = xmlDocGetRootElement(doc);
                    
                    if (!xmlStrcmp(rootNode->name, BAD_CAST"ncx"))
                    {
                        self.ncx = [[EPub2_NCX alloc] initWithXMLNode:rootNode];
                    }
                }
                
                xmlFreeDoc(doc);
            }
        }
    }
}

@end
