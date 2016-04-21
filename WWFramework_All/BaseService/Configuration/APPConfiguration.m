//
//  APPConfiguration.m
//  FoundationProject
//
//  Created by user on 13-12-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "APPConfiguration.h"

@implementation APPConfiguration

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
NSUInteger const APP_DaemonTaskPoolCapacity = 5;

/*!
 * @brief 守护任务池常驻队列数量
 */
NSUInteger const APP_DaemonTaskPersistentQueueCount = 2;

/*!
 * @brief 自由任务池容量
 */
NSUInteger const APP_FreeTaskPoolCapacity = 20;

/*!
 * @brief 后台任务池容量
 */
NSUInteger const APP_BackgroundTaskPoolCapacity = 10;

/*!
 * @brief 任务队列负载容量
 */
NSUInteger const APP_TaskQueueLoadingCapacity = 20;


/*********************************************************
 
    @const
        应用文件系统目录
 
    @discussion
        提供给FileDirectoryCenter使用，用以定义应用内文件目录
 
 *********************************************************/

/*!
 * @brief 日志文件系统目录名
 */
NSString * const APP_LogFileDirectoryName = @"Log";

/*!
 * @brief 垃圾箱目录名
 */
NSString * const APP_TrashFileDirectoryName = @"Trash";

/*!
 * @brief HTTP框架目录名
 */
NSString * const APP_HTTPFileDirectoryName = @"HTTP";

/*!
 * @brief 临时下载资源目录名
 */
NSString * const APP_TempResourceDownloadFileDirectoryName = @"TempResourceDownload";

/*!
 * @brief HTTP多表单数据解析时的临时文件目录名
 */
NSString * const APP_HTTPMultipartParseDirectoryName = @"HTTPMultipart";

/*!
 * @brief 业务数据目录名
 */
NSString * const APP_BusinessFileDirectoryName = @"BU";

/*!
 * @brief 动作数据目录名
 */
NSString * const APP_BusinessActionFileDirectoryName = @"Action";

/*!
 * @brief 图片数据目录名
 */
NSString * const APP_ImageFileDirectoryName = @"Image";


/*********************************************************
 
    @const
        账户
 
    @discussion
        提供给AccountCenter使用，用以定义指定的账户信息
 
 *********************************************************/

/*!
 * @brief 默认用户账户名
 */
NSString * const APP_DefaultUserAccountId = @"guest";

/*!
 * @brief 默认用户账户密码
 */
NSString * const APP_DefaultUserAccountPassword = @"guest";

/*!
 * @brief 资源下载账户名
 */
NSString * const APP_ResourceDownloadAccountName = @"resource_download";

/*!
 * @brief 资源下载账户密码
 */
NSString * const APP_ResourceDownloadAccountPassword = @"resource_download";
