//
//  UFEmojiSet.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmoji.h"

/*********************************************************
 
    @class
        UFEmojiSet
 
    @abstract
        表情集
 
 *********************************************************/

@interface UFEmojiSet : NSObject

/*!
 * @brief 初始化表情集
 * @param emojiDictionary 表情字典
 * @result 表情集
 */
- (instancetype)initWithEmojiDictionary:(NSDictionary<NSString *, UFEmoji *> *)emojiDictionary;

/*!
 * @brief 获取指定的表情
 * @param key 表情键，用于检索表情
 * @result 表情对象
 */
- (UFEmoji *)emojiForKey:(NSString *)key;

@end
