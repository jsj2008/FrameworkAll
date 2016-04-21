//
//  FileInputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "FileInputStream.h"

@interface FileInputStream ()
{
    // 当前文件位置
    unsigned long long _currentLocation;
    
    // 文件结束位置
    unsigned long long _endLocation;
}

/*!
 * @brief 文件句柄
 */
@property (nonatomic, retain) NSFileHandle *fileHandle;

@end


@implementation FileInputStream

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
    }
    
    return self;
}

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if (!_over)
    {
        if (!self.fileHandle)
        {
            if (self.endLocation)
            {
                if (self.startLocation >= self.endLocation)
                {
                    _over = YES;
                    
                    _endLocation = self.endLocation;
                }
            }
            
            if (!_over)
            {
                self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
                
                _endLocation = [self.fileHandle seekToEndOfFile];
                
                [self.fileHandle seekToFileOffset:self.startLocation];
                
                _currentLocation = self.startLocation;
            }
        }
        
        data = [self.fileHandle readDataOfLength:MIN(_endLocation - _currentLocation, length)];
        
        _currentLocation = [self.fileHandle offsetInFile];
        
        if (![data length] || (_currentLocation >= _endLocation))
        {
            _over = YES;
        }
    }
    
    return data;
}

- (void)resetInput
{
    _over = NO;
    
    _currentLocation = 0;
}

@end
