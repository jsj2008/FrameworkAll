//
//  FileRemover.m
//  Demo
//
//  Created by Baymax on 13-10-16.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FileRemover.h"
#import "MainFileDirectoryCenter.h"

@interface FileRemover ()
{
    // 转移目录的同步队列
    dispatch_queue_t _moveQueue;
    
    // 删除目录的同步队列
    dispatch_queue_t _removeQueue;
    
    // 转移待删除文件时，用于确定转移的目标文件位置的唯一性的标志
    long long _fileFlag;
}

/*!
 * @brief 当前垃圾文件目录：XXX/HTTPTrash/1413434.34/
 */
@property (nonatomic, copy) NSString *currentTrashDir;

@end


@implementation FileRemover

@synthesize rootDirectory;

@synthesize currentTrashDir;

- (id)init
{
    if (self = [super init])
    {
        _moveQueue = dispatch_queue_create(NULL, NULL);
        
        _removeQueue = dispatch_queue_create(NULL, NULL);
        
        _fileFlag = 0;
    }
    return self;
}

- (void)dealloc
{
    dispatch_sync(_moveQueue, ^{});
    
    dispatch_sync(_removeQueue, ^{});
}

+ (FileRemover *)sharedInstance
{
    static FileRemover *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[FileRemover alloc] init];
            
            instance.rootDirectory = [[MainFileDirectoryCenter sharedInstance] trashDirectory];
        }
    });
    
    return instance;
}

- (void)removeItems:(NSArray<NSString *> *)items
{
    NSMutableArray *toRemovePaths = [NSMutableArray array];
    
    if ([items count])
    {
        dispatch_sync(_moveQueue, ^{
            
            NSFileManager *fm = [[NSFileManager alloc] init];
            
            for (NSString *item in items)
            {
                NSString *toRemovePath = [self.currentTrashDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld", (++ _fileFlag)]];
                
                if (![fm fileExistsAtPath:toRemovePath])
                {
                    [toRemovePaths addObject:toRemovePath];
                    
                    [fm moveItemAtPath:item toPath:toRemovePath error:nil];
                }
                else
                {
                    [fm removeItemAtPath:item error:nil];
                }
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_sync(_removeQueue, ^{
                
                NSFileManager *fm = [[NSFileManager alloc] init];
                
                for (NSString *path in toRemovePaths)
                {
                    [fm removeItemAtPath:path error:nil];
                }
            });
        });
    }
}

- (void)clean
{
    NSMutableArray *paths = [NSMutableArray array];
    
    // 配置新目录
    dispatch_sync(_moveQueue, ^{
        
        NSString *tempTrashDir = nil;
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        
        NSArray *contents = [fm contentsOfDirectoryAtPath:self.rootDirectory error:nil];
        
        for (NSString *content in contents)
        {
            [paths addObject:[self.rootDirectory stringByAppendingPathComponent:content]];
        }
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        
        do {
            
            tempTrashDir = [self.rootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f", interval]];
            
            interval  = interval + 0.001;
        } while ([fm fileExistsAtPath:tempTrashDir]);
        
        [fm createDirectoryAtPath:tempTrashDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        self.currentTrashDir = tempTrashDir;
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        dispatch_sync(_removeQueue, ^{
            
            NSFileManager *fm = [[NSFileManager alloc] init];
            
            for (NSString *path in paths)
            {
                [fm removeItemAtPath:path error:nil];
            }
        });
    });
}

@end