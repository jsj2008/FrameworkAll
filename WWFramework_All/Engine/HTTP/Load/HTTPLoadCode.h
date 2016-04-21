//
//  HTTPLoadCode.h
//  FoundationProject
//
//  Created by Baymax on 14-2-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTransactionCode.h"

/*********************************************************
 
    @enum
        HTTPLoadCode
 
    @abstract
        HTTP加载码
 
 *********************************************************/

typedef enum
{
    HTTPLoadCode_Unknown                = -1,   // 未知错误
    
    HTTPLoadCode_OK                     = 0,    // 加载正确，服务器返回状态码200
    
    HTTPLoadCode_Cancel                 = 1,    // 取消
    HTTPLoadCode_TimeOut                = 2,    // 超时
    HTTPLoadCode_HTTPServiceUnavailable = 3,    // SHC框架网络服务不可用
    HTTPLoadCode_InvalidDownload        = 4,    // 无效下载（未指定下载路径）
    HTTPLoadCode_NoData                 = 5,    // 无数据
    HTTPLoadCode_URLError               = 6,    // URL错误
    
    HTTPLoadCode_ConnectFailed          = 11,   // 连接错误
    HTTPLoadCode_PartialData            = 12,   // 接收到部分数据，服务器返回状态码206
    HTTPLoadCode_DataFailed             = 13,   // 数据加工或解析失败
    HTTPLoadCode_SSLFailed              = 14,   // SSL错误
    
    HTTPLoadCode_AuthenticationFailed   = 21,   // 认证错误，通常是服务器返回的结果未通过本地认证
    
    HTTPLoadCode_Status                 = 101   // 服务器返回特殊状态码，需调用者解析
}HTTPLoadCode;


/*********************************************************
 
    @class
        HTTPLoadCodeSwitcher
 
    @abstract
        HTTP加载码转换器
 
 *********************************************************/

@interface HTTPLoadCodeSwitcher : NSObject

/*!
 * @brief 将HTTP事务码转换成HTTP加载码
 * @param code HTTP事务码
 * @param URLResponse 响应头
 * @result HTTP加载码
 */
+ (HTTPLoadCode)HTTPLoadCodeOfHTTPTransactionCode:(HTTPTransactionCode)code withReferencedURLResponse:(NSHTTPURLResponse *)URLResponse;

@end
