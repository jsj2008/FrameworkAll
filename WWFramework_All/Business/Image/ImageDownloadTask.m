//
//  ImageDownloadTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageDownloadTask.h"
#import "HTTPDownloadHandle.h"
#include "HTTPHeaderFields.h"

@interface ImageDownloadTask () <HTTPDownloadHandleDelegate>

/*!
 * @brief 下载器
 */
@property (nonatomic) HTTPDownloadHandle *downloadHandle;

/*!
 * @brief 图片尺寸
 */
@property (nonatomic) unsigned long long imageSize;

/*!
 * @brief 结束任务
 * @param successfully 下载是否成功
 * @param data 图片数据
 */
- (void)finishSuccessfully:(BOOL)successfully withData:(NSData *)data;

@end


@implementation ImageDownloadTask

- (void)run
{
    if ([self.imageURL.scheme isEqualToString:@"http"] || [self.imageURL.scheme isEqualToString:@"https"])
    {
        HTTPDownloadHandle *handle = [[HTTPDownloadHandle alloc] initWithURL:self.imageURL];
        
        handle.account = self.account;
        
        handle.timeout = 60;
        
        handle.resourceSavingPath = self.savingPath;
        
        handle.resumeEnable = NO;
        
        handle.delegate = self;
        
        self.downloadHandle = handle;
        
        [self.downloadHandle run];
    }
    else
    {
        [self finishSuccessfully:NO withData:nil];
    }
}

- (void)cancel
{
    [self.downloadHandle cancel];
}

- (void)finishSuccessfully:(BOOL)successfully withData:(NSData *)data
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadTask:didFinishSuccessfully:withImageData:)])
        {
            [self.delegate imageDownloadTask:self didFinishSuccessfully:successfully withImageData:data];
        }
    }];
}

- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didFinishWithCode:(HTTPLoadCode)code URLResponse:(NSHTTPURLResponse *)response dataPath:(NSString *)path
{
    BOOL success = (code == HTTPLoadCode_OK);
    
    [self finishSuccessfully:success withData:(success ? [[NSData alloc] initWithContentsOfFile:path] : nil)];
}

- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didReceiveURLResponse:(NSHTTPURLResponse *)response
{
    HTTPHeaderFields *headerFields = [[HTTPHeaderFields alloc] initWithHTTPResponse:response];
    
    self.imageSize = [headerFields contentLength];
}

- (void)HTTPDownloadHandle:(HTTPDownloadHandle *)handle didDownloadResourceSize:(unsigned long long)size
{
    [self notify:^{
        
        if ([self.delegate respondsToSelector:@selector(imageDownloadTask:didDownloadImageWithProgress:)])
        {
            [self.delegate imageDownloadTask:self didDownloadImageWithProgress:(self.imageSize > 0) ? MIN((size / self.imageSize), 1) : -1];
        }
    }]; 
}

@end
