//
//  UFImageViewURLLoader.h
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UFImageViewURLLoadingCompletion)(NSURL *URL);


/*********************************************************
 
    @class
        UFImageViewURLLoader
 
    @abstract
        ImageView的URL图片加载器
 
    @discussion
        在dealloc时，将自动取消正在进行的加载操作
 
 *********************************************************/

@interface UFImageViewURLLoader : NSObject

/*!
 * @brief imageView
 */
@property (nonatomic, weak) UIImageView *imageView;

/*!
 * @brief 图片URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 是否使用图片加载时的占位图
 */
@property (nonatomic, getter=isPlaceHolderImageEnabled) BOOL enablePlaceHolderImage;

/*!
 * @brief 图片加载时的占位图
 */
@property (nonatomic) UIImage *placeHolderImage;

/*!
 * @brief 是否使用图片加载失败时的图
 */
@property (nonatomic, getter=isFailureImageEnabled) BOOL enableFailureImage;

/*!
 * @brief 图片加载失败时的图
 */
@property (nonatomic) UIImage *failureImage;

/*!
 * @brief 图片加载完成时的回调block
 */
@property (nonatomic, copy) UFImageViewURLLoadingCompletion completion;

/*!
 * @brief 加载图片
 */
- (void)load;

/*!
 * @brief 取消加载
 */
- (void)cancel;

@end
