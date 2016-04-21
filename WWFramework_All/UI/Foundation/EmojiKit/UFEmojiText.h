//
//  UFEmojiText.h
//  Test
//
//  Created by ww on 15/12/25.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmojiSet.h"

@class UFEmojiTextSizeFitOption;

/*********************************************************
 
    @category
        NSString (Emoji)
 
    @abstract
        NSString的表情扩展
 
 *********************************************************/

@interface NSString (Emoji)

/*!
 * @brief 计算表情化后的文本大小
 * @param size 文本容器大小
 * @param attributes 文本属性
 * @param option 适配选项
 * @result 文本大小
 */
- (CGSize)emojiedBoundingSizeWithSize:(CGSize)size attributes:(nullable NSDictionary<NSString *, id> *)attributes fitOption:(nullable UFEmojiTextSizeFitOption *)option;

@end


/*********************************************************
 
    @category
        NSAttributedString (Emoji)
 
    @abstract
        NSAttributedString的表情扩展
 
 *********************************************************/

@interface NSAttributedString (Emoji)

/*!
 * @brief 计算表情化后的文本大小
 * @param size 文本容器大小
 * @param option 适配选项
 * @result 文本大小
 */
- (CGSize)emojiedBoundingSizeWithSize:(CGSize)size fitOption:(nullable UFEmojiTextSizeFitOption *)option;;

@end


/*********************************************************
 
    @enum
        UFEmojiTextSizeFitObjectType
 
    @abstract
        表情文本适配类型
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFEmojiTextSizeFitObjectType)
{
    UFEmojiTextSizeFitObjectType_Label = 1  // 适配Label
};


/*********************************************************
 
    @class
        UFEmojiTextSizeFitOption
 
    @abstract
        表情文本适配选项
 
 *********************************************************/

@interface UFEmojiTextSizeFitOption : NSObject

/*!
 * @brief 正则适配表达式
 */
@property (nonatomic, copy, nullable) NSString *pattern;

/*!
 * @brief 适配表情集
 */
@property (nonatomic, nullable) UFEmojiSet *emojiSet;

/*!
 * @brief 适配类型
 */
@property (nonatomic) UFEmojiTextSizeFitObjectType sizeFitObjectType;

@end
