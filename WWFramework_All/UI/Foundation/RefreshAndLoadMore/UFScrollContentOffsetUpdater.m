//
//  UFScrollContentInsetUpdater.m
//  MarryYou
//
//  Created by ww on 16/2/17.
//  Copyright © 2016年 MiaoTo. All rights reserved.
//

#import "UFScrollContentOffsetUpdater.h"

@interface UFScrollContentOffsetUpdater ()

@property (nonatomic) NSTimeInterval elapsedDuration;

@property (nonatomic) CGPoint originalContentOffset;

@property (nonatomic) CADisplayLink *displayLink;

- (void)displayLinkUpdate;

- (void)finish;

@end


@implementation UFScrollContentOffsetUpdater

- (void)dealloc
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.duration = 1;
    }
    
    return self;
}

- (void)update
{
    self.elapsedDuration = 0;
    
    self.originalContentOffset = self.scrollView.contentOffset;
    
    if (self.duration > 0)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
        
        self.displayLink.frameInterval = 1;
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    else
    {
        [self finish];
    }
}

- (void)displayLinkUpdate
{
    if (self.elapsedDuration < self.duration)
    {
        self.elapsedDuration += self.displayLink.duration;
        
        self.scrollView.contentOffset = CGPointMake(self.originalContentOffset.x + (self.contentOffset.x - self.originalContentOffset.x) * self.elapsedDuration / self.duration, self.originalContentOffset.y + (self.contentOffset.y - self.originalContentOffset.y) * self.elapsedDuration / self.duration);
    }
    
    if (self.elapsedDuration >= self.duration)
    {
        self.scrollView.contentOffset = self.contentOffset;
        
        [self finish];
    }
}

- (void)finish
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.completion)
        {
            self.completion();
        }
    });
}

@end
