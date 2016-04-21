//
//  ResourceLoadHandle.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceRequest.h"
#import "ResourceLoadTask.h"

@protocol ResourceLoadHandleDelegate;


/*********************************************************
 
    @class
        ResourceLoadHandle
 
    @abstract
        资源加载句柄
 
    @discussion
        1，使用内存加载方式
        2，加载操作是异步的，加载结果通过协议消息发送
        3，允许文件和HTTP资源加载
        4，当多个请求同时请求同一资源时，这些请求将共用一个加载，加载结果将正确通知到这些请求
 
    @thread
        句柄的操作都是线程不安全的
 
 *********************************************************/

@interface ResourceLoadHandle : NSObject <ResourceLoadTaskDelegate>

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<ResourceLoadHandleDelegate> delegate;

/*!
 * @brief 加载资源
 * @discussion 允许同时加载文件和HTTP资源
 * @param requests 资源请求
 */
- (void)loadResourceRequests:(NSArray<ResourceRequest *> *)requests;

/*!
 * @brief 取消
 */
- (void)cancel;

/*!
 * @brief 取消加载指定资源
 * @discussion 取消加载指定请求的资源时，若有其他请求也在加载同一资源，则加载操作仍继续，指定请求从加载操作中剥离，并停止向代理对象发送指定请求的消息，其他请求不受影响
 * @param request 资源请求
 */
- (void)cancelLoadingRequest:(ResourceRequest *)request;

@end


/*********************************************************
 
    @protocol
        ResourceLoadHandleDelegate
 
    @abstract
        资源加载代理协议
 
 *********************************************************/

@protocol ResourceLoadHandleDelegate <NSObject>

/*!
 * @brief 加载到指定资源
 * @param handle 加载句柄
 * @param request 资源请求
 * @param code 加载状态码
 * @param content 资源内容
 */
- (void)resourceLoadHandle:(ResourceLoadHandle *)handle didLoadResourceOfRequest:(ResourceRequest *)request withCode:(ResourceLoadCode)code content:(NSData *)content;

@end


/*********************************************************
 
    @class
        ResourceLoadHandleContext
 
    @abstract
        资源加载上下文
 
 *********************************************************/

@interface ResourceLoadHandleContext : NSObject

@end
