//
//  UFTextViewKeyboardAdjustAssistant.m
//  Test
//
//  Created by ww on 16/2/2.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFTextViewKeyboardAdjustAssistant.h"

@interface UFTextViewKeyboardAdjustAssistant ()

- (void)didReceiveTextChangeNotification:(NSNotification *)notification;

@end


@implementation UFTextViewKeyboardAdjustAssistant

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    if (enable)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    }
    else
    {
        ;
    }
}

- (void)didReceiveTextChangeNotification:(NSNotification *)notification
{
    if ([self.keyboardCaller isFirstResponder] && self.delegate && [self.delegate respondsToSelector:@selector(textViewKeyboardAdjustAssistant:didReceiveTextChangeNotification:)])
    {
        [self.delegate textViewKeyboardAdjustAssistant:self didReceiveTextChangeNotification:notification];
    }
}

@end
