//
//  UFScrollLoadMoreUpdater.h
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFScrollLoadMoreView.h"

/*********************************************************
 
    @enum
        UFScrollLoadMoreStatus
 
    @abstract
        加载更多的状态
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFScrollLoadMoreStatus)
{
    UFScrollLoadMoreStatus_Reset = 0,    // 重置状态
    UFScrollLoadMoreStatus_Prepare = 1,  // 准备状态
    UFScrollLoadMoreStatus_Loading = 2   // 加载中状态
};


@protocol UFScrollLoadMoreUpdaterDelegate;


/*********************************************************
 
    @class
        UFScrollLoadMoreUpdater
 
    @abstract
        加载更多控制器
 
    @discussion
        1，加载视图的有效视图区域为其content size
        2，加载中状态时，不会触发加载视图的其它状态，加载结束后进入重置状态
        3，当滚动视图大小(frame)能容纳其内容区域和加载视图内容区域时，若手指拖动使得滚动视图contentOffset正偏移时，触发准备状态，负偏移时触发重置状态，手指未接触时，若启用自动加载模式（autoLoadingWhenContentSizeVisible），自动触发加载中状态，否则当偏移为0时触发加载中状态
        4，当滚动视图大小(frame)不能容纳其内容区域和加载视图内容区域时，若手指拖动，当加载视图完全可见时，触发准备状态，被遮挡时，触发重置状态，手指未接触时，当加载视图刚好完全可见时触发加载中状态
        5，控制器初始状态为重置状态
        6，加载视图大小自动调节，将填充滚动视图内容区域尾后的空白区域，若滚动视图内容区域大小为0，加载视图将会设置为0
        7，加载视图的content size变化时，控制器会自动更新内部设置来适配加载视图的显示
 
 *********************************************************/

@interface UFScrollLoadMoreUpdater : NSObject

/*!
 * @brief 初始化
 * @param scrollView 滚动视图
 * @param loadMoreView 加载视图
 * @result 初始化对象
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView loadMoreView:(UFScrollLoadMoreView *)loadMoreView;

/*!
 * @brief 滚动视图
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

/*!
 * @brief 加载视图
 */
@property (nonatomic, readonly) UFScrollLoadMoreView *loadMoreView;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollLoadMoreUpdaterDelegate> delegate;

/*!
 * @brief 当滚动视图大小(frame)能容纳其内容区域和加载视图区域时的自动加载模式
 */
@property (nonatomic) BOOL autoLoadingWhenContentSizeVisible;

/*!
 * @brief 加载更多功能的开关
 * @discussion 关闭加载更多功能，将不会触发此时间点后的任何加载相关动作，已触发的仍旧有效，加载视图的大小自动调节仍旧有效
 * @discussion 默认值YES
 */
@property (nonatomic, getter=isLoadMoreEnabled) BOOL enableLoadMore;

/*!
 * @brief 启动加载
 * @discussion 只有控制器在非加载中状态时才能启动，不会重复启动加载
 */
- (void)startLoadingMore;

/*!
 * @brief 停止加载
 * @discussion 只有控制器在加载中状态时才能停止，其它状态时不生效
 */
- (void)stopLoadingMore;

/*!
 * @brief 当前控制器状态
 * @discussion 控制器状态
 */
- (UFScrollLoadMoreStatus)currentLoadMoreStatus;

@end


/*********************************************************
 
    @class
        UFScrollLoadMoreUpdaterDelegate
 
    @abstract
        加载更多控制器的代理协议
 
 *********************************************************/

@protocol UFScrollLoadMoreUpdaterDelegate <NSObject>

/*!
 * @brief 控制器已启动加载更多
 * @param updater 控制器
 */
- (void)scrollLoadMoreUpdaterDidStartLoadingMore:(UFScrollLoadMoreUpdater *)updater;

/*!
 * @brief 控制器已停止加载更多
 * @param updater 控制器
 */
- (void)scrollLoadMoreUpdaterDidStopLoadingMore:(UFScrollLoadMoreUpdater *)updater;

@end
