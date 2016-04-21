//
//  UIView+KeyboardAdjust.m
//  Test
//
//  Created by ww on 16/1/19.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UIView+KeyboardAdjust.h"
#import "UFKeyboardAdjuster.h"
#import <objc/runtime.h>

@interface UIView (KeyboardAdjust_Internal) <UFKeyboardAdjusterDelegate>

@property (nonatomic) UFKeyboardAdjuster *adjuster;

@end


@implementation UIView (KeyboardAdjust)

- (void)enableKeyboardAutoAdjustWithScrollView:(UIScrollView *)scrollView keyboardCaller:(id)keyboarder
{
    UFScrollViewBasedKeyboardAdjuster *adjuster = [[UFScrollViewBasedKeyboardAdjuster alloc] init];
    
    adjuster.scrollView = scrollView;
    
    adjuster.delegate = self;
    
    adjuster.keyboardCaller = keyboarder;
    
    adjuster.enable = YES;
    
    self.adjuster = adjuster;
}

- (void)enableKeyboardAutoAdjustWithWindow:(UIWindow *)window keyboardCaller:(id)keyboarder
{
    UFWindowBasedKeyboardAdjuster *adjuster = [[UFWindowBasedKeyboardAdjuster alloc] init];
    
    adjuster.window = window;
    
    adjuster.delegate = self;
    
    adjuster.keyboardCaller = keyboarder;
    
    adjuster.enable = YES;
    
    self.adjuster = adjuster;
}

- (void)disableKeyboardAutoAdjust
{
    self.adjuster = nil;
}

- (UIView *)keyboardAutoAdjustedView
{
    return [self.adjuster adjustedView];
}

- (BOOL)isKeyboardAutoAdjustEnabled
{
    return self.adjuster;
}

- (UFKeyboardAdjustPoint *)referenceAdjustingPointToKeyboard
{
    UFKeyboardAdjustPoint *point = [[UFKeyboardAdjustPoint alloc] init];
    
    point.point = CGPointMake(0, self.frame.size.height);
    
    point.view = self;
    
    return point;
}

- (UFKeyboardAdjustPoint *)referenceResettingPointToKeyboard
{
    UFKeyboardAdjustPoint *point = [[UFKeyboardAdjustPoint alloc] init];
    
    if ([self.adjuster isKindOfClass:[UFScrollViewBasedKeyboardAdjuster class]])
    {
        point.point = ((UFScrollViewBasedKeyboardAdjuster *)self.adjuster).scrollView.contentOffset;
        
        point.view = ((UFScrollViewBasedKeyboardAdjuster *)self.adjuster).scrollView;
    }
    else if ([self.adjuster isKindOfClass:[UFWindowBasedKeyboardAdjuster class]])
    {
        point.point = CGPointZero;
        
        point.view = self.window;
    }
    
    return point;
}

- (BOOL)shouldAdjustWhenKeyboardWillChangeFrame
{
    return NO;
}

- (BOOL)shouldAdjustWhenKeyboardDidChangeFrame
{
    return NO;
}

- (void)adjust
{
    self.adjuster.adjustingPoint = [self referenceAdjustingPointToKeyboard];
    
    [self.adjuster adjust];
}

@end


static const char kUIViewPropertyKey_KeyboardAdjuster[] = "keyboardAdjuster";


@implementation UIView (KeyboardAdjust_Internal)

- (void)setAdjuster:(UFKeyboardAdjuster *)adjuster
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_KeyboardAdjuster, adjuster, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFKeyboardAdjuster *)adjuster
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_KeyboardAdjuster);
}

- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification
{
    if ([self shouldAdjustWhenKeyboardWillChangeFrame])
    {
        self.adjuster.adjustingPoint = [self referenceAdjustingPointToKeyboard];
        
        [self.adjuster adjust];
    }
}

- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardDidChangeFrameNotification:(NSNotification *)notification
{
    if ([self shouldAdjustWhenKeyboardDidChangeFrame])
    {
        self.adjuster.adjustingPoint = [self referenceAdjustingPointToKeyboard];
        
        [self.adjuster adjust];
    }
}

- (void)keyboardAdjuster:(UFKeyboardAdjuster *)adjuster didReceiveKeyboardWillHideNotification:(NSNotification *)notification
{
    self.adjuster.resettingPoint = [self referenceResettingPointToKeyboard];
    
    [self.adjuster reset];
}

@end
