//
//  HTTPDownloadHandle.h
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPLoadHandle.h"
#import "HTTPDownloader.h"
#import "HTTPLoadCode.h"

@protocol HTTPDownloadHandleDelegate;


/*********************************************************
 
    @class
        HTTPDownloadHandle
 
    @abstract
        HTTP下载句柄
 
    @discussion
        1，内部实现了请求的重定向
        2，内部实现了认证授权过程
        3，默认超时时间600秒
        4，加载句柄会通过代理协议向代理对象发送关于加载的消息
 
 *********************************************************/

@interface HTTPDownloadHandle : HTTPLoadHandle <HTTPDownloaderDelegate>

/*!
 * @brief 资源保存路径
 */
@property (nonatomic, copy) NSString *resourceSavingPath;

/*!
 * @brief 资源参考大小
 * @discussion 在某些服务器响应数据中，无法获取到资源的完整大小，导致断点续传等情况下无法判别资源是否下载完整，本参考值可用于帮助判断资源完整性
 */
@property (nonatomic) unsigned long long referencedResourceSize;

/*!
 * @brief 是否允许断点续传
 */
@property (nonatomic) BOOL resumeEnable;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPDownloadHandleDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        HTTPDownloadHandleDelegate
 
    @abstract
        HTTPDownloadHandle的代理协议
 
 *********************************************************/

@protocol HTTPDownloadHandleDelegate <NSObject>

/*!
 * @brief 加载结束
 * @param handle 加载句柄
 * @param code 加载码
 * @param response 响应头
 * @param path 资源路径，仅在下载完整时才不为nil
 */
- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didFinishWithCode:(HTTPLoadCode)code URLResponse:(NSHTTPURLResponse *)response dataPath:(NSString *)path;

/*!
 * @brief 接收到响应头
 * @param handle 加载句柄
 * @param response 响应头
 */
- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didReceiveURLResponse:(NSHTTPURLResponse *)response;

/*!
 * @brief 接收到响应数据
 * @param handle 加载句柄
 * @param size 下载到的文件大小
 */
- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didDownloadResourceSize:(unsigned long long)size;

@end
