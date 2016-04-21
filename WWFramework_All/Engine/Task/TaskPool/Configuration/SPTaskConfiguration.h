//
//  SPTaskConfiguration.h
//  FoundationProject
//
//  Created by Baymax on 13-12-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        SPTaskConfiguration
 
    @abstract
        SPTask框架配置项
 
 *********************************************************/

@interface SPTaskConfiguration : NSObject

/*!
 * @brief 守护池容量，默认5
 */
@property (nonatomic) NSUInteger daemonPoolCapacity;

/*!
 * @brief 守护池的常驻队列容量，默认2
 */
@property (nonatomic) NSUInteger daemonPoolPersistentQueueCapacity;

/*!
 * @brief 自由池容量，默认20
 */
@property (nonatomic) NSUInteger freePoolCapacity;

/*!
 * @brief 后台池容量，默认10
 */
@property (nonatomic) NSUInteger backgroundPoolCapacity;

/*!
 * @brief 队列负载容量，默认20
 */
@property (nonatomic) NSUInteger defaultQueueLoadingLimit;

/*!
 * @brief 单例
 */
+ (SPTaskConfiguration *)sharedInstance;

@end
