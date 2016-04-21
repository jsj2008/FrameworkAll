//
//  HTTPPostLoadHandle.h
//  Application
//
//  Created by Baymax on 14-2-18.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPLoadHandle.h"
#import "InputStream.h"
#import "InputStreamResetting.h"
#import "HTTPLoader.h"
#import "HTTPLoadCode.h"

@protocol HTTPPostLoadHandleDelegate;


/*********************************************************
 
    @class
        HTTPPostLoadHandle
 
    @abstract
        HTTP的POST方式加载句柄
 
    @discussion
        1，内部实现了请求的重定向
        2，内部实现了认证授权过程
        3，默认超时时间60秒
        4，加载句柄会通过代理协议向代理对象发送关于加载的消息
 
 *********************************************************/

@interface HTTPPostLoadHandle : HTTPLoadHandle <HTTPLoaderDelegate>

/*!
 * @brief 发送数据的输入流
 */
@property (nonatomic) InputStream<InputStreamResetting> *inputStream;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPPostLoadHandleDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        HTTPPostLoadHandleDelegate
 
    @abstract
        HTTPPostLoadHandle的代理协议
 
 *********************************************************/

@protocol HTTPPostLoadHandleDelegate <NSObject>

/*!
 * @brief 加载结束
 * @param handle 加载句柄
 * @param code 加载码
 * @param response 响应头
 * @param data 响应数据
 */
- (void)HTTPPostLoadHandle:(HTTPPostLoadHandle *)handle didFinishWithCode:(HTTPLoadCode)code URLResponse:(NSHTTPURLResponse *)response data:(NSData *)data;

/*!
 * @brief 发送数据
 * @discussion 由于发送的数据可能存在传输时压缩等情况，因此各个字节数参数需谨慎使用
 * @param handle 加载句柄
 * @param bytesWritten 本次发送字节数
 * @param totalBytesWritten 已发送总字节数
 * @param totalBytesExpectedToWrite 需发送总字节数
 */
- (void)HTTPPostLoadHandle:(HTTPPostLoadHandle *)handle didPostData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end
