//
//  FileContentReadAccelerator.m
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FileContentReadAccelerator.h"

static const NSUInteger FileContentReadConcurrentQueueCount = 3;


@interface FileContentReadAccelerator ()

- (NSDictionary *)contentsOfSequentialFiles:(NSArray *)filePaths;

- (NSDictionary *)contentsOfConcurrentFiles:(NSArray *)filePaths withQueueCount:(NSUInteger)count;

@end


@implementation FileContentReadAccelerator

- (NSDictionary *)contentsOfSequentialFiles:(NSArray *)filePaths
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    
    for (NSString *path in filePaths)
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if ([data length])
        {
            [datas setObject:data forKey:path];
        }
    }
    
    return datas;
}

- (NSDictionary *)contentsOfConcurrentFiles:(NSArray *)filePaths withQueueCount:(NSUInteger)count
{
    if ([filePaths count] == 0 || count < 1)
    {
        return nil;
    }
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
    dispatch_group_t group = dispatch_group_create();
    
    NSUInteger fileCount = [filePaths count];
    
    for (int i = 0; i < count; i ++)
    {
        if (i < count - 1)
        {
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableDictionary *contentDatas = [NSMutableDictionary dictionary];
                
                for (int j = (int)(fileCount * i / count); j < fileCount * (i + 1) / count; j ++)
                {
                    NSString *path = [filePaths objectAtIndex:j];
                    
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    
                    if ([data length])
                    {
                        [contentDatas setObject:data forKey:path];
                    }
                }
                
                if ([contentDatas count])
                {
                    dispatch_sync(queue, ^{
                        
                        [datas addEntriesFromDictionary:contentDatas];
                    });
                }
            });
        }
        else
        {
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableDictionary *contentDatas = [NSMutableDictionary dictionary];
                
                for (int j = (int)(fileCount * i / count); j < fileCount; j ++)
                {
                    NSString *path = [filePaths objectAtIndex:j];
                    
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    
                    if ([data length])
                    {
                        [contentDatas setObject:data forKey:path];
                    }
                }
                
                if ([contentDatas count])
                {
                    dispatch_sync(queue, ^{
                        
                        [datas addEntriesFromDictionary:contentDatas];
                    });
                }
            });
        }
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return datas;
}

- (NSDictionary *)contentsOfFiles:(NSArray *)filePaths speeding:(BOOL)speeding
{
    NSDictionary *datas = nil;
    
    if (speeding)
    {
        if ([filePaths count] <= FileContentReadConcurrentQueueCount)
        {
            datas = [self contentsOfSequentialFiles:filePaths];
        }
        else
        {
            datas = [self contentsOfConcurrentFiles:filePaths withQueueCount:FileContentReadConcurrentQueueCount];
        }
    }
    else
    {
        datas = [self contentsOfSequentialFiles:filePaths];
    }
    
    return datas;
}

@end
