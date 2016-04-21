//
//  HTTPLoader.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPAccount.h"
#import "HTTPRequest.h"
#import "HTTPResponse.h"
#import "HTTPTransaction.h"
#import "HTTPLoadCode.h"

@protocol HTTPLoaderDelegate;


/*********************************************************
 
    @class
        HTTPLoader
 
    @abstract
        HTTP加载器，对一次HTTP加载过程的封装，只包含一次请求响应的交互过程
 
    @discussion
        1，加载器内部实现了缓存数据的处理，会保存成功的响应数据
        2，加载器的响应数据存放在内存中
        3，加载器允许使用外部输出流来接收响应数据，此时的响应的数据不会被缓存
        4，加载器会通过代理协议向代理对象发送关于加载的消息
 
 *********************************************************/

@interface HTTPLoader : NSObject <HTTPTransactionDelegate>

/*!
 * @brief 初始化
 * @param request HTTP请求
 * @result 初始化后的对象
 */
- (id)initWithRequest:(HTTPRequest *)request;

/*!
 * @brief HTTP账户
 * @discussion 与缓存数据相关
 */
@property (nonatomic) HTTPAccount *account;

/*!
 * @brief 是否允许加载缓存
 * @discussion 允许加载缓存时，将首先验证缓存数据有效性，若缓存有效，加载器使用缓存数据作为加载结果
 */
@property (nonatomic) BOOL cacheLoadEnable;

/*!
 * @brief 是否默认缓存私有
 * @discussion 处理缓存时将首先判断缓存是否私有，无法判断时使用本属性确定缓存私有性
 * @discussion 默认值为YES
 */
@property (nonatomic) BOOL defaultCachePrivate;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPLoaderDelegate> delegate;

/*!
 * @brief 启动运行
 */
- (void)run;

/*!
 * @brief 取消
 */
- (void)cancel;

/*!
 * @brief 自定义输出流
 * @discussion 自定义输出流用于接管接收响应数据
 */
@property (nonatomic) OutputStream *customOutputStream;

@end


/*********************************************************
 
    @protocol
        HTTPLoaderDelegate
 
    @abstract
        HTTP加载器代理协议
 
 *********************************************************/

@protocol HTTPLoaderDelegate <NSObject>

@required

/*!
 * @brief 加载结束
 * @param loader 加载器
 * @param code 加载码
 * @param response 响应，response.bodyStream为DataOutputStream对象或customOutputStream
 */
- (void)HTTPLoader:(HTTPLoader *)loader didFinishWithCode:(HTTPLoadCode)code response:(HTTPResponse *)response;

@optional

/*!
 * @brief 接收到响应头
 * @param loader 加载器
 * @param URLResponse 响应头
 */
- (void)HTTPLoader:(HTTPLoader *)loader didReceiveURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 接收到响应数据
 * @param loader 加载器
 * @param size 响应数据大小
 */
- (void)HTTPLoader:(HTTPLoader *)loader didReceiveResponseBodySize:(unsigned long long)size;

/*!
 * @brief 发送数据
 * @param loader 加载器
 * @param bytesWritten 本次发送字节数
 * @param totalBytesWritten 已发送总字节数
 * @param totalBytesExpectedToWrite 需发送总字节数
 */
- (void)HTTPLoader:(HTTPLoader *)loader didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

/*!
 * @brief 是否通过本地验证
 * @discussion 对于需要服务端与客户端对称认证的请求，需要对服务端的响应进行本地验证
 * @param loader 加载器
 * @param response 响应
 * @result 是否通过本地验证
 */
- (BOOL)HTTPLoader:(HTTPLoader *)loader canPassLocalAuthenticationWithResponse:(HTTPResponse *)response;

@end
