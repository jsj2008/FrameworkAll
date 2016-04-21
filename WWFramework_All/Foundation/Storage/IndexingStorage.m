//
//  IndexingStorage.m
//  Demo
//
//  Created by Baymax on 13-10-18.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "IndexingStorage.h"
#import "FileRemover.h"
#import "FileContentReadAccelerator.h"

#pragma mark - IndexingStorage

@implementation IndexingStorage

- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index ofAccount:(Account *)account
{
    return YES;
}

- (NSData *)dataForIndex:(NSString *)index ofAccount:(Account *)account
{
    return nil;
}

- (NSDictionary *)datasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    return nil;
}

- (NSArray *)existingDataIndexesInIndexScope:(NSArray *)indexScope ofAccount:(Account *)account
{
    return nil;
}

- (void)cleanDatasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    
}

- (void)cleanDatasOfAccount:(Account *)account
{
    
}

- (void)cleanAllDatas
{
    
}

@end


#pragma mark - MemoryingIndexingStorage

@implementation MemoryingIndexingStorage

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _datas = [[NSMutableDictionary alloc] init];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index ofAccount:(Account *)account
{
    if (data && index && account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *accountDatas = [_datas objectForKey:accountIdentifier];
            
            if (!accountDatas)
            {
                accountDatas = [NSMutableDictionary dictionary];
                
                [_datas setObject:accountDatas forKey:accountIdentifier];
            }
            
            [accountDatas setObject:data forKey:index];
        });
    }
    
    return YES;
}

- (NSData *)dataForIndex:(NSString *)index ofAccount:(Account *)account
{
    __block NSData *data = nil;
    
    if (index && account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            data = [[_datas objectForKey:accountIdentifier] objectForKey:index];
        });
    }
    
    return data;
}

- (NSDictionary *)datasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    
    if ([indexes count] && account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *accountDatas = [_datas objectForKey:accountIdentifier];
            
            if (accountDatas)
            {
                for (NSString *index in indexes)
                {
                    id data = [accountDatas objectForKey:index];
                    
                    if (data)
                    {
                        [datas setObject:data forKey:index];
                    }
                }
            }
        });
    }
    
    return [datas count] ? datas : nil;
}

- (NSArray *)existingDataIndexesInIndexScope:(NSArray *)indexScope ofAccount:(Account *)account
{
    NSMutableArray *indexes = [NSMutableArray array];
    
    if ([indexScope count] && account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *accountDatas = [_datas objectForKey:accountIdentifier];
            
            if (accountDatas)
            {
                NSArray *keys = [accountDatas allKeys];
                
                for (NSString *index in indexScope)
                {
                    if ([keys containsObject:index])
                    {
                        [indexes addObject:index];
                    }
                }
            }
        });
    }
    
    return [indexes count] ? indexes : nil;
}

- (void)cleanDatasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    if ([indexes count] && account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            NSMutableDictionary *accountDatas = [_datas objectForKey:accountIdentifier];
            
            if (accountDatas)
            {
                [accountDatas removeObjectsForKeys:indexes];
                
                if (![accountDatas count])
                {
                    [_datas removeObjectForKey:accountIdentifier];
                }
            }
        });
    }
}

- (void)cleanDatasOfAccount:(Account *)account
{
    if (account)
    {
        NSString *accountIdentifier = [account identifier];
        
        dispatch_sync(_syncQueue, ^{
            
            [_datas removeObjectForKey:accountIdentifier];
        });
    }
}

- (void)cleanAllDatas
{
    dispatch_sync(_syncQueue, ^{
        
        [_datas removeAllObjects];
    });
}

@end


#pragma mark - FilingIndexingStorage

@implementation FilingIndexingStorage

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)initWithRootDirectory:(NSString *)rootDirectory
{
    if (self = [super init])
    {
        _fm = [[NSFileManager alloc] init];
        
        _rootDirectory = [rootDirectory copy];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
        
        self.mode = FilingIndexingStorageMode_Default;
    }
    
    return self;
}

- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index ofAccount:(Account *)account
{
    __block BOOL success = NO;
    
    NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
    
    dispatch_sync(_syncQueue, ^{
        
        NSString *dir = [contentPath stringByDeletingLastPathComponent];
        
        BOOL isDir = NO;
        
        if (!([_fm fileExistsAtPath:contentPath isDirectory:&isDir] && isDir))
        {
            [_fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        success = [data writeToFile:contentPath atomically:YES];
    });
    
    return success;
}

- (BOOL)saveDataWithPath:(NSString *)path forIndex:(NSString *)index ofAccount:(Account *)account
{
    __block BOOL success = NO;
    
    NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
    
    dispatch_sync(_syncQueue, ^{
        
        NSString *dir = [contentPath stringByDeletingLastPathComponent];
        
        BOOL isDir = NO;
        
        if (!([_fm fileExistsAtPath:contentPath isDirectory:&isDir] && isDir))
        {
            [_fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        success = [_fm moveItemAtPath:path toPath:contentPath error:nil];
    });
    
    return success;
}

- (long long)currentDataSize
{
     __block long long size = 0;
     
     dispatch_sync(_syncQueue, ^{
          
          size = [[_fm attributesOfItemAtPath:_rootDirectory error:nil] fileSize];
          
          NSArray *subPaths = [_fm subpathsOfDirectoryAtPath:_rootDirectory error:nil];
          
          for (NSString *path in subPaths)
          {
               NSString *filePath = [_rootDirectory stringByAppendingPathComponent:path];
               
               size += [[_fm attributesOfItemAtPath:filePath error:nil] fileSize];
          }
     });
     
     return size;
}

- (NSData *)dataForIndex:(NSString *)index ofAccount:(Account *)account
{
    if (![index length])
    {
        return nil;
    }
    
    __block NSData *data = nil;
    
    NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
    
    dispatch_sync(_syncQueue, ^{
        
        data = [[NSData alloc] initWithContentsOfFile:contentPath];
    });
    
    return data;
}

- (NSDictionary *)datasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    if (![indexes count])
    {
        return nil;
    }
    
    __block NSDictionary *datas = nil;
    
    NSMutableArray *contentPaths = [NSMutableArray array];
    
    NSMutableDictionary *indexingRecords = [NSMutableDictionary dictionary];
    
    for (NSString *index in indexes)
    {
        NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
        
        if (contentPath)
        {
            [contentPaths addObject:contentPath];
            
            [indexingRecords setObject:contentPath forKey:index];
        }
    }
    
    switch (self.mode)
    {
        case FilingIndexingStorageMode_Common:
        {
            dispatch_sync(_syncQueue, ^{
                
                datas = [[[FileContentReadAccelerator alloc] init] contentsOfFiles:contentPaths speeding:NO];
            });
            
            break;
        }
            
        case FilingIndexingStorageMode_Speed:
        {
            dispatch_sync(_syncQueue, ^{
                
                datas = [[[FileContentReadAccelerator alloc] init] contentsOfFiles:contentPaths speeding:YES];
            });
            
            break;
        }
            
        default:
            break;
    }
    
    NSMutableDictionary *sortedDatas = [NSMutableDictionary dictionary];
    
    for (NSString *index in [indexingRecords allKeys])
    {
        NSString *contentPath = [indexingRecords objectForKey:index];
        
        NSData *content = [datas objectForKey:contentPath];
        
        if (content)
        {
            [sortedDatas setObject:content forKey:index];
        }
    }
    
    return sortedDatas;
}

- (NSArray *)existingDataIndexesInIndexScope:(NSArray *)indexScope ofAccount:(Account *)account
{
    if (![indexScope count])
    {
        return nil;
    }
    
    NSMutableArray *existingDataIndexes = [NSMutableArray array];
    
    NSMutableDictionary *indexingRecords = [NSMutableDictionary dictionary];
    
    for (NSString *index in indexScope)
    {
        NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
        
        if (contentPath)
        {
            [indexingRecords setObject:contentPath forKey:index];
        }
    }
    
    dispatch_sync(_syncQueue, ^{
        
        for (NSString *index in indexingRecords)
        {
            NSString *contentPath = [indexingRecords objectForKey:index];
            
            BOOL isDir = NO;
            
            if ([_fm fileExistsAtPath:contentPath isDirectory:&isDir] && !isDir)
            {
                [existingDataIndexes addObject:index];
            }
        }
    });
    
    return existingDataIndexes;
}

- (void)cleanDatasForIndexes:(NSArray *)indexes ofAccount:(Account *)account
{
    NSMutableArray *paths = [NSMutableArray array];
    
    for (NSString *index in indexes)
    {
        NSString *contentPath = [self contentPathForIndex:index ofAccount:account];
        
        if (contentPath)
        {
            [paths addObject:contentPath];
        }
    }
    
    if ([paths count])
    {
        dispatch_sync(_syncQueue, ^{
            
            [[FileRemover sharedInstance] removeItems:paths];
        });
    }
}

- (void)cleanDatasOfAccount:(Account *)account
{
    dispatch_sync(_syncQueue, ^{
        
        [[FileRemover sharedInstance] removeItems:[NSArray arrayWithObject:[self contentPathOfAccount:account]]];
        
        [_fm createDirectoryAtPath:_rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    });
}

- (void)cleanAllDatas
{
    dispatch_sync(_syncQueue, ^{
        
        [[FileRemover sharedInstance] removeItems:[NSArray arrayWithObject:_rootDirectory]];
        
        [_fm createDirectoryAtPath:_rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    });
}

- (NSString *)contentPathOfAccount:(Account *)account
{
    NSString *identifier = [account identifier];
    
    return [_rootDirectory stringByAppendingPathComponent:identifier];
}

- (NSString *)contentPathForIndex:(NSString *)index ofAccount:(Account *)account
{
    return index ? [[self contentPathOfAccount:account] stringByAppendingPathComponent:index] : nil;
}

@end
