//
//  UIImageView+Gif.h
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UIImageView (Gif)
 
    @abstract
        UIImageView的gif扩展
 
 *********************************************************/

@interface UIImageView (Gif)

/*!
 * @brief gif数据
 */
@property (nonatomic) NSData *gifData;

/*!
 * @brief 启动gif更新
 */
- (void)startGifAnimating;

/*!
 * @brief 停止gif更新
 */
- (void)stopGifAnimating;

/*!
 * @brief 暂停gif更新
 */
- (void)pauseGifAnimating;

/*!
 * @brief 继续gif更新
 */
- (void)resumeGifAnimating;

@end
