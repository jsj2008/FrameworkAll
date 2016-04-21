//
//  UIView+KeyboardAdjust.h
//  Test
//
//  Created by ww on 16/1/19.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFKeyboardAdjustPoint.h"

/*********************************************************
 
    @class
        UIView (KeyboardAdjust)
 
    @abstract
        视图的键盘适配扩展
 
 *********************************************************/

@interface UIView (KeyboardAdjust)

/*!
 * @brief 开启对scroll视图的键盘适配
 * @discussion 开启后，将只调整scroll视图来适配当前视图的位置
 * @param scrollView scroll视图
 * @param keyboarder 键盘调用者，视图将适配调用者引起的键盘事件，若为nil，将适配所有对象引起的键盘事件
 */
- (void)enableKeyboardAutoAdjustWithScrollView:(UIScrollView *)scrollView keyboardCaller:(id)keyboarder;

/*!
 * @brief 开启对window视图的键盘适配
 * @discussion 开启后，将只调整window视图来适配当前视图的位置
 * @param window window视图
 * @param keyboarder 键盘调用者，视图将适配调用者引起的键盘事件，若为nil，将适配所有对象引起的键盘事件
 */
- (void)enableKeyboardAutoAdjustWithWindow:(UIWindow *)window keyboardCaller:(id)keyboarder;

/*!
 * @brief 关闭键盘适配
 */
- (void)disableKeyboardAutoAdjust;

/*!
 * @brief 键盘适配的视图
 * @result 视图对象
 */
- (UIView *)keyboardAutoAdjustedView;

/*!
 * @brief 是否开启了适配
 * @result 是否开启
 */
- (BOOL)isKeyboardAutoAdjustEnabled;

/*!
 * @brief 键盘适配参考点
 * @discussion 键盘上边与适配点重合
 * @discussion 默认值为视图的左下角
 * @discussion 子类可重写本方法
 */
- (UFKeyboardAdjustPoint *)referenceAdjustingPointToKeyboard;

/*!
 * @brief 键盘还原参考点
 * @discussion 视图将尽量还原到参考点
 * @discussion 对于window视图，可准确还原到参考点；对于scroll视图，存在content size不足以显示还原点的情况，此时将在保证content size的前提下，尽量使得还原后的位置接近参考点
 * @discussion 默认值为：scroll视图，content offset；其它视图，原点
 * @discussion 子类可重写本方法
 */
- (UFKeyboardAdjustPoint *)referenceResettingPointToKeyboard;

/*!
 * @brief 是否应在键盘即将变化时适配
 * @discussion 如果是，适配过程将匹配键盘弹出动画
 * @discussion 子类可重写本方法
 * @result 是否在键盘即将变化时适配
 */
- (BOOL)shouldAdjustWhenKeyboardWillChangeFrame;

/*!
 * @brief 是否应在键盘变化完成时适配
 * @discussion 子类可重写本方法
 * @result 是否在键盘变化完成时适配
 */
- (BOOL)shouldAdjustWhenKeyboardDidChangeFrame;

/*!
 * @brief 强制适配
 */
- (void)adjust;

@end
