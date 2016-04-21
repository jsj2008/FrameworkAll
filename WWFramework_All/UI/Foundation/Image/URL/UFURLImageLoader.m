//
//  UFURLImageLoader.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/22/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "UFURLImageLoader.h"
#import "ImageManager.h"

@interface UFURLImageLoader () <ImageManagerDownloadObserving>
{
    NSURL *_URL;
}

@end


@implementation UFURLImageLoader

@synthesize URL = _URL;

- (void)dealloc
{
    [self cancel];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        _URL = [URL copy];
    }
    
    return self;
}

- (void)load
{
    [[ImageManager sharedInstance] downLoadImageByURL:_URL withObserver:self];
}

- (void)cancel
{
    if (_URL)
    {
        [[ImageManager sharedInstance] cancelDownLoadImageByURL:_URL withObserver:self];
    }
}

- (void)imageManager:(ImageManager *)manager didFinishDownloadImageByURL:(NSURL *)URL successfully:(BOOL)successfully withImageData:(NSData *)data
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(URLImageLoader:didLoadSuccessfully:withData:)] && [URL isEqual:_URL])
    {
        [self.delegate URLImageLoader:self didLoadSuccessfully:successfully withData:data];
    }
}

@end
