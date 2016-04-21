//
//  ResourceLoadTask.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "FoundationTask.h"
#import "ResourceRequest.h"
#import "ResourceLoadCode.h"
#import "HTTPGetLoadHandle.h"

@protocol ResourceLoadTaskDelegate;


/*********************************************************
 
    @class
        ResourceLoadTask
 
    @abstract
        资源加载任务
 
 *********************************************************/

@interface ResourceLoadTask : FoundationTask <HTTPGetLoadHandleDelegate>
{
    // 资源请求
    ResourceRequest *_request;
}

/*!
 * @brief 初始化
 * @param request 资源请求
 * @result 初始化后的对象
 */
- (id)initWithRequest:(ResourceRequest *)request;

/*!
 * @brief 资源请求
 */
@property (nonatomic, readonly) ResourceRequest *request;

@end


/*********************************************************
 
    @protocol
        ResourceLoadTaskDelegate
 
    @abstract
        资源加载任务的代理协议
 
 *********************************************************/

@protocol ResourceLoadTaskDelegate <NSObject>

/*!
 * @brief 加载结束
 * @param task 加载任务
 * @param code 加载状态码
 * @param content 数据内容
 */
- (void)resourceLoadTask:(ResourceLoadTask *)task didFinishLoadingWithCode:(ResourceLoadCode)code content:(NSData *)content;

@end
