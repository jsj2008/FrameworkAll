//
//  LogFileHandle.h
//  FoundationProject
//
//  Created by user on 13-12-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        LogFileHandle
 
    @abstract
        日志文件句柄，负责日志内容的文件保存
 
    @discussion
        1，日志文件目录结构为根目录＋文件名，文件名有两种类型：APPLogFileName和APPLogFileName＋时间信息，前者是当前日志文件，后者是旧日志文件
        2，每个日志文件大小受限（APPLogFileSize），超过限制后，将自动创建并启用新的日志文件，原日志文件将在文件名尾添加时间信息作为旧日志文件
 
 *********************************************************/

@interface LogFileHandle : NSObject
{
    // 文件根目录
    NSString *_rootDirectory;
}

/*!
 * @brief 初始化
 * @param rootDirectory 文件根目录
 * @result 初始化后的对象
 */
- (id)initWithRootDirectory:(NSString *)rootDirectory;

/*!
 * @brief 写入日志字符串
 * @param string 日志字符串
 */
- (void)writeString:(NSString *)string;

/*!
 * @brief 清理所有日志
 * @discussion 清理操作将删除所有当前根目录下的日志文件
 */
- (void)cleanAllLog;

/*!
 * @brief 清理指定文件日志
 * @param path 日志路径
 */
- (void)cleanLogAtPath:(NSString *)path;

/*!
 * @brief 重置文件日志
 * @discussion 重置操作将新建日志文件作为当前操作文件，之前已产生的日志文件将不再操作
 */
- (void)resetLogs;

/*!
 * @brief 当前所有日志文件路径
 * @result 日志文件路径
 */
- (NSArray *)currentAllLogPathes;

@end


/*!
 * @brief 日志文件名
 */
extern NSString * const APPLogFileName;

/*!
 * @brief 日志文件大小上限，4M字节
 */
extern const unsigned long long APPLogFileSize;
