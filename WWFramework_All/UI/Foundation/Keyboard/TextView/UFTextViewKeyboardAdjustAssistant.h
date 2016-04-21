//
//  UFTextViewKeyboardAdjustAssistant.h
//  Test
//
//  Created by ww on 16/2/2.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UFTextViewKeyboardAdjustAssistantDelegate;


/*********************************************************
 
    @class
        UFTextViewKeyboardAdjustAssistant
 
    @abstract
        UITextView键盘适配助手
 
 *********************************************************/

@interface UFTextViewKeyboardAdjustAssistant : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UFTextViewKeyboardAdjustAssistantDelegate> delegate;

/*!
 * @brief 键盘调用者
 * @discussion 适配器将侦听调用者发出的键盘消息，只处理调用者的键盘事件
 */
@property (nonatomic, weak) id keyboardCaller;

/*!
 * @brief 适配开关
 */
@property (nonatomic, getter=isEnabled) BOOL enable;

@end


/*********************************************************
 
    @protocol
        UFTextViewKeyboardAdjustAssistantDelegate
 
    @abstract
        UITextView键盘适配助手的代理通知
 
 *********************************************************/

@protocol UFTextViewKeyboardAdjustAssistantDelegate <NSObject>

/*!
 * @brief 文本改变的通知
 * @param assistant 适配助手
 * @param notification 通知对象
 */
- (void)textViewKeyboardAdjustAssistant:(UFTextViewKeyboardAdjustAssistant *)assistant didReceiveTextChangeNotification:(NSNotification *)notification;

@end
