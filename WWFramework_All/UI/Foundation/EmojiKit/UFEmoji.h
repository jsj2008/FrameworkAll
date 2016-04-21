//
//  UFEmoji.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmojiImage.h"

/*********************************************************
 
    @class
        UFEmoji
 
    @abstract
        表情对象
 
 *********************************************************/

@interface UFEmoji : NSObject

/*!
 * @brief 表情名字
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 表情图片
 */
@property (nonatomic) UFEmojiImage *image;

@end
