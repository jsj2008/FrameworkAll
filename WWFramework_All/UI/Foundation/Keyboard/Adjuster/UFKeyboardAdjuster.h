//
//  UFKeyboardAdjuster.h
//  Test
//
//  Created by ww on 16/1/19.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFKeyboardAdjustPoint.h"

@protocol UFKeyboardAdjusterDelegate;


/*********************************************************
 
    @class
        UFKeyboardAdjuster
 
    @abstract
        适配器，根据键盘情况调节视图
 
 *********************************************************/

@interface UFKeyboardAdjuster : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UFKeyboardAdjusterDelegate> delegate;

/*!
 * @brief 适配开关
 */
@property (nonatomic, getter=isEnabled) BOOL enable;

/*!
 * @brief 适配点，使得键盘上边与适配点重合
 */
@property (nonatomic) UFKeyboardAdjustPoint *adjustingPoint;

/*!
 * @brief 还原点，键盘退回时，视图位置还原到该点
 * @discussion 具体意义由各个子类自行定义
 */
@property (nonatomic) UFKeyboardAdjustPoint *resettingPoint;

/*!
 * @brief 键盘调用者
 * @discussion 适配器将侦听调用者发出的键盘消息，只处理调用者的键盘事件
 */
@property (nonatomic, weak) id keyboardCaller;

/*!
 * @brief 适配视图到适配点
 */
- (void)adjust;

/*!
 * @brief 还原视图到还原点
 */
- (void)reset;

/*!
 * @brief 适配的视图
 * @result 视图对象
 */
- (UIView *)adjustedView;

@end


/*********************************************************
 
    @protocol
        UFKeyboardAdjusterDelegate
 
    @abstract
        适配器的代理通知
 
 *********************************************************/

@protocol UFKeyboardAdjusterDelegate <NSObject>

@optional

/*!
 * @brief 键盘改变frame的通知
 * @param adjuster 适配器
 * @param notification 通知对象
 */
- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification;

/*!
 * @brief 键盘改变frame的通知
 * @param adjuster 适配器
 * @param notification 通知对象
 */
- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardDidChangeFrameNotification:(NSNotification *)notification;

/*!
 * @brief 键盘退回的通知
 * @param adjuster 适配器
 * @param notification 通知对象
 */
- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardWillHideNotification:(NSNotification *)notification;

@end


/*********************************************************
 
    @class
        UFWindowBasedKeyboardAdjuster
 
    @abstract
        适配器，根据键盘情况调节window视图
 
    @discussion
        还原视图位置时，将配置window视图的y坐标到还原点
 
 *********************************************************/

@interface UFWindowBasedKeyboardAdjuster : UFKeyboardAdjuster

/*!
 * @brief window视图
 */
@property (nonatomic, weak) UIWindow *window;

@end


/*********************************************************
 
    @class
        UFScrollViewBasedKeyboardAdjuster
 
    @abstract
        适配器，根据键盘情况调节scroll视图
 
    @discussion
        1，适配视图时，若scroll视图的content size不足，将自动扩大content size以满足适配条件
        2，还原视图位置时，将配置scroll视图的offset的y偏移到还原点，并还原content size，若此时content size不足以显示offset时，将自动调节offset到可显示
 
 *********************************************************/

@interface UFScrollViewBasedKeyboardAdjuster : UFKeyboardAdjuster

/*!
 * @brief scroll视图
 */
@property (nonatomic, weak) UIScrollView *scrollView;

@end


/*********************************************************
 
    @category
        UIScrollView (KeyboardAdjust)
 
    @abstract
        scroll视图扩展，适配键盘自适应
 
 *********************************************************/

@interface UIScrollView (KeyboardAdjust)

/*!
 * @brief scroll视图在键盘适配时的原始content size
 */
@property (nonatomic) NSValue *originalKeyboardAdjustingContentSize;

@end
