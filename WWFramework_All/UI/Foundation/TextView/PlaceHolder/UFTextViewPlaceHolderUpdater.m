//
//  UFTextViewPlaceHolderUpdater.m
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFTextViewPlaceHolderUpdater.h"

@interface UFTextViewPlaceHolderUpdater ()
{
    __weak UITextView *_textView;
}

@property (nonatomic) BOOL isPlaceHolding;

@property (nonatomic) BOOL isEditing;

@property (nonatomic) UIColor *textColor;

@property (nonatomic) UIFont *font;

- (void)didReceiveTextViewTextDidBeginEditingNotification:(NSNotification *)notification;

- (void)didReceiveTextViewTextDidEndEditingNotification:(NSNotification *)notification;

@end


@implementation UFTextViewPlaceHolderUpdater

@synthesize textView = _textView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextView:(UITextView *)textView
{
    _textView = textView;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewTextDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)setPlaceHolder:(UFTextViewPlaceHolder *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.textColor = self.textView.textColor;
    
    self.font = self.textView.font;
    
    if (!self.isEditing && [self.textView.text length] == 0)
    {
        self.textView.text = self.placeHolder.text;
        
        self.textView.textColor = self.placeHolder.textColor;
        
        self.textView.font = self.placeHolder.font;
        
        self.isPlaceHolding = YES;
    }
}

- (void)didReceiveTextViewTextDidBeginEditingNotification:(NSNotification *)notification
{
    self.isEditing = YES;
    
    if (self.isPlaceHolding)
    {
        self.textView.text = nil;
        
        self.textView.textColor = self.textColor;
        
        self.textView.font = self.font;
        
        self.isPlaceHolding = NO;
    }
}

- (void)didReceiveTextViewTextDidEndEditingNotification:(NSNotification *)notification
{
    self.isEditing = NO;
    
    self.textColor = self.textView.textColor;
    
    if ([self.textView.text length] == 0)
    {
        self.textView.text = self.placeHolder.text;
        
        self.textView.textColor = self.placeHolder.textColor;
        
        self.textView.font = self.placeHolder.font;
        
        self.isPlaceHolding = YES;
    }
}

@end
