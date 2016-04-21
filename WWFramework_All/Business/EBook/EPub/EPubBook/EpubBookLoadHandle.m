//
//  EpubBookLoadHandle.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "EpubBookLoadHandle.h"
#import "EPub.h"

@interface EpubBookLoadHandle ()

@property (nonatomic) EPubBookContainerHandle *container;

@end


@implementation EpubBookLoadHandle

- (void)loadBook
{
    NSString *directory = nil;
    
    EPubBookContainerHandle *containHandle = [[EPubBookContainerHandle alloc] init];
    
    EPubPackage *package = [[EPubPackage alloc] initWithEPubDirectory:directory];
    
    containHandle.bookId = self.bookId;
    
    containHandle.directory = directory;
    
    containHandle.package = package;
    
    self.container = containHandle;
}

- (EPubBookContainerHandle *)bookContainer
{
    return self.container;
}

@end

