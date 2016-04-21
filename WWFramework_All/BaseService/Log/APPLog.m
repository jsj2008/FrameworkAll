//
//  APPLog.m
//  FoundationProject
//
//  Created by user on 13-12-10.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "APPLog.h"
#import "LogFileHandle.h"

@interface APPLog ()
{
    // 停止标志
    BOOL _stop;
}

/*!
 * @brief 文件打印句柄
 */
@property (nonatomic) LogFileHandle *fileHandle;

/*!
 * @brief NSLog打印
 * @param string 打印字符串
 */
- (void)NSLogString:(NSString *)string;

/*!
 * @brief 文件打印
 * @param string 打印字符串
 */
- (void)fileLogString:(NSString *)string;

@end


@implementation APPLog

- (id)init
{
    if (self = [super init])
    {
        _stop = YES;
        
        self.defaultLevel = APPLogLevel_High;
        
        self.logFileDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Log"];
    }
    
    return self;
}

+ (APPLog *)sharedInstance
{
    static APPLog *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[APPLog alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    _stop = NO;
    
    self.fileHandle = [[LogFileHandle alloc] initWithRootDirectory:self.logFileDirectory];
}

- (void)stop
{
    _stop = YES;
    
    self.fileHandle = nil;
}

- (void)cleanAllLog
{
    [self.fileHandle cleanAllLog];
}

- (void)cleanLogAtPath:(NSString *)path
{
    [self.fileHandle cleanLogAtPath:path];
}

- (void)resetLogs
{
    [self.fileHandle resetLogs];
}

- (NSArray *)currentAllLogPathes
{
    return [self.fileHandle currentAllLogPathes];
}

- (void)logString:(NSString *)string onLevel:(APPLogLevel)level
{
    if (_stop || ![string length])
    {
        return;
    }
    
    switch (level)
    {
        case APPLogLevel_Low:
        {
            [self NSLogString:string];
            
            break;
        }
        case APPLogLevel_Middle:
        {
            [self fileLogString:string];
            
            break;
        }
        case APPLogLevel_High:
        {
            [self NSLogString:string];
            
            [self fileLogString:string];
            
            break;
        }
        default:
            break;
    }
}

- (void)logString:(NSString *)string
{
    [self logString:string onLevel:self.defaultLevel];
}

- (void)NSLogString:(NSString *)string
{
    NSLog(@"%@", string);
}

- (void)fileLogString:(NSString *)string
{
    [self.fileHandle writeString:string];
}

@end
