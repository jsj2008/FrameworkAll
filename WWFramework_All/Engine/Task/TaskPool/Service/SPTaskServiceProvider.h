//
//  SPTaskServiceProvider.h
//  FoundationProject
//
//  Created by Baymax on 14-1-3.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        SPTaskServiceProvider
 
    @abstract
        框架服务提供商，负责框架的启动和关闭
 
 *********************************************************/

@interface SPTaskServiceProvider : NSObject

/*!
 * @brief 单例
 */
+ (SPTaskServiceProvider *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 关闭
 */
- (void)stop;

@end
