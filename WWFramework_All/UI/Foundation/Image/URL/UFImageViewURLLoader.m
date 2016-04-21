//
//  UFImageViewURLLoader.m
//  WWFramework_All
//
//  Created by ww on 16/2/29.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFImageViewURLLoader.h"
#import "UFURLImageLoader.h"

@interface UFImageViewURLLoader () <UFURLImageLoaderDelegate>

@property (nonatomic) UFURLImageLoader *imageLoader;

- (void)finishWithSuccessfully:(BOOL)successfully data:(NSData *)data;

@end


@implementation UFImageViewURLLoader

- (void)load
{
    if (self.enablePlaceHolderImage)
    {
        self.imageView.image = self.placeHolderImage;
    }
    
    if (self.URL)
    {
        self.imageLoader = [[UFURLImageLoader alloc] initWithURL:self.URL];
        
        self.imageLoader.delegate = self;
        
        [self.imageLoader load];
    }
    else
    {
        [self finishWithSuccessfully:NO data:nil];
    }
}

- (void)cancel
{
    self.imageLoader = nil;
}

- (void)URLImageLoader:(UFURLImageLoader *)loader didLoadSuccessfully:(BOOL)successfully withData:(NSData *)data
{
    [self finishWithSuccessfully:successfully data:data];
}

- (void)finishWithSuccessfully:(BOOL)successfully data:(NSData *)data
{
    if (successfully)
    {
        if ([data length])
        {
            self.imageView.image = [[UIImage alloc] initWithData:data];
        }
        else
        {
            self.imageView.image = nil;
        }
    }
    else
    {
        if (self.enableFailureImage)
        {
            self.imageView.image = self.failureImage;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (weakSelf.completion)
        {
            weakSelf.completion(weakSelf.URL);
        }
    });
}

@end
