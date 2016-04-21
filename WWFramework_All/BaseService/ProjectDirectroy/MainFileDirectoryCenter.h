//
//  MainFileDirectoryCenter.h
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        MainFileDirectoryCenter
 
    @abstract
        文件目录中心，承载应用内的文件目录
 
 *********************************************************/

@interface MainFileDirectoryCenter : NSObject

/*!
 * @brief 单例
 */
+ (MainFileDirectoryCenter *)sharedInstance;

/*!
 * @brief 日志系统使用的文件根目录
 * @result 日志系统使用的文件根目录
 */
- (NSString *)logDirectory;

/*!
 * @brief 垃圾箱使用的文件根目录
 * @result 垃圾箱使用的文件根目录
 */
- (NSString *)trashDirectory;

/*!
 * @brief SHC框架使用的文件根目录
 * @result SHC框架使用的文件根目录
 */
- (NSString *)HTTPRootDirectory;

/*!
 * @brief 下载临时文件的根目录
 * @result 下载临时文件的根目录
 */
- (NSString *)tempResourceDownloadRootDirectory;

/*!
 * @brief 业务数据文件的根目录
 * @result 业务数据文件的根目录
 */
- (NSString *)BusinessFileRootDirectory;

/*!
 * @brief 动作文件的根目录
 * @result 动作文件的根目录
 */
- (NSString *)ActionFileRootDirectory;

/*!
 * @brief HTTP多表单数据解析时的临时文件的根目录
 * @result HTTP多表单数据解析时的临时文件的根目录
 */
- (NSString *)HTTPMultipartParseTempFileRootDirectory;

/*!
 * @brief 图片文件的根目录
 * @result 图片文件的根目录
 */
- (NSString *)imageRootDirectory;

/*!
 * @brief 临时图片文件的根目录
 * @result 临时图片文件的根目录
 */
- (NSString *)imageTempRootDirectory;

@end
