//
//  UFImageViewGifUpdater.h
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFImageViewGifUpdater
 
    @abstract
        gif图片更新器
 
 *********************************************************/

@interface UFImageViewGifUpdater : NSObject

/*!
 * @brief 图片视图对象
 */
@property (nonatomic, weak) UIImageView *imageView;

/*!
 * @brief gif数据
 */
@property (nonatomic) NSData *gifData;

/*!
 * @brief 启动gif更新
 */
- (void)startUpdating;

/*!
 * @brief 停止gif更新
 */
- (void)stopUpdating;

/*!
 * @brief 暂停gif更新
 */
- (void)pauseUpdating;

/*!
 * @brief 继续gif更新
 */
- (void)resumeUpdating;

@end


/*********************************************************
 
    @class
        UFImageViewGifImageSource
 
    @abstract
        gif图片数据源
 
 *********************************************************/

@interface UFImageViewGifImageSource : NSObject

/*!
 * @brief 图片数据
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 图片持续时间
 * @discussion 在动态gif中用于控制图片切换
 */
@property (nonatomic) NSTimeInterval duration;

@end
