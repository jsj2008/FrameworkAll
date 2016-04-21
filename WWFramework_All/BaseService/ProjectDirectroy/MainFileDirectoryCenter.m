//
//  MainFileDirectoryCenter.m
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "MainFileDirectoryCenter.h"
#import "APPConfiguration.h"

@implementation MainFileDirectoryCenter

+ (MainFileDirectoryCenter *)sharedInstance
{
    static MainFileDirectoryCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[MainFileDirectoryCenter alloc] init];
        }
    });
    
    return instance;
}

- (NSString *)logDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:APP_LogFileDirectoryName];
}

- (NSString *)trashDirectory
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:APP_TrashFileDirectoryName];
}

- (NSString *)HTTPRootDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:APP_HTTPFileDirectoryName];
}

- (NSString *)tempResourceDownloadRootDirectory
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:APP_TempResourceDownloadFileDirectoryName];
}

- (NSString *)BusinessFileRootDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:APP_BusinessFileDirectoryName];
}

- (NSString *)ActionFileRootDirectory
{
    return [[self BusinessFileRootDirectory] stringByAppendingPathComponent:APP_BusinessActionFileDirectoryName];
}

- (NSString *)HTTPMultipartParseTempFileRootDirectory
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:APP_HTTPMultipartParseDirectoryName];
}

- (NSString *)imageRootDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:APP_ImageFileDirectoryName];
}

- (NSString *)imageTempRootDirectory
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:APP_ImageFileDirectoryName];
}

@end
