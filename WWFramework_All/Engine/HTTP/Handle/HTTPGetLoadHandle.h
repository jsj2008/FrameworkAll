//
//  HTTPGetLoadHandle.h
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPLoadHandle.h"
#import "HTTPCachePolicy.h"
#import "OutputStream.h"
#import "OutputStreamResetting.h"
#import "HTTPLoadCode.h"
#import "HTTPLoader.h"

@protocol HTTPGetLoadHandleDelegate;


/*********************************************************
 
    @class
        HTTPGetLoadHandle
 
    @abstract
        HTTP的GET方式加载句柄
 
    @discussion
        1，允许配置缓存选项
        2，内部实现了请求的重定向
        3，内部实现了认证授权过程
        4，默认超时时间60秒
        5，允许外部接管响应数据的输出
        6，加载句柄会通过代理协议向代理对象发送关于加载的消息
 
 *********************************************************/

@interface HTTPGetLoadHandle : HTTPLoadHandle <HTTPLoaderDelegate>

/*!
 * @brief 自定义输出流
 * @discussion 用于接管响应数据的输出，接管后，响应数据不会被缓存
 */
@property (nonatomic) OutputStream<OutputStreamResetting> *customOutputStream;

/*!
 * @brief 缓存策略
 * @discussion 默认为HTTPCachePolicy_Default
 */
@property (nonatomic) HTTPCachePolicy cachePolicy;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPGetLoadHandleDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        HTTPGetLoadHandleDelegate
 
    @abstract
        HTTPGetLoadHandle代理协议
 
 *********************************************************/

@protocol HTTPGetLoadHandleDelegate <NSObject>

/*!
 * @brief 加载结束
 * @param handle 加载句柄
 * @param code 加载码
 * @param response 响应头
 * @param data 响应数据，当使用自定义输出流接管响应数据时，为nil
 */
- (void)HTTPGetLoadHandle:(HTTPGetLoadHandle *)handle didFinishWithCode:(HTTPLoadCode)code URLResponse:(NSHTTPURLResponse *)response data:(NSData *)data;

@end
