//
//  UFLoadingView.h
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFLoadingView
 
    @abstract
        加载视图
 
 *********************************************************/

@interface UFLoadingView : UIView

/*!
 * @brief 加载标志
 */
@property (nonatomic) BOOL isLoading;

/*!
 * @brief 启动加载
 */
- (void)startLoading;

/*!
 * @brief 自定义启动加载
 * @discussion 子类可重写本方法实现自定义效果
 */
- (void)customStartLoading;

/*!
 * @brief 停止加载
 */
- (void)stopLoading;

/*!
 * @brief 自定义停止加载
 * @discussion 子类可重写本方法实现自定义效果
 */
- (void)customStopLoading;

@end
