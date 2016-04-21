//
//  BCPHTTPTask.h
//  FoundationProject
//
//  Created by Baymax on 13-12-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationTask.h"

#pragma mark - BCPHTTPTask

/*********************************************************
 
    @class
        BCPHTTPTask
 
    @abstract
        业务通讯协议的HTTP任务
 
    @discussion
        本类是一个基类，必须由子类实现完整的功能（必须重新实现run方法）
 
 *********************************************************/

@interface BCPHTTPTask : FoundationTask
{
    NSURL *_URL;
}

/*!
 * @brief 初始化
 * @param URL 加载的URL
 * @result 初始化后的对象
 */
- (id)initWithURL:(NSURL *)URL;

/*!
 * @brief URL
 */
@property (nonatomic, readonly) NSURL *URL;

@end
