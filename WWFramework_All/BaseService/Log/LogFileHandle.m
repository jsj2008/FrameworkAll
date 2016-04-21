//
//  LogFileHandle.m
//  FoundationProject
//
//  Created by user on 13-12-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "LogFileHandle.h"

@interface LogFileHandle ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
    
    // 文件管理器
    NSFileManager *_fm;
}

/*!
 * @brief 文件句柄
 */
@property (nonatomic) NSFileHandle *fileHandle;

/*!
 * @brief 当前操作的日志文件路径
 * @result 当前操作的日志文件路径
 */
- (NSString *)usingLogPath;

/*!
 * @brief 可用的历史日志文件路径
 * @result 可用的历史日志文件路径
 */
- (NSString *)availableHistoryLogPath;

@end


@implementation LogFileHandle

- (id)initWithRootDirectory:(NSString *)rootDirectory
{
    if (self = [super init])
    {
        _rootDirectory = [rootDirectory copy];
        
        _fm = [[NSFileManager alloc] init];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (void)writeString:(NSString *)string
{
    if (![string length])
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_sync(_syncQueue, ^{
            
            if (!self.fileHandle)
            {
                NSString *logFilePath = [self usingLogPath];
                
                if ([[_fm attributesOfItemAtPath:logFilePath error:nil] fileSize] > APPLogFileSize)
                {
                    [_fm moveItemAtPath:logFilePath toPath:[self availableHistoryLogPath] error:nil];
                }
                
                if ([_fm fileExistsAtPath:logFilePath])
                {
                    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
                }
                else
                {
                    BOOL isDir = NO;
                    
                    if (!([_fm fileExistsAtPath:_rootDirectory isDirectory:&isDir] && isDir))
                    {
                        [_fm createDirectoryAtPath:_rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    if ([_fm createFileAtPath:logFilePath contents:nil attributes:nil])
                    {
                        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
                    }
                }
            }
            
            [self.fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
            
            if ([self.fileHandle seekToEndOfFile] > APPLogFileSize)
            {
                self.fileHandle = nil;
            }
        });
    });
}

- (void)cleanAllLog
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_sync(_syncQueue, ^{
            
            self.fileHandle = nil;
            
            [_fm removeItemAtPath:_rootDirectory error:nil];
            
            [_fm createDirectoryAtPath:_rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        });
    });
}

- (void)cleanLogAtPath:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_sync(_syncQueue, ^{
            
            if (![path isEqualToString:[self usingLogPath]])
            {
                [_fm removeItemAtPath:path error:nil];
            }
        });
    });
}

- (void)resetLogs
{
    dispatch_sync(_syncQueue, ^{
        
        [_fm moveItemAtPath:[self usingLogPath] toPath:[self availableHistoryLogPath] error:nil];
        
        self.fileHandle = nil;
    });
}

- (NSArray *)currentAllLogPathes
{
    NSMutableArray *pathes = [[NSMutableArray alloc] init];
    
    dispatch_sync(_syncQueue, ^{
        
        for (NSString *content in [_fm contentsOfDirectoryAtPath:_rootDirectory error:nil])
        {
            NSString *path = [_rootDirectory stringByAppendingPathComponent:content];
            
            [pathes addObject:path];
        }
    });
    
    return pathes;
}

- (NSString *)usingLogPath
{
    return [_rootDirectory stringByAppendingPathComponent:APPLogFileName];
}

- (NSString *)availableHistoryLogPath
{
    return [[_rootDirectory stringByAppendingPathComponent:APPLogFileName] stringByAppendingFormat:@"%lld", (long long)[[NSDate date] timeIntervalSinceReferenceDate]];
}

@end


/*!
 * @brief 日志文件名
 */
NSString * const APPLogFileName = @"Log";

/*!
 * @brief 日志文件大小上限
 */
unsigned long long const APPLogFileSize = 4 * 1024 * 1024;
