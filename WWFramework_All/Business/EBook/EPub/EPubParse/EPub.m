//
//  EPub.m
//  FoundationProject
//
//  Created by user on 13-12-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "EPub.h"

#pragma mark - EPubPackage

@interface EPubPackage ()

/*!
 * @brief 更新数据
 * @param package 数据包裹
 */
- (void)updateInfoWithEPub2Package:(EPub2_Package *)package;

/*!
 * @brief 解析导航条目
 * @param point NCX导航点
 * @param initLevel 初始嵌套层级
 * @param directory 导航条目对应的文件所在目录
 * @result 导航条目
 */
- (EPubNavigationItem *)navigationItemFromNCXNavigationPoint:(EPub2_NCX_NavPoint *)point withInitLevel:(NSUInteger)initLevel directory:(NSString *)directory;

@end


@implementation EPubPackage

- (id)initWithEPub2Package:(EPub2_Package *)package
{
    if (self = [super init])
    {
        [self updateInfoWithEPub2Package:package];
    }
    
    return self;
}

- (id)initWithEPubDirectory:(NSString *)directory
{
    if (self = [super init])
    {
        EPub2_Package *package = [[EPub2_Package alloc] initWithEPubDirectory:directory];
        
        [self updateInfoWithEPub2Package:package];
    }
    
    return self;
}

- (void)updateInfoWithEPub2Package:(EPub2_Package *)package
{
    // meta
    
    if (package.opf.metadata)
    {
        EPub2_OPF_Metadata *opfMeta = package.opf.metadata;
        
        EPubMeta *bookMeta = [[EPubMeta alloc] init];
        
        
        NSMutableArray *bookTitles = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Title *title in opfMeta.titles)
        {
            if (title.title)
            {
                [bookTitles addObject:title.title];
            }
        }
        
        bookMeta.titles = [bookTitles count] ? bookTitles : nil;
        
        
        NSMutableArray *bookAuthors = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Creator *creator in opfMeta.creators)
        {
            if (creator.creator)
            {
                [bookAuthors addObject:creator.creator];
            }
        }
        
        bookMeta.authors = [bookAuthors count] ? bookAuthors : nil;
        
        
        NSMutableArray *bookSubjects = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Subject *subject in opfMeta.subjects)
        {
            if (subject.keyword)
            {
                [bookSubjects addObject:subject.keyword];
            }
        }
        
        bookMeta.subjects = [bookSubjects count] ? bookSubjects : nil;
        
        
        if ([opfMeta.descriptions count])
        {
            bookMeta.bookDescription = ((EPub2_OPF_Metadata_Description *)[opfMeta.descriptions objectAtIndex:0]).metadataDescription;
        }
        
        
        NSMutableArray *bookPublishers = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Publisher *publisher in opfMeta.publishers)
        {
            if (publisher.publisher)
            {
                [bookPublishers addObject:publisher.publisher];
            }
        }
        
        bookMeta.publishers = [bookPublishers count] ? bookPublishers : nil;
        
        
        for (EPub2_OPF_Metadata_Date *date in opfMeta.dates)
        {
            if (date.event == EPub2_OPF_Metadata_Date_Event_None || date.event == EPub2_OPF_Metadata_Date_Event_Publication)
            {
                bookMeta.publicationDate = date.date;
            }
            else if (date.event == EPub2_OPF_Metadata_Date_Event_Creation)
            {
                bookMeta.creationDate = date.date;
            }
        }
        
        
        NSMutableArray *bookTypes = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Type *type in opfMeta.types)
        {
            if (type.type)
            {
                [bookTypes addObject:type.type];
            }
        }
        
        bookMeta.types = [bookTypes count] ? bookTypes : nil;
        
        
        NSMutableArray *bookFormats = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Format *format in opfMeta.formats)
        {
            if (format.format)
            {
                [bookFormats addObject:format.format];
            }
        }
        
        bookMeta.formats = [bookFormats count] ? bookFormats : nil;
        
        
        if ([opfMeta.identifiers count])
        {
            bookMeta.identifier = ((EPub2_OPF_Metadata_Identifier *)[opfMeta.identifiers objectAtIndex:0]).identifier;
        }
        
        
        NSMutableArray *bookLanguages = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Language *language in opfMeta.languages)
        {
            if (language.language)
            {
                [bookLanguages addObject:language.language];
            }
        }
        
        bookMeta.languages = [bookLanguages count] ? bookLanguages: nil;
        
        
        NSMutableArray *bookCoverages = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_Coverage *coverage in opfMeta.coverages)
        {
            if (coverage.coverage)
            {
                [bookCoverages addObject:coverage.coverage];
            }
        }
        
        bookMeta.coverages = [bookCoverages count] ? bookCoverages : nil;
        
        
        NSMutableArray *bookRights = [NSMutableArray array];
        
        for (EPub2_OPF_Metadata_CopyRight *right in opfMeta.rights)
        {
            if (right.right)
            {
                [bookRights addObject:right.right];
            }
        }
        
        bookMeta.rights = [bookRights count] ? bookRights : nil;
        
        
        self.meta = bookMeta;
    }
    
    
    // document
    
    if ([package.opf.manifest.items count])
    {
        NSMutableDictionary *documentItems = [NSMutableDictionary dictionary];
        
        for (EPub2_OPF_ManifestItem *manifestItem in [package.opf.manifest.items allValues])
        {
            EPubDocumentItem *documentItem = [[EPubDocumentItem alloc] init];
            
            documentItem.itemId = manifestItem.itemId;
            
            if (manifestItem.relativeHref)
            {
                documentItem.path = [package.ocfDirectory length] ? [package.ocfDirectory stringByAppendingPathComponent:manifestItem.relativeHref] : manifestItem.relativeHref;
            }
            
            documentItem.mediaType = manifestItem.mediaType;
            
            documentItem.fallBackId = manifestItem.fallBack.fallBackItemId;
            
            if (documentItem.itemId)
            {
                [documentItems setObject:documentItem forKey:documentItem.itemId];
            }
        }
        
        self.document = [[EPubDocument alloc] init];
        
        self.document.documents = [documentItems count] ? documentItems : nil;
    }
    
    
    // playList
    
    if ([package.opf.spine.items count])
    {
        NSMutableArray *playListItemIds = [NSMutableArray array];
        
        for (EPub2_OPF_SpineItem *spineItem in package.opf.spine.items)
        {
            if (spineItem.itemId)
            {
                [playListItemIds addObject:spineItem.itemId];
            }
        }
        
        self.playList = [[EPubPlayList alloc] init];
        
        self.playList.itemIds = [playListItemIds count] ? playListItemIds : nil;
    }
    
    
    // navigation
    
    if (package.ncx)
    {
        self.navigation = [[EPubNavigation alloc] init];
        
        self.navigation.titles = package.ncx.title.titles;
        
        self.navigation.authors = package.ncx.author.authors;
        
        if ([package.ncx.navMap.navPoints count])
        {
            NSMutableArray *navigationItems = [NSMutableArray array];
            
            for (EPub2_NCX_NavPoint *point in package.ncx.navMap.navPoints)
            {
                EPubNavigationItem *item = [self navigationItemFromNCXNavigationPoint:point withInitLevel:1 directory:package.ocfDirectory];
                
                if (item)
                {
                    [navigationItems addObject:item];
                }
            }
            
            self.navigation.items = [navigationItems count] ? navigationItems : nil;
        }
    }
    
    
    // guide
    
    if ([package.opf.guide.references count])
    {
        NSMutableArray *guideItems = [NSMutableArray array];
        
        for (EPub2_OPF_Guide_Reference *opfReference in package.opf.guide.references)
        {
            EPubGuideItem *guideItem = [[EPubGuideItem alloc] init];
            
            guideItem.type = opfReference.type;
            
            guideItem.title = opfReference.title;
            
            NSArray *stringComponents = [opfReference.href componentsSeparatedByString:@"#"];
            
            NSString *path = ([stringComponents count] >= 1) ? [stringComponents objectAtIndex:0] : nil;
            
            guideItem.anchor = ([stringComponents count] >= 2) ? [stringComponents objectAtIndex:1] : nil;
            
            if (path)
            {
                guideItem.path = [package.ocfDirectory length] ? [package.ocfDirectory stringByAppendingPathComponent:path] : path;
            }
            
            [guideItems addObject:guideItem];
        }
        
        self.guide = [[EPubGuide alloc] init];
        
        self.guide.items = [guideItems count] ? guideItems : nil;
    }
}

