//
//  UFScrollLoadingView.h
//  Test
//
//  Created by ww on 16/2/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @enum
        UFScrollLoadingViewStatus
 
    @abstract
        加载视图的状态
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFScrollLoadingViewStatus)
{
    UFScrollLoadingViewStatus_Reset = 1,    // 重置状态
    UFScrollLoadingViewStatus_Prepare = 2,  // 准备状态
    UFScrollLoadingViewStatus_Loading = 3   // 加载中状态
};


@protocol UFScrollLoadingViewDelegate;


/*********************************************************
 
    @class
        UFScrollLoadingView
 
    @abstract
        加载视图
 
    @discussion
        1，本类是含有加载操作的视图的抽象类，封装了加载流程并提供了相应接口
        2，加载操作包含了重置，准备和加载中三种状态，初始状态为重置状态
 
 *********************************************************/

@interface UFScrollLoadingView : UIView

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollLoadingViewDelegate> delegate;

/*!
 * @brief 内容区域的大小
 * @discussion 内容区域是加载过程中的有效显示区域
 * @discussion 默认为frame宽，100高
 */
@property (nonatomic, readonly) CGSize contentSize;

/*!
 * @brief 视图状态
 */
@property (nonatomic) UFScrollLoadingViewStatus status;

/*!
 * @brief 启动
 * @discussion 封装了will, did, custom三个操作的流程
 */
- (void)start;

/*!
 * @brief 即将启动
 */
- (void)willStart;

/*!
 * @brief 已经启动
 */
- (void)didStart;

/*!
 * @brief 自定义启动操作
 * @discussion 子类可重写本方法实现自定义的启动操作
 */
- (void)customStart;

/*!
 * @brief 停止
 * @discussion 封装了will, did, custom三个操作的流程
 */
- (void)stop;

/*!
 * @brief 即将停止
 */
- (void)willStop;

/*!
 * @brief 已经停止
 */
- (void)didStop;

/*!
 * @brief 自定义停止操作
 * @discussion 子类可重写本方法实现自定义的停止操作
 */
- (void)customStop;

/*!
 * @brief 准备
 * @discussion 封装了will, did, custom三个操作的流程
 */
- (void)prepare;

/*!
 * @brief 即将准备
 */
- (void)willPrepare;

/*!
 * @brief 已经准备
 */
- (void)didPrepare;

/*!
 * @brief 自定义准备操作
 */
- (void)customPrepare;

/*!
 * @brief 重置
 * @discussion 封装了will, did, custom三个操作的流程
 */
- (void)reset;

/*!
 * @brief 即将重置
 */
- (void)willReset;

/*!
 * @brief 已经重置
 */
- (void)didReset;

/*!
 * @brief 自定义重置操作
 * @discussion 子类可重写本方法实现自定义的重置操作
 */
- (void)customReset;

@end


/*********************************************************
 
    @class
        UFScrollLoadingViewDelegate
 
    @abstract
        加载视图的代理协议
 
 *********************************************************/

@protocol UFScrollLoadingViewDelegate <NSObject>

@optional

/*!
 * @brief 视图即将启动加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewWillStart:(UFScrollLoadingView *)view;

/*!
 * @brief 视图已经启动加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewDidStart:(UFScrollLoadingView *)view;

/*!
 * @brief 视图即将停止加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewWillStop:(UFScrollLoadingView *)view;

/*!
 * @brief 视图已经停止加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewDidStop:(UFScrollLoadingView *)view;

/*!
 * @brief 视图即将准备加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewWillPrepare:(UFScrollLoadingView *)view;

/*!
 * @brief 视图已经准备加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewDidPrepare:(UFScrollLoadingView *)view;

/*!
 * @brief 视图即将重置加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewWillReset:(UFScrollLoadingView *)view;

/*!
 * @brief 视图已经重置加载
 * @param view 加载视图
 */
- (void)scrollLoadingViewDidReset:(UFScrollLoadingView *)view;

/*!
 * @brief 视图内容区域大小改变
 * @param view 加载视图
 */
- (void)scrollLoadingViewDidChangeContentSize:(UFScrollLoadingView *)view;

@end
