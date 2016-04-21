//
//  UFScrollRefreshUpdater.h
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFScrollRefreshView.h"

/*********************************************************
 
    @enum
        UFScrollLoadMoreStatus
 
    @abstract
        刷新状态
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFScrollRefreshStatus)
{
    UFScrollRefreshStatus_Reset = 0,    // 重置状态
    UFScrollRefreshStatus_Prepare = 1,  // 准备状态
    UFScrollRefreshStatus_Loading = 2   // 加载中状态
};


@protocol UFScrollRefreshUpdaterDelegate;


/*********************************************************
 
    @class
        UFScrollRefreshUpdater
 
    @abstract
        刷新控制器
 
    @discussion
        1，加载视图的有效视图区域为其content size
        2，加载中状态时，不会触发加载视图的其它状态，加载结束后进入重置状态
        3，手指拖动时，若加载视图内容完全可见时，触发准备状态，遮挡时触发重置状态，手指松开时，若加载视图内容完全可见，加载视图会滚动至内容刚好完全可见时触发加载，遮挡时，收回加载视图
        4，加载结束，滚动视图自动滚动收回加载视图
        4，控制器初始状态为重置状态
        5，滚动视图自动滚动时，将忽略任何对contentOffset的更改（意味着可以在滚动的同时处理cell）
        6，控制器提供模拟刷新操作，即滚动视图自动滚动到加载视图内容完全可见时触发加载
 
 *********************************************************/

@interface UFScrollRefreshUpdater : NSObject

/*!
 * @brief 初始化
 * @param scrollView 滚动视图
 * @param loadMoreView 加载视图
 * @result 初始化对象
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView refreshView:(UFScrollRefreshView *)refreshView;

/*!
 * @brief 滚动视图
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

/*!
 * @brief 加载视图
 */
@property (nonatomic, readonly) UFScrollRefreshView *refreshView;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollRefreshUpdaterDelegate> delegate;

/*!
 * @brief 刷新功能的开关
 * @discussion 关闭刷新功能，将不会触发此时间点后的任何加载相关动作，已触发的仍旧有效，加载视图的大小自动调节仍旧有效
 * @discussion 默认值YES
 */
@property (nonatomic, getter=isRefreshEnabled) BOOL enableRefresh;

/*!
 * @brief 模拟刷新
 */
- (void)simulateRefreshing;

/*!
 * @brief 启动刷新
 * @discussion 只有控制器在非加载中状态时才能启动，不会重复启动加载
 */
- (void)startRefreshing;

/*!
 * @brief 停止刷新
 * @discussion 只有控制器在加载中状态时才能停止，其它状态时不生效
 */
- (void)stopRefreshing;

/*!
 * @brief 当前控制器状态
 * @discussion 控制器状态
 */
- (UFScrollRefreshStatus)currentRefreshStatus;

@end


/*********************************************************
 
    @class
        UFScrollRefreshUpdaterDelegate
 
    @abstract
        刷新控制器的代理协议
 
 *********************************************************/

@protocol UFScrollRefreshUpdaterDelegate <NSObject>

/*!
 * @brief 控制器已启动刷新
 * @param updater 控制器
 */
- (void)scrollRefreshUpdaterDidStartRefreshing:(UFScrollRefreshUpdater *)updater;

/*!
 * @brief 控制器已停止刷新
 * @param updater 控制器
 */
- (void)scrollRefreshUpdaterDidStopRefreshing:(UFScrollRefreshUpdater *)updater;

@end
