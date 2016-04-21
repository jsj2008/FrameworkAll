//
//  ImageManager.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  ImageManagerDownloadObserving;


/*********************************************************
 
    @class
        ImageManager
 
    @abstract
        图片管理器
 
    @discussion
        管理器的操作和通知都是线程安全的
 
 *********************************************************/

@interface ImageManager : NSObject

/*!
 * @brief 单例
 */
+ (ImageManager *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 下载图片
 * @param URL 图片URL，支持HTTP和文件URL
 * @param observer 下载操作观察者，若为nil，将启动一个无观察者的下载任务，除非停止管理器工作，否则无法取消该下载任务
 * @discussion 下载通知将在本方法执行的线程上发送
 */
- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 * @param observer 下载操作观察者，nil无效
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL;

/*!
 * @brief 本地图片
 * @param URL 图片URL
 * @result 图片数据
 */
- (NSData *)localImageDataByURL:(NSURL *)URL;

@end


/*********************************************************
 
    @protocol
        ImageManagerDownloadObserving
 
    @abstract
        图片管理器图片下载协议
 
 *********************************************************/

@protocol ImageManagerDownloadObserving <NSObject>

/*!
 * @brief 图片下载完成
 * @param manager 管理器
 * @param URL 图片URL
 * @param successfully 下载是否成功
 * @param data 图片数据
 */
- (void)imageManager:(ImageManager *)manager didFinishDownloadImageByURL:(NSURL *)URL successfully:(BOOL)successfully withImageData:(NSData *)data;

@optional

/*!
 * @brief 图片下载进度
 * @param manager 管理器
 * @param URL 图片URL
 * @param progress 下载进度
 */
- (void)imageManager:(ImageManager *)manager didDownloadImageByURL:(NSURL *)URL withProgress:(float)progress;

@end
