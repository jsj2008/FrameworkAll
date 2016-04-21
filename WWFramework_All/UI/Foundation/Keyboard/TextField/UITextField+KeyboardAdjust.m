//
//  UITextField+KeyboardAdjust.m
//  Test
//
//  Created by ww on 16/1/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UITextField+KeyboardAdjust.h"
#import <objc/runtime.h>

static const char kUITextFieldPropertyKey_ReferenceAdjustingPointToKeyboardSetting[] = "referenceAdjustingPointToKeyboardSetting";

static const char kUITextFieldPropertyKey_ReferenceResettingPointToKeyboardSetting[] = "referenceResettingPointToKeyboardSetting";


@implementation UITextField (KeyboardAdjust)

- (void)setReferenceAdjustingPointToKeyboardSetting:(textFieldReferenceAdjustingPointToKeyboardSetting)referenceAdjustingPointToKeyboardSetting
{
    objc_setAssociatedObject(self, kUITextFieldPropertyKey_ReferenceAdjustingPointToKeyboardSetting, referenceAdjustingPointToKeyboardSetting, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (textFieldReferenceAdjustingPointToKeyboardSetting)referenceAdjustingPointToKeyboardSetting
{
    return objc_getAssociatedObject(self, kUITextFieldPropertyKey_ReferenceAdjustingPointToKeyboardSetting);
}

- (void)setReferenceResettingPointToKeyboardSetting:(textFieldReferenceResettingPointToKeyboardSetting)referenceResettingPointToKeyboardSetting
{
    objc_setAssociatedObject(self, kUITextFieldPropertyKey_ReferenceResettingPointToKeyboardSetting, referenceResettingPointToKeyboardSetting, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (textFieldReferenceResettingPointToKeyboardSetting)referenceResettingPointToKeyboardSetting
{
    return objc_getAssociatedObject(self, kUITextFieldPropertyKey_ReferenceResettingPointToKeyboardSetting);
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
        point = [[UFKeyboardAdjustPoint alloc] init];
        
        point.point = CGPointMake(0, self.frame.size.height);
        
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

- (BOOL)shouldAdjustWhenKeyboardWillChangeFrame
{
    return YES;
}

@end
