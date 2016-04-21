//
//  APPLog.h
//  FoundationProject
//
//  Created by user on 13-12-10.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        APPLogLevel
 
    @abstract
        日志等级
 
 *********************************************************/

typedef enum
{
    APPLogLevel_Low    = 1,  // 低级打印，NSLog打印
    APPLogLevel_Middle = 2,  // 中级打印，文件打印
    APPLogLevel_High   = 3   // 高级打印，同时NSLog和文件打印
}APPLogLevel;


/*********************************************************
 
    @class
        APPLog
 
    @abstract
        日志系统，管理日志打印等
 
 *********************************************************/

@interface APPLog : NSObject

/*!
 * @brief 默认日志等级，默认为APPLogLevel_High
 */
@property (nonatomic) APPLogLevel defaultLevel;

/*!
 * @brief log文件目录
 */
@property (nonatomic, copy) NSString *logFileDirectory;

/*!
 * @brief 单例
 */
+ (APPLog *)sharedInstance;

/*!
 * @brief 启动日志
 */
- (void)start;

/*!
 * @brief 关闭日志，关闭后无法对日志进行任何操作
 */
- (void)stop;

/*!
 * @brief 清理日志
 * @discussion 清理工作将清除所有日志的相关数据
 */
- (void)cleanAllLog;

/*!
 * @brief 清理指定文件日志
 * @param path 日志路径
 */
- (void)cleanLogAtPath:(NSString *)path;

/*!
 * @brief 重置文件日志
 * @discussion 重置操作将新建日志文件作为当前操作文件
 */
- (void)resetLogs;

/*!
 * @brief 当前所有日志文件路径
 * @result 日志文件路径
 */
- (NSArray *)currentAllLogPathes;

/*!
 * @brief 指定日志等级打印日志
 * @param string 日志字符串
 * @param level 日志等级
 */
- (void)logString:(NSString *)string onLevel:(APPLogLevel)level;

/*!
 * @brief 按照默认日志等级打印日志
 * @param string 日志字符串
 */
- (void)logString:(NSString *)string;

@end
