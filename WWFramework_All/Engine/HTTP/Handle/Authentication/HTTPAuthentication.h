//
//  HTTPAuthentication.h
//  Application
//
//  Created by Baymax on 14-2-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPRequest, HTTPResponse;


/*********************************************************
 
    @class
        HTTPAuthentication
 
    @abstract
        HTTP认证，用于响应服务器质询
 
    @discussion
        1，HTTPAuthentication是一个纯基类，由子类实现具体功能
        2，request和account两个属性在HTTP连接过程中自动分配，不能在框架外部被赋值
 
 *********************************************************/

@interface HTTPAuthentication : NSObject

/*!
 * @brief HTTP请求
 */
@property (nonatomic) HTTPRequest *request;

/*!
 * @brief 对质询响应头的认证信息
 * @discussion 在接收到服务器质询时用本方法做出认证
 * @discussion 可在本方法内存储生成的认证信息
 * @param URLResponse 质询响应头
 * @result 认证首部，若为空，表明无认证信息可用，加载过程将结束
 */
- (NSDictionary<NSString *, NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse;

/*!
 * @brief 响应是否通过本地验证
 * @param response 响应
 * @discussion 若无法通过本地认证（即本方法返回NO），加载过程将以失败结束
 * @result 是否通过本地验证
 */
- (BOOL)canResponsePassLocalAuthencation:(HTTPResponse *)esponse;

/*!
 * @brief 向请求添加认证首部
 * @discussion 当通过认证后，通过本方法可以为之后的请求预先配置认证首部，可以避免反复认证
 * @discussion 每次加载前，都会调用本方法为请求添加认证首部
 */
- (void)addAuthenticationHeaderFieldsToRequest;

@end
