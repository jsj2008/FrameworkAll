//
//  HTTPRequest.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputStream.h"
#import "InputStreamResetting.h"

// copy特殊

/*********************************************************
 
    @class
        HTTPRequest
 
    @abstract
        HTTP请求
 
    @discussion
        HTTP请求的拷贝操作，对输入流不拷贝，仅retain
 
 *********************************************************/

@interface HTTPRequest : NSObject <NSCopying>

/*!
 * @brief URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 请求方法
 * @discussion 取值支持GET和POST
 */
@property (nonatomic, copy) NSString *method;

/*!
 * @brief 请求首部
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *headerFields;

/*!
 * @brief 超时时间
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 * @brief 输入流
 * @discussion POST方法中由输入流传递发送的数据
 */
@property (nonatomic) InputStream<InputStreamResetting> *bodyStream;

@end
