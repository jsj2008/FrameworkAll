//
//  UITextView+KeyboardAdjust.m
//  Test
//
//  Created by ww on 16/1/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UITextView+KeyboardAdjust.h"
#import "UFTextViewKeyboardAdjustAssistant.h"
#import <objc/runtime.h>

static const char kUITextViewPropertyKey_ReferenceAdjustingPointToKeyboardSetting[] = "referenceAdjustingPointToKeyboardSetting";

static const char kUITextViewPropertyKey_ReferenceResettingPointToKeyboardSetting[] = "referenceResettingPointToKeyboardSetting";


@interface UITextView (KeyboardAdjust_Internal) <UFTextViewKeyboardAdjustAssistantDelegate>

@property (nonatomic) UFTextViewKeyboardAdjustAssistant *assistant;

@end


@implementation UITextView (KeyboardAdjust)

- (void)setReferenceAdjustingPointToKeyboardSetting:(textViewReferenceAdjustingPointToKeyboardSetting)referenceAdjustingPointToKeyboardSetting
{
    objc_setAssociatedObject(self, kUITextViewPropertyKey_ReferenceAdjustingPointToKeyboardSetting, referenceAdjustingPointToKeyboardSetting, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (textViewReferenceAdjustingPointToKeyboardSetting)referenceAdjustingPointToKeyboardSetting
{
    return objc_getAssociatedObject(self, kUITextViewPropertyKey_ReferenceAdjustingPointToKeyboardSetting);
}

- (void)setReferenceResettingPointToKeyboardSetting:(textViewReferenceResettingPointToKeyboardSetting)referenceResettingPointToKeyboardSetting
{
    objc_setAssociatedObject(self, kUITextViewPropertyKey_ReferenceResettingPointToKeyboardSetting, referenceResettingPointToKeyboardSetting, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (textViewReferenceResettingPointToKeyboardSetting)referenceResettingPointToKeyboardSetting
{
    return objc_getAssociatedObject(self, kUITextViewPropertyKey_ReferenceResettingPointToKeyboardSetting);
}

- (void)enableKeyboardAutoAdjustWithScrollView:(UIScrollView *)scrollView keyboardCaller:(id)keyboarder
{
    [super enableKeyboardAutoAdjustWithScrollView:scrollView keyboardCaller:keyboarder];
    
    UFTextViewKeyboardAdjustAssistant *assistant = [[UFTextViewKeyboardAdjustAssistant alloc] init];
    
    assistant.delegate = self;
    
    assistant.keyboardCaller = self;
    
    assistant.enable = YES;
    
    self.assistant = assistant;
}

- (void)enableKeyboardAutoAdjustWithWindow:(UIWindow *)window keyboardCaller:(id)keyboarder
{
    [super enableKeyboardAutoAdjustWithWindow:window keyboardCaller:keyboarder];
    
    UFTextViewKeyboardAdjustAssistant *assistant = [[UFTextViewKeyboardAdjustAssistant alloc] init];
    
    assistant.delegate = self;
    
    assistant.keyboardCaller = self;
    
    assistant.enable = YES;
    
    self.assistant = assistant;
}

- (UFKeyboardAdjustPoint *)referenceAdjustingPointToKeyboard
{
    UFKeyboardAdjustPoint *point = nil;
    
    if (self.referenceAdjustingPointToKeyboardSetting)
    {
        point = self.referenceAdjustingPointToKeyboardSetting();
    }
    else
    {
        CGRect rect = [self caretRectForPosition:self.selectedTextRange.start];
        
        point = [[UFKeyboardAdjustPoint alloc] init];
        
        point.point = CGPointMake(0, rect.origin.y + rect.size.height);
        
        point.view = self;
    }
    
    return point;
}

- (UFKeyboardAdjustPoint *)referenceResettingPointToKeyboard
{
    UFKeyboardAdjustPoint *point = nil;
    
    if (self.referenceResettingPointToKeyboardSetting)
    {
        point = self.referenceResettingPointToKeyboardSetting();
    }
    else
    {
        point = [[UFKeyboardAdjustPoint alloc] init];
        
        UIView *adjustedView = [self keyboardAutoAdjustedView];
        
        if ([adjustedView isKindOfClass:[UIScrollView class]])
        {
            point.point = ((UIScrollView *)adjustedView).contentOffset;
            
            point.view = adjustedView;
        }
        else
        {
            point.point = CGPointZero;
            
            point.view = adjustedView;
        }
    }
    
    return point;
}

- (BOOL)shouldAdjustWhenKeyboardDidChangeFrame
{
    return YES;
}

@end


static const char kUITextViewPropertyKey_KeyboardAssistant[] = "keyboardAssistant";


@implementation UITextView (KeyboardAdjust_Internal)

- (void)setAssistant:(UFTextViewKeyboardAdjustAssistant *)assistant
{
    objc_setAssociatedObject(self, kUITextViewPropertyKey_KeyboardAssistant, assistant, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFTextViewKeyboardAdjustAssistant *)assistant
{
    return objc_getAssociatedObject(self, kUITextViewPropertyKey_KeyboardAssistant);
}

- (void)textViewKeyboardAdjustAssistant:(UFTextViewKeyboardAdjustAssistant *)assistant didReceiveTextChangeNotification:(NSNotification *)notification
{
    [self adjust];
}

@end
