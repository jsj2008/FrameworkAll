//
//  AHServerConfiguration.h
//  Application
//
//  Created by WW on 14-3-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTaskDaemonPool.h"
#import "HTTPTransaction.h"

/*********************************************************
 
    @class
        AHServerConfiguration
 
    @abstract
        HTTP服务器端配置项
 
 *********************************************************/

@interface AHServerConfiguration : NSObject

/*!
 * @brief 管理HTTP事务的任务池
 * @discussion 若为nil，则使用应用默认的任务池
 */
@property (nonatomic) SPTaskDaemonPool *taskPool;

/*!
 * @brief HTTP事务模板，服务器端将使用该模板类的HTTP事务来处理接收到的请求
 */
@property (nonatomic) HTTPTransaction *transactionTemplate;

@end
