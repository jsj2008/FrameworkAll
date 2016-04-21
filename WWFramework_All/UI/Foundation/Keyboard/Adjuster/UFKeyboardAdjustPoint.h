//
//  UFKeyboardAdjustPoint.h
//  Test
//
//  Created by ww on 16/1/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFKeyboardAdjustPoint
 
    @abstract
        键盘适应时的点对象，用于在视图转换的计算时传递点的准确信息
 
 *********************************************************/

@interface UFKeyboardAdjustPoint : NSObject

/*!
 * @brief 位置数据
 */
@property (nonatomic) CGPoint point;

/*!
 * @brief 点所在的视图
 */
@property (nonatomic, weak) UIView *view;

@end
