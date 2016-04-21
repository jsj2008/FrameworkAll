//
//  UIView+Loading.m
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UIView+Loading.h"
#import "UFViewLoadingUpdater.h"
#import <objc/runtime.h>

@interface UIView (Loading_Internal)

@property (nonatomic) UFViewLoadingUpdater *viewLoadUpdater;

@end


@implementation UIView (Loading)

- (void)startLoadingWithView:(UFLoadingView *)loadingView
{
    if (!self.viewLoadUpdater)
    {
        self.viewLoadUpdater = [[UFViewLoadingUpdater alloc] init];
        
        self.viewLoadUpdater.view = self;
    }
    
    self.viewLoadUpdater.loadingView = loadingView;
    
    [self.viewLoadUpdater start];
}

- (void)stopLoading
{
    [self.viewLoadUpdater stop];
}

- (void)stopLoadingCountly
{
    [self.viewLoadUpdater stopCountly];
}

@end


static const char kUIViewPropertyKey_ViewLoadUpdater[] = "viewLoadUpdater";


@implementation UIView (Loading_Internal)

- (void)setViewLoadUpdater:(UFViewLoadingUpdater *)viewLoadUpdater
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_ViewLoadUpdater, viewLoadUpdater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFViewLoadingUpdater *)viewLoadUpdater
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_ViewLoadUpdater);
}

@end
