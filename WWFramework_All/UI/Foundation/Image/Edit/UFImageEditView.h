//
//  UFImageEditView.h
//  Test
//
//  Created by ww on 16/3/11.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFImageEditMaskView.h"

/*********************************************************
 
    @class
        UFImageEditView
 
    @abstract
        图片编辑视图
 
    @discussion
        1，编辑操作支持移动，缩放和遮罩。
        2，支持使用遮罩编辑，使用遮罩时，编辑后的图片移动范围将被限定在遮罩编辑区域内。
 
 *********************************************************/

@interface UFImageEditView : UIView

/*!
 * @brief 图片对象
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 遮罩视图
 */
@property (nonatomic) UFImageEditMaskView *maskView;

/*!
 * @brief 编辑开关
 */
@property (nonatomic, getter=isEditEnabled) BOOL enableEdit;

/*!
 * @brief 当前编辑后的图片
 * @result 编辑后的图片
 */
- (UIImage *)currentEditedImage;

@end
