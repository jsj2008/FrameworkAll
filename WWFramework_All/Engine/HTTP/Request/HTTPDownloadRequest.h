//
//  HTTPDownloadRequest.h
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPRequest.h"

/*********************************************************
 
    @class
        HTTPDownloadRequest
 
    @abstract
        HTTP下载请求
 
 *********************************************************/


@interface HTTPDownloadRequest : HTTPRequest

/*!
 * @brief 下载资源保存的文件位置
 */
@property (nonatomic, copy) NSString *savingPath;

/*!
 * @brief 下载资源大小的参考值
 * @discussion 在某些服务器响应数据中，无法获取到资源的完整大小，导致断点续传等情况下无法判别资源是否下载完整，本参考值可用于帮助判断资源完整性
 */
@property (nonatomic) unsigned long long referenceSize;

@end
