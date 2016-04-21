//
//  UITextField+KeyboardAdjust.h
//  Test
//
//  Created by ww on 16/1/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KeyboardAdjust.h"

/*!
 * @brief UITextField的键盘适配点设置
 */
typedef UFKeyboardAdjustPoint *(^textFieldReferenceAdjustingPointToKeyboardSetting)();

/*!
 * @brief UITextField的键盘还原点设置
 */
typedef UFKeyboardAdjustPoint *(^textFieldReferenceResettingPointToKeyboardSetting)();


/*********************************************************
 
    @category
        UITextField (KeyboardAdjust)
 
    @abstract
        UITextField的键盘适配扩展
 
 *********************************************************/

@interface UITextField (KeyboardAdjust)

/*!
 * @brief 适配点的设置
 * @discussion 若不设置，默认使用视图的左下角作为适配点
 */
@property (nonatomic, copy) textFieldReferenceAdjustingPointToKeyboardSetting referenceAdjustingPointToKeyboardSetting;

/*!
 * @brief 还原点的设置
 * @discussion 若不设置，默认使用scroll视图的content offset或其它视图的原点作为还原点
 */
@property (nonatomic, copy) textFieldReferenceResettingPointToKeyboardSetting referenceResettingPointToKeyboardSetting;

@end
