//
//  UITextView+PlaceHolder.m
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import "UFTextViewPlaceHolderUpdater.h"
#import <objc/runtime.h>

@interface UITextView (PlaceHolder_Internal)

@property (nonatomic) UFTextViewPlaceHolderUpdater *placeHolderUpdater;

@end


static const char kUITextViewPropertyKey_PlaceHolder[] = "placeHolder";


@implementation UITextView (PlaceHolder)

- (void)setPlaceHolder:(UFTextViewPlaceHolder *)placeHolder
{
    objc_setAssociatedObject(self, kUITextViewPropertyKey_PlaceHolder, placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UFTextViewPlaceHolderUpdater *updater = [[UFTextViewPlaceHolderUpdater alloc] init];
    
    updater.textView = self;
    
    updater.placeHolder = placeHolder;
    
    self.placeHolderUpdater = updater;
}

- (UFTextViewPlaceHolder *)placeHolder
{
    return objc_getAssociatedObject(self, kUITextViewPropertyKey_PlaceHolder);
}

@end


static const char kUITextViewPropertyKey_PlaceHolderUpdater[] = "placeHolderUpdater";


@implementation UITextView (PlaceHolder_Internal)

- (void)setPlaceHolderUpdater:(UFTextViewPlaceHolderUpdater *)placeHolderUpdater
{
    objc_setAssociatedObject(self, kUITextViewPropertyKey_PlaceHolderUpdater, placeHolderUpdater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFTextViewPlaceHolderUpdater *)placeHolderUpdater
{
    return objc_getAssociatedObject(self, kUITextViewPropertyKey_PlaceHolderUpdater);
}

@end
