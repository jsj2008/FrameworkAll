//
//  UFTextViewPlaceHolder.h
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFTextViewPlaceHolder
 
    @abstract
        textView的placeHolder
 
 *********************************************************/

@interface UFTextViewPlaceHolder : NSObject

/*!
 * @brief 文本
 */
@property (nonatomic, copy) NSString *text;

/*!
 * @brief 字体颜色
 */
@property (nonatomic) UIColor *textColor;

/*!
 * @brief 字体
 */
@property (nonatomic) UIFont *font;

@end
