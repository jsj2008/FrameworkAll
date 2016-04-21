//
//  UIImageView+Gif.m
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UIImageView+Gif.h"
#import "UFImageViewGifUpdater.h"
#import <objc/runtime.h>

@interface UIImageView (Gif_Internal)

@property (nonatomic) UFImageViewGifUpdater *gifUpdater;

@end


static const char kUIImageViewPropertyKey_GifData[] = "gifData";


@implementation UIImageView (Gif)

- (void)setGifData:(NSData *)gifData
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifData, gifData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)gifData
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifData);
}

- (void)startGifAnimating
{
    if (!self.gifUpdater)
    {
        self.gifUpdater = [[UFImageViewGifUpdater alloc] init];
        
        self.gifUpdater.imageView = self;
        
        self.gifUpdater.gifData = self.gifData;
    }
    
    [self.gifUpdater startUpdating];
}

- (void)stopGifAnimating
{
    [self.gifUpdater stopUpdating];
    
    self.gifUpdater = nil;
}

- (void)pauseGifAnimating
{
    [self.gifUpdater pauseUpdating];
}

- (void)resumeGifAnimating
{
    [self.gifUpdater resumeUpdating];
}

@end


static const char kUIImageViewPropertyKey_GifUpdater[] = "gifUpdater";


@implementation UIImageView (Gif_Internal)

- (void)setGifUpdater:(UFImageViewGifUpdater *)gifUpdater
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater, gifUpdater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFImageViewGifUpdater *)gifUpdater
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
}

@end
