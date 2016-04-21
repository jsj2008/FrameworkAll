//
//  ImageDC.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/21/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageDC.h"
#import "IndexingStorage.h"
#import "MainFileDirectoryCenter.h"
#import "MD5Cryptor.h"
#import "FileRemover.h"

@interface ImageDC ()

/*!
 * @brief 文件存储器
 */
@property (nonatomic) FilingIndexingStorage *fileStorage;

/*!
 * @brief 获取图片索引
 * @param URL 图片URL
 * @return 索引
 */
- (NSString *)indexOfURL:(NSURL *)URL;

@end


@implementation ImageDC

+ (ImageDC *)sharedInstance
{
    static ImageDC *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ImageDC alloc] init];
            
            instance.fileStorage = [[FilingIndexingStorage alloc] initWithRootDirectory:[[MainFileDirectoryCenter sharedInstance] imageRootDirectory]];
        }
    });
    
    return instance;
}

- (void)start
{
    
}

- (void)stop
{
    
}

- (void)saveImageByURL:(NSURL *)URL withData:(NSData *)data
{
    [self.fileStorage saveData:data forIndex:[self indexOfURL:URL] ofAccount:nil];
}

- (void)saveImageByURL:(NSURL *)URL withDataPath:(NSString *)dataPath
{
    [self.fileStorage saveDataWithPath:dataPath forIndex:[self indexOfURL:URL] ofAccount:nil];
}

- (NSData *)imageDataByURL:(NSURL *)URL
{
    return [self.fileStorage dataForIndex:[self indexOfURL:URL] ofAccount:nil];;
}

- (NSString *)indexOfURL:(NSURL *)URL
{
    return [[URL absoluteString] uppercaseMD5EncodedString];
}

@end


@implementation ImageDC (TempResource)

- (NSString *)tempImagePathByURL:(NSURL *)URL
{
    return [[[MainFileDirectoryCenter sharedInstance] imageTempRootDirectory] stringByAppendingPathComponent:[self indexOfURL:URL]];
}

- (void)cleanTempResources
{
    [[FileRemover sharedInstance] removeItems:[NSArray arrayWithObject:[[MainFileDirectoryCenter sharedInstance] imageTempRootDirectory]]];
}

@end
