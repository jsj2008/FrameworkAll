//
//  UFEmojiView.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmojiSet.h"
#import "UFAttributedStringEmojiUpdater.h"

/*********************************************************
 
    @class
        UFEmojiDataCenter
 
    @abstract
        表情数据中心，记录着表情相关数据
 
    @discussion
        使用表情时未指定表情相关数据，将使用本数据中心的数据填充
 
 *********************************************************/

@interface UFEmojiDataCenter : NSObject

/*!
 * @brief 单例
 */
+ (UFEmojiDataCenter *)sharedInstance;

/*!
 * @brief 适配表情集
 */
@property (nonatomic) UFEmojiSet *emojiSet;

/*!
 * @brief 正则适配表达式
 */
@property (nonatomic, copy) NSString *emojiPattern;

@end


/*********************************************************
 
    @category
        UIView (Emoji)
 
    @abstract
        UIView的表情扩展
 
 *********************************************************/

@interface UIView (Emoji) <UFAttributedStringEmojiUpdaterDelegate>

/*!
 * @brief 适配表情集
 */
@property (nonatomic) UFEmojiSet *emojiSet;

/*!
 * @brief 正则适配表达式
 */
@property (nonatomic, copy) NSString *emojiPattern;

@end


/*********************************************************
 
    @category
        UILabel (Emoji)
 
    @abstract
        UILabel的表情扩展
 
 *********************************************************/

@interface UILabel (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/*********************************************************
 
    @category
        UIButton (Emoji)
 
    @abstract
        UIButton的表情扩展
 
 *********************************************************/

@interface UIButton (Emoji)

/*!
 * @brief 显示表情
 * @param title 文本
 * @param state 按钮状态
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)setEmojiedAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state;

/*!
 * @brief 关闭表情
 * @param state 按钮状态
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmojiForState:(UIControlState)state;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @param state 按钮状态
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide forState:(UIControlState)state;

/*!
 * @brief 暂停表情
 * @param state 按钮状态
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmojiForState:(UIControlState)state;

/*!
 * @brief 继续表情
 * @param state 按钮状态
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmojiForState:(UIControlState)state;

@end


/*********************************************************
 
    @category
        UITextField (Emoji)
 
    @abstract
        UITextField的表情扩展
 
 *********************************************************/

@interface UITextField (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/*********************************************************
 
    @category
        UITextView (Emoji)
 
    @abstract
        UITextView的表情扩展
 
 *********************************************************/

@interface UITextView (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/* example
 
 UFEmoji *emoji = [[UFEmoji alloc] init];
 
 emoji.name = @"hello";
 
 emoji.image = [UFEmojiImage emojiImageWithGifPath:[[NSBundle mainBundle] pathForResource:@"bird1" ofType:@"gif"]];
 
 UFEmojiSet *set = [[UFEmojiSet alloc] initWithEmojiDictionary:[NSDictionary dictionaryWithObject:emoji forKey:@"[b]"]];
 
 [UFEmojiDataCenter sharedInstance].emojiSet = set;
 
 [UFEmojiDataCenter sharedInstance].emojiPattern = @".[b].";
 
 UILabel *label = [[UILabel alloc] init];
 
 label.text = @"123[b]456";
 
 label.font = [UIFont systemFontOfSize:30];
 
 [label showEmoji];
 
 */
