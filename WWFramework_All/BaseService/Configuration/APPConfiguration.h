//
//  APPConfiguration.h
//  FoundationProject
//
//  Created by user on 13-12-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPConfiguration : NSObject

@end


/*********************************************************
 
    @const
        任务池并发量
 
    @discussion
        提供给SPTask框架使用
 
 *********************************************************/

/*!
 * @brief 守护任务池容量
 */
extern NSUInteger const APP_DaemonTaskPoolCapacity;

/*!
 * @brief 守护任务池常驻队列数量
 */
extern NSUInteger const APP_DaemonTaskPersistentQueueCount;

/*!
 * @brief 自由任务池容量
 */
extern NSUInteger const APP_FreeTaskPoolCapacity;

/*!
 * @brief 后台任务池容量
 */
extern NSUInteger const APP_BackgroundTaskPoolCapacity;

/*!
 * @brief 任务队列负载容量
 */
extern NSUInteger const APP_TaskQueueLoadingCapacity;


/*********************************************************
 
    @const
        应用文件系统目录
 
    @discussion
        提供给FileDirectoryCenter使用，用以定义应用内文件目录
 
 *********************************************************/

/*!
 * @brief 日志文件系统目录名
 */
extern NSString * const APP_LogFileDirectoryName;

/*!
 * @brief 垃圾箱目录名
 */
extern NSString * const APP_TrashFileDirectoryName;

/*!
 * @brief SHC框架目录名
 */
extern NSString * const APP_HTTPFileDirectoryName;

/*!
 * @brief 临时下载资源目录名
 */
extern NSString * const APP_TempResourceDownloadFileDirectoryName;

/*!
 * @brief HTTP多表单数据解析时的临时文件目录名
 */
extern NSString * const APP_HTTPMultipartParseDirectoryName;

/*!
 * @brief 业务数据目录名
 */
extern NSString * const APP_BusinessFileDirectoryName;

/*!
 * @brief 动作数据目录名
 */
extern NSString * const APP_BusinessActionFileDirectoryName;

/*!
 * @brief 图片数据目录名
 */
extern NSString * const APP_ImageFileDirectoryName;


/*********************************************************
 
    @const
        账户
 
    @discussion
        提供给AccountCenter使用，用以定义指定的账户信息
 
 *********************************************************/

/*!
 * @brief 默认用户账户id
 */
extern NSString * const APP_DefaultUserAccountId;

/*!
 * @brief 默认用户账户密码
 */
extern NSString * const APP_DefaultUserAccountPassword;

/*!
 * @brief 资源下载账户名
 */
extern NSString * const APP_ResourceDownloadAccountName;

/*!
 * @brief 资源下载账户密码
 */
extern NSString * const APP_ResourceDownloadAccountPassword;
