//
//  UFScrollLoadingView.m
//  Test
//
//  Created by ww on 16/2/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadingView.h"

@implementation UFScrollLoadingView

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = UFScrollLoadingViewStatus_Reset;
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.status = UFScrollLoadingViewStatus_Reset;
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.status = UFScrollLoadingViewStatus_Reset;
    
    self.clipsToBounds = YES;
}

- (void)start
{
    [self willStart];
    
    [self customStart];
    
    [self didStart];
}

- (void)willStart
{
    self.status = UFScrollLoadingViewStatus_Loading;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewWillStart:)])
    {
        [self.delegate scrollLoadingViewWillStart:self];
    }
}

- (void)didStart
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewDidStart:)])
    {
        [self.delegate scrollLoadingViewDidStart:self];
    }
}

- (void)customStart
{
    
}

- (void)stop
{
    [self willStop];
    
    [self customStop];
    
    [self customReset];
    
    [self didStop];
}

- (void)willStop
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewWillStop:)])
    {
        [self.delegate scrollLoadingViewWillStop:self];
    }
}

- (void)didStop
{
    self.status = UFScrollLoadingViewStatus_Reset;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewDidStop:)])
    {
        [self.delegate scrollLoadingViewDidStop:self];
    }
}

- (void)customStop
{
    
}

- (void)prepare
{
    [self willPrepare];
    
    [self customPrepare];
    
    [self didPrepare];
}

- (void)willPrepare
{
    self.status = UFScrollLoadingViewStatus_Prepare;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewWillPrepare:)])
    {
        [self.delegate scrollLoadingViewWillPrepare:self];
    }
}

- (void)didPrepare
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewDidPrepare:)])
    {
        [self.delegate scrollLoadingViewDidPrepare:self];
    }
}

- (void)customPrepare
{
    
}

- (void)reset
{
    [self willReset];
    
    [self customReset];
    
    [self didReset];
}

- (void)willReset
{
    self.status = UFScrollLoadingViewStatus_Reset;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewWillReset:)])
    {
        [self.delegate scrollLoadingViewWillReset:self];
    }
}

- (void)didReset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadingViewDidReset:)])
    {
        [self.delegate scrollLoadingViewDidReset:self];
    }
}

- (void)customReset
{
    
}

- (CGSize)contentSize
{
    return CGSizeMake(self.frame.size.width, 100);
}

@end
