//
//  UIView+Loading.h
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFLoadingView.h"

/*********************************************************
 
    @category
        UIView (Loading)
 
    @abstract
        UIView的加载状态扩展
 
    @discussion
        1，内部引入了计数机制，每次启动加载都会计数加1，只有当计数为0时才会停止加载
        2，显示加载视图时，加载视图将充满基础视图
 
 *********************************************************/

@interface UIView (Loading)

/*!
 * @brief 使用指定加载视图开始加载
 * @param loadingView 加载视图
 * @discussion 若加载视图与正在使用的视图不同，将替换正在使用的视图
 */
- (void)startLoadingWithView:(UFLoadingView *)loadingView;

/*!
 * @brief 立即停止加载
 */
- (void)stopLoading;

/*!
 * @brief 当计数为0时停止加载
 */
- (void)stopLoadingCountly;

@end
