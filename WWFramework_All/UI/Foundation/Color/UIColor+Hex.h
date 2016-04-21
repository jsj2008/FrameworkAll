//
//  UIColor+Hex.h
//  WWFramework_All
//
//  Created by ww on 15/12/17.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UIColor (Hex)
 
    @abstract
        UIColor的十六进制扩展
 
 *********************************************************/

@interface UIColor (Hex)

/*!
 * @brief 使用十六进制生成UIColor对象
 * @param hexRGB 十六进制RGB
 * @param alpha alpha值
 * @result UIColor对象
 */
+ (UIColor *)colorWithHexRGB:(NSUInteger)hexRGB alpha:(CGFloat)alpha;

@end
