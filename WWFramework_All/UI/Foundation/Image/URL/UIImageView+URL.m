//
//  UIImageView+URL.m
//  WWFramework_All
//
//  Created by ww on 16/2/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UIImageView+URL.h"
#import <objc/runtime.h>

@interface UIImageView (URL_Internal)

/*!
 * @brief URL图片加载控制器
 */
@property (nonatomic) UFImageViewURLLoader *URLLoader;

@end


@implementation UIImageView (URL)

- (void)setImageWithURL:(NSURL *)URL placeHolder:(UIImage *)placeHolderImage completion:(void (^)(NSURL *))completion
{
    UFImageViewURLLoader *loader = [[UFImageViewURLLoader alloc] init];
    
    loader.imageView = self;
    
    loader.URL = URL;
    
    if (placeHolderImage)
    {
        loader.enablePlaceHolderImage = YES;
        
        loader.placeHolderImage = placeHolderImage;
    }
    else
    {
        loader.enablePlaceHolderImage = NO;
        
        loader.placeHolderImage = nil;
    }
    
    loader.enableFailureImage = NO;
    
    loader.failureImage = nil;
    
    loader.completion = completion;
    
    self.URLLoader = loader;
    
    [self.URLLoader load];
}

- (void)cancelLoadingWithURL
{
    [self.URLLoader cancel];
    
    self.URLLoader = nil;
}

@end


static const char kUIImageViewPropertyKey_URLLoader[] = "URLLoader";


@implementation UIImageView (URL_Internal)

- (void)setURLLoader:(UFImageViewURLLoader *)URLLoader
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLLoader, URLLoader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFImageViewURLLoader *)URLLoader
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLLoader);
}

@end
