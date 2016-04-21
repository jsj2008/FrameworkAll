//
//  HTTPDownloader.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPDownloadRequest.h"
#import "HTTPResponse.h"
#import "HTTPTransaction.h"
#import "HTTPLoadCode.h"
#import "FileOutputStream.h"

@protocol HTTPDownloaderDelegate;


/*********************************************************
 
    @class
        HTTPDownloader
 
    @abstract
        HTTP下载器
 
    @discussion
        1，加载器内部实现了缓存数据的处理
        2，加载器的响应数据存放在文件中
        3，加载器允许断点续传功能
        4，加载器会通过代理协议向代理对象发送关于加载的消息
 
 *********************************************************/

@interface HTTPDownloader : NSObject <HTTPTransactionDelegate>

/*!
 * @brief 初始化
 * @param request HTTP请求
 * @result 初始化后的对象
 */
- (id)initWithRequest:(HTTPDownloadRequest *)request;

/*!
 * @brief HTTP账户
 * @discussion 与缓存数据相关
 */
@property (nonatomic) HTTPAccount *account;

/*!
 * @brief 是否允许断点续传
 */
@property (nonatomic) BOOL resumeEnable;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPDownloaderDelegate> delegate;

/*!
 * @brief 启动运行
 */
- (void)run;

/*!
 * @brief 取消
 */
- (void)cancel;

@end


/*********************************************************
 
    @protocol
        HTTPDownloaderDelegate
 
    @abstract
        HTTP下载器代理协议
 
 *********************************************************/

@protocol HTTPDownloaderDelegate <NSObject>

@required

/*!
 * @brief 下载结束
 * @param downloader 下载器
 * @param code 加载码
 * @param response 响应，response.bodyStream为FileOutputStream对象，并指向请求的文件路径。只有下载成功时response才不为nil
 */
- (void)HTTPDownloader:(HTTPDownloader *)downloader didFinishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response;

@optional

/*!
 * @brief 接收到响应头
 * @param downloader 下载器
 * @param URLResponse 响应头
 */
- (void)HTTPDownloader:(HTTPDownloader *)downloader didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 接收到响应数据
 * @param downloader 下载器
 * @param size 下载到的文件大小
 */
- (void)HTTPDownloader:(HTTPDownloader *)downloader didReceiveResponseBodySize:(unsigned long long)size;

/*!
 * @brief 是否通过本地验证
 * @discussion 对于需要服务端与客户端对称认证的请求，需要对服务端的响应进行本地验证
 * @param downloader 下载器
 * @param response 响应
 * @result 是否通过本地验证
 */
- (BOOL)HTTPDownloader:(HTTPDownloader *)downloader canPassLocalAuthenticationWithResponse:(HTTPResponse *)response;

@end
