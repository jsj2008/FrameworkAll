//
//  UFViewLoadingUpdater.h
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFLoadingView.h"

/*********************************************************
 
    @class
        UFViewLoadingUpdater
 
    @abstract
        视图加载控制器
 
    @discussion
        1，内部引入了计数机制，每次启动加载都会计数加1，只有当计数为0时才会停止加载
        2，显示加载视图时，加载视图将充满基础视图
 
 *********************************************************/

@interface UFViewLoadingUpdater : NSObject

/*!
 * @brief 基础视图
 */
@property (nonatomic, weak) UIView *view;

/*!
 * @brief 加载视图
 */
@property (nonatomic) UFLoadingView *loadingView;

/*!
 * @brief 启动加载
 */
- (void)start;

/*!
 * @brief 停止加载
 */
- (void)stop;

/*!
 * @brief 计数为0时停止加载
 */
- (void)stopCountly;

@end
