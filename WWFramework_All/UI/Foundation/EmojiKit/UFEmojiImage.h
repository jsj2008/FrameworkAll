//
//  UFEmojiImage.h
//  Test
//
//  Created by ww on 15/12/24.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UFEmojiImageSource;


/*********************************************************
 
    @class
        UFEmojiImage
 
    @abstract
        表情图片
 
 *********************************************************/

@interface UFEmojiImage : NSObject

/*!
 * @brief 表情图片资源
 */
@property (nonatomic, readonly) NSArray<UFEmojiImageSource *> *imageSources;

/*!
 * @brief 表情图片是否可更新
 * @discussion 若图片可更新，表情系统将自动刷新表情，适用于gif等动态图片；png等静态图片默认不可更新
 */
@property (nonatomic) BOOL updatable;

/*!
 * @brief 根据bundle内图片名字创建表情图片
 * @discussion 内部会调用[UIImage imageNamed:name]方法创建图片
 * @discussion 创建的表情图片默认是不可更新的
 * @param name 图片名字
 * @result 表情图片
 */
+ (UFEmojiImage *)emojiImageNamed:(NSString *)name;

/*!
 * @brief 根据图片文件路径创建表情图片
 * @discussion 创建的表情图片默认是不可更新的
 * @param name 图片文件路径
 * @result 表情图片
 */
+ (UFEmojiImage *)emojiImageWithPath:(NSString *)path;

/*!
 * @brief 根据gif图片文件路径创建表情图片
 * @discussion 创建的表情图片默认是可更新的
 * @param name 图片文件路径
 * @result 表情图片
 */
+ (UFEmojiImage *)emojiImageWithGifPath:(NSString *)gifPath;

@end


/*********************************************************
 
    @class
        UFEmojiImage
 
    @abstract
        表情图片资源
 
 *********************************************************/

@interface UFEmojiImageSource : NSObject

/*!
 * @brief 图片数据
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 图片持续时间
 * @discussion 在动态表情中用于控制图片切换
 */
@property (nonatomic) NSTimeInterval duration;

@end
