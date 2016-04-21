//
//  ImageDC.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/21/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        ImageDC
 
    @abstract
        图片数据中心
 
    @discussion
        数据中心的操作都是线程安全的
 
 *********************************************************/

@interface ImageDC : NSObject

/*!
 * @brief 单例
 */
+ (ImageDC *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 保存图片
 * @param URL 图片URL
 * @param data 图片数据
 */
- (void)saveImageByURL:(NSURL *)URL withData:(NSData *)data;

/*!
 * @brief 保存图片
 * @param URL 图片URL
 * @param dataPath 图片数据路径
 */
- (void)saveImageByURL:(NSURL *)URL withDataPath:(NSString *)dataPath;

/*!
 * @brief 获取图片数据
 * @param URL 图片URL
 * @return 图片数据
 */
- (NSData *)imageDataByURL:(NSURL *)URL;

@end


/*********************************************************
 
    @class
        ImageDC (TempResource)
 
    @abstract
        图片数据中心扩展，负责临时资源的处理
 
 *********************************************************/

@interface ImageDC (TempResource)

/*!
 * @brief 获取图片临时数据存放路径
 * @param URL 图片URL
 * @return 临时数据存放路径
 */
- (NSString *)tempImagePathByURL:(NSURL *)URL;

/*!
 * @brief 清理图片临时数据
 */
- (void)cleanTempResources;

@end
