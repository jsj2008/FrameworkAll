//
//  FileOutputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "FileOutputStream.h"

@interface FileOutputStream ()

/*!
 * @brief 文件句柄
 */
@property (nonatomic) NSFileHandle *fileHandle;

@end


@implementation FileOutputStream

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        
        if (![fm fileExistsAtPath:_filePath])
        {
            NSString *directory = [_filePath stringByDeletingLastPathComponent];
            
            if (![fm fileExistsAtPath:directory])
            {
                [fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            [fm createFileAtPath:_filePath contents:nil attributes:nil];
        }
        
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_filePath];
        
        [self.fileHandle seekToEndOfFile];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if (self.fileHandle && [data length])
    {
        [self.fileHandle writeData:data];
    }
}

- (unsigned long long)fileSize
{
    return [self.fileHandle offsetInFile];
}

- (void)resetOutput
{
    [self.fileHandle truncateFileAtOffset:0];
}

@end
