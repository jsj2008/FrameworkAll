//
//  UIImage+Orientation.h
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UIImage (Orientation)
 
    @abstract
        UIImage的图片方向扩展
 
 *********************************************************/

@interface UIImage (Orientation)

/*!
 * @brief 校正图片方向
 * @result 图片
 */
- (UIImage *)imageWithOrientationFixed;

@end
