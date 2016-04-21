//
//  UIImageView+URL.h
//  WWFramework_All
//
//  Created by ww on 16/2/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFImageViewURLLoader.h"

/*********************************************************
 
    @category
        UIImageView (URL)
 
    @abstract
        UIImageView加载URL图片的扩展
 
 *********************************************************/

@interface UIImageView (URL)

/*!
 * @brief 设置图片URL并启动图片加载
 * @param URL 图片URL
 * @param placeHolderImage 占位图，若为nil，将保持原图，不会移除原图
 * @param completion 加载结束的回调
 * @discussion 通过设置URL为nil，可以取消正在进行中的图片加载操作，并将图片设置为占位图；
 */
- (void)setImageWithURL:(NSURL *)URL placeHolder:(UIImage *)placeHolderImage completion:(void (^)(NSURL *URL))completion;

/*!
 * @brief 取消URL图片加载
 */
- (void)cancelLoadingWithURL;

@end