- (EPubNavigationItem *)navigationItemFromNCXNavigationPoint:(EPub2_NCX_NavPoint *)point withInitLevel:(NSUInteger)initLevel directory:(NSString *)directory
{
    EPubNavigationItem *navigationItem = [[EPubNavigationItem alloc] init];
    
    navigationItem.itemId = point.pointId;
    
    navigationItem.name = [point.label.labels count] ? [point.label.labels objectAtIndex:0] : nil;
    
    NSArray *stringComponents = [point.contentHref componentsSeparatedByString:@"#"];
    
    NSString *path = ([stringComponents count] >= 1) ? [stringComponents objectAtIndex:0] : nil;
    
    navigationItem.anchor = ([stringComponents count] >= 2) ? [stringComponents objectAtIndex:1] : nil;
    
    if (path)
    {
        navigationItem.path = [directory length] ? [directory stringByAppendingPathComponent:path] : path;
    }
    
    navigationItem.level = initLevel;
    
    NSMutableArray *subNavigationItems = [NSMutableArray array];
    
    for (EPub2_NCX_NavPoint *subPoint in point.navPoints)
    {
        EPubNavigationItem *item = [self navigationItemFromNCXNavigationPoint:subPoint withInitLevel:(initLevel + 1) directory:directory];
        
        if (item)
        {
            [subNavigationItems addObject:item];
        }
    }
    
    navigationItem.items = [subNavigationItems count] ? subNavigationItems : nil;
    
    return navigationItem;
}

@end


#pragma mark - EPubMeta

@implementation EPubMeta

@end


#pragma mark - EPubDocument

@implementation EPubDocument

- (EPubDocumentItem *)itemPathed:(NSString *)path
{
    EPubDocumentItem *documentItem = nil;
    
    if (path)
    {
        for (EPubDocumentItem *item in [self.documents allValues])
        {
            if ([item.path isEqualToString:path])
            {
                documentItem = item;
                
                break;
            }
        }
    }
    
    return documentItem;
}

@end


@implementation EPubDocumentItem

@end


#pragma mark - EPubPlayList

@implementation EPubPlayList

@end


#pragma mark - EPubNavigation

@implementation EPubNavigation

@end


@implementation EPubNavigationItem

@end


#pragma mark - EPubGuide

@implementation EPubGuide

@end


@implementation EPubGuideItem

@end
