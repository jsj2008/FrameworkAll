//
//  UFImageEditMaskView.h
//  Test
//
//  Created by ww on 16/3/11.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFImageEditMaskView
 
    @abstract
        图片编辑遮罩视图
 
    @discussion
        本类是一个抽象类，必须由子类实现具体功能
 
 *********************************************************/

@interface UFImageEditMaskView : UIView

/*!
 * @brief 可编辑区域
 * @discussion 可编辑区域内的视图内容为可用内容，区域外的视图内容视为遮罩内容
 * @discussion 需子类重写本方法，默认值为CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
 * @result 可编辑区域
 */
- (CGRect)editableRect;

@end
