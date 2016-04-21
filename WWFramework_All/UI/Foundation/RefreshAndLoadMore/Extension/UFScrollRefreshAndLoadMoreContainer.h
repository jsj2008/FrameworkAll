//
//  UFScrollRefreshAndLoadMoreContainer.h
//  WWFramework_All
//
//  Created by ww on 16/2/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFScrollRefreshView.h"
#import "UFScrollLoadMoreView.h"

@protocol UFScrollRefreshAndLoadMoreContainerDelegate;


/*********************************************************
 
    @class
        UFScrollRefreshAndLoadMoreContainer
 
    @abstract
        刷新和加载更多控制器
 
    @discussion
        内部封装了刷新和加载更多的updater，刷新和加载更多的操作说明详见对应的updater
 
 *********************************************************/

@interface UFScrollRefreshAndLoadMoreContainer : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollRefreshAndLoadMoreContainerDelegate> delegate;

/*!
 * @brief 滚动视图
 */
@property (nonatomic) UIScrollView *scrollView;

/*!
 * @brief 刷新视图
 */
@property (nonatomic) UFScrollRefreshView *refreshView;

/*!
 * @brief 加载更多视图
 */
@property (nonatomic) UFScrollLoadMoreView *loadMoreView;

/*!
 * @brief 刷新功能开关
 */
@property (nonatomic, getter=isRefreshEnabled) BOOL enableRefresh;

/*!
 * @brief 加载更多功能开关
 */
@property (nonatomic, getter=isLoadMoreEnabled) BOOL enableLoadMore;

/*!
 * @brief 模拟刷新
 */
- (void)simulateRefreshing;

/*!
 * @brief 停止刷新
 * @param completion 停止后的操作回调
 */
- (void)stopRefreshingWithCompletion:(void (^)(void))completion;

/*!
 * @brief 停止加载更多
 * @param completion 停止后的操作回调
 */
- (void)stopLoadingMoreWithCompletion:(void (^)(void))completion;

@end


/*********************************************************
 
    @class
        UFScrollRefreshAndLoadMoreContainerDelegate
 
    @abstract
        刷新和加载更多控制器的代理协议
 
 *********************************************************/

@protocol UFScrollRefreshAndLoadMoreContainerDelegate <NSObject>

/*!
 * @brief 控制器已启动刷新
 * @param container 控制器
 */
- (void)scrollRefreshAndLoadMoreContainerDidStartRefresh:(UFScrollRefreshAndLoadMoreContainer *)container;

/*!
 * @brief 控制器已启动加载更多
 * @param container 控制器
 */
- (void)scrollRefreshAndLoadMoreContainerDidStartLoadMore:(UFScrollRefreshAndLoadMoreContainer *)container;

@end
