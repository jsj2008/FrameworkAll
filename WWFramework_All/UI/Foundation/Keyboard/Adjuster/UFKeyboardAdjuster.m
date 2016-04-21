//
//  UFKeyboardAdjuster.m
//  Test
//
//  Created by ww on 16/1/19.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFKeyboardAdjuster.h"
#import <objc/runtime.h>

@interface UFKeyboardAdjuster ()

@property (nonatomic) NSDictionary *keyboardInfo;

- (void)didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification;

- (void)didReceiveKeyboardDidChangeFrameNotification:(NSNotification *)notification;

- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification;

@end


@implementation UFKeyboardAdjuster

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (enable)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        ;
    }
}

- (void)adjust
{
    
}

- (void)reset
{
    
}

- (UIView *)adjustedView
{
    return nil;
}

- (void)didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification
{
    self.keyboardInfo = notification.userInfo;
    
    if ([self.keyboardCaller isFirstResponder] && self.delegate && [self.delegate respondsToSelector:@selector(keyboardAdjuster:didReceiveKeyboardWillChangeFrameNotification:)])
    {
        [self.delegate keyboardAdjuster:self didReceiveKeyboardWillChangeFrameNotification:notification];
    }
}

- (void)didReceiveKeyboardDidChangeFrameNotification:(NSNotification *)notification
{
    self.keyboardInfo = notification.userInfo;
    
    if ([self.keyboardCaller isFirstResponder] && self.delegate && [self.delegate respondsToSelector:@selector(keyboardAdjuster:didReceiveKeyboardDidChangeFrameNotification:)])
    {
        [self.delegate keyboardAdjuster:self didReceiveKeyboardDidChangeFrameNotification:notification];
    }
}

- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification
{
    self.keyboardInfo = notification.userInfo;
    
    if ([self.keyboardCaller isFirstResponder] && self.delegate && [self.delegate respondsToSelector:@selector(keyboardAdjuster:didReceiveKeyboardWillHideNotification:)])
    {
        [self.delegate keyboardAdjuster:self didReceiveKeyboardWillHideNotification:notification];
    }
}

@end


@implementation UFWindowBasedKeyboardAdjuster

- (void)adjust
{
    CGRect keyboardRect = [[self.keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [[self.keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGPoint point = [self.adjustingPoint.view convertPoint:self.adjustingPoint.point toView:self.window];
    
    if (point.y > keyboardRect.origin.y - self.window.frame.origin.y)
    {
        CGFloat offsetY = keyboardRect.origin.y - self.window.frame.origin.y - point.y;
        
        UIWindow *window = self.window;
        
        [UIView animateWithDuration:duration animations:^{
            
            window.frame = CGRectMake(window.frame.origin.x, window.frame.origin.y + offsetY, window.frame.size.width, window.frame.size.height);
            
        }];
    }
}

- (void)reset
{
    CGPoint point = [self.resettingPoint.view convertPoint:self.resettingPoint.point toView:self.window];
    
    if (self.window.frame.origin.y != point.y)
    {
        double duration = [[self.keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        UIWindow *window = self.window;
        
        [UIView animateWithDuration:duration animations:^{
            
            window.frame = CGRectMake(window.frame.origin.x, point.y, window.frame.size.width, window.frame.size.height);
            
        }];
    }
}

- (UIView *)adjustedView
{
    return self.window;
}

@end


@interface UFScrollViewBasedKeyboardAdjuster ()

@end


@implementation UFScrollViewBasedKeyboardAdjuster

- (void)adjust
{
    if (!self.scrollView.originalKeyboardAdjustingContentSize)
    {
        self.scrollView.originalKeyboardAdjustingContentSize = [NSValue valueWithCGSize:self.scrollView.contentSize];
    }
        
    CGRect originalKeyboardRect = [[self.keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect keyboardRect = [self.scrollView convertRect:CGRectMake(originalKeyboardRect.origin.x, originalKeyboardRect.origin.y, originalKeyboardRect.size.width, originalKeyboardRect.size.height) fromView:self.scrollView.window];
    
    double duration = [[self.keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGPoint point = [self.adjustingPoint.view convertPoint:self.adjustingPoint.point toView:self.scrollView];
    
    if (point.y > keyboardRect.origin.y)
    {
        CGFloat offsetY = keyboardRect.origin.y - point.y;
        
        CGPoint contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - offsetY);
        
        CGSize contentSize = self.scrollView.contentSize;
        
        if (contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height)
        {
            contentSize = CGSizeMake(contentSize.width, contentOffset.y + self.scrollView.frame.size.height);
        }
        
        UIScrollView *scrollView = self.scrollView;
        
        [UIView animateWithDuration:duration animations:^{
            
            scrollView.contentOffset = contentOffset;
            
            scrollView.contentSize = contentSize;
            
        }];
    }
}

- (void)reset
{
    double duration = [[self.keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIScrollView *scrollView = self.scrollView;
    
    CGPoint point = [self.resettingPoint.view convertPoint:self.resettingPoint.point toView:self.scrollView];
    
    point = CGPointMake(self.scrollView.contentOffset.x, point.y);
    
    CGSize size = [self.scrollView.originalKeyboardAdjustingContentSize CGSizeValue];
    
    if (point.y + self.scrollView.frame.size.height > size.height)
    {
        point = CGPointMake(point.x, size.height - self.scrollView.frame.size.height);
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        scrollView.contentOffset = point;
        
        if (scrollView.originalKeyboardAdjustingContentSize)
        {
            scrollView.contentSize = [scrollView.originalKeyboardAdjustingContentSize CGSizeValue];
        }
        
        
        
    } completion:^(BOOL finished) {
        
        scrollView.originalKeyboardAdjustingContentSize = nil;
        
    }];
}

- (UIView *)adjustedView
{
    return self.scrollView;
}

@end


static const char kUIScrollViewPropertyKey_OriginalKeyboardAdjustingContentSize[] = "originalKeyboardAdjustingContentSize";


@implementation UIScrollView (KeyboardAdjust)

- (void)setOriginalKeyboardAdjustingContentSize:(NSValue *)originalKeyboardAdjustingContentSize
{
    objc_setAssociatedObject(self, kUIScrollViewPropertyKey_OriginalKeyboardAdjustingContentSize, originalKeyboardAdjustingContentSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)originalKeyboardAdjustingContentSize
{
    return objc_getAssociatedObject(self, kUIScrollViewPropertyKey_OriginalKeyboardAdjustingContentSize);
}

@end
