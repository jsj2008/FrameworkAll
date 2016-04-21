//
//  UFImageViewGifUpdater.m
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFImageViewGifUpdater.h"
#import <ImageIO/ImageIO.h>

@interface UFImageViewGifUpdater ()

@property (nonatomic) NSArray *imageSources;

@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) NSTimeInterval elapsedDuration;

@property (nonatomic) NSMutableArray *sourceDurations;

- (void)update;

@end


@implementation UFImageViewGifUpdater

- (void)dealloc
{
    [self.displayLink invalidate];
}

- (void)startUpdating
{
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    
    NSMutableArray *sourceDurations = [[NSMutableArray alloc] init];
    
    NSTimeInterval duration = 0;
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)self.gifData, NULL);
    
    size_t sourceCount = CGImageSourceGetCount(gifSource);
    
    for (size_t i = 0; i < sourceCount; i ++)
    {
        UFImageViewGifImageSource *source = [[UFImageViewGifImageSource alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        
        source.image = [UIImage imageWithCGImage:image];
        
        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        
        NSDictionary *gifProperties = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        NSNumber *delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
        
        if (!delayTime)
        {
            delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
        }
        
        source.duration = [delayTime doubleValue];
        
        if (source.image)
        {
            [sources addObject:source];
            
            duration += [delayTime doubleValue];
            
            [sourceDurations addObject:[NSNumber numberWithDouble:duration]];
        }
    }
    
    self.imageSources = sources;
    
    self.sourceDurations = sourceDurations;
    
    [self.displayLink invalidate];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    
    self.displayLink.frameInterval = 1;
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.elapsedDuration = 0;
    
    [self update];
}

- (void)stopUpdating
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
}

- (void)pauseUpdating
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
}

- (void)resumeUpdating
{
    [self.displayLink invalidate];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    
    self.displayLink.frameInterval = 1;
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)update
{
    self.elapsedDuration += self.displayLink.duration;
    
    UIImage *image = nil;
    
    NSTimeInterval loopDuration = [[self.sourceDurations lastObject] doubleValue];
    
    if (loopDuration > 0)
    {
        NSTimeInterval durationInLoop = self.elapsedDuration - ((NSInteger)(self.elapsedDuration / loopDuration)) * loopDuration;
        
        NSInteger index = [self.sourceDurations indexOfObject:[NSNumber numberWithDouble:durationInLoop] inSortedRange:NSMakeRange(0, [self.sourceDurations count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        if (index < 0)
        {
            index = 0;
        }
        else if (index > [self.sourceDurations count] - 1)
        {
            index = [self.sourceDurations count] - 1;
        }
        
        image = ((UFImageViewGifImageSource *)[self.imageSources objectAtIndex:index]).image;
    }

    self.imageView.image = image;
}

@end


@implementation UFImageViewGifImageSource

@end
