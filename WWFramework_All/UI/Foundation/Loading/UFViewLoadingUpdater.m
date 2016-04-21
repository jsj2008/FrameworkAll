//
//  UFViewLoadingUpdater.m
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFViewLoadingUpdater.h"

@interface UFViewLoadingUpdater ()

@property (nonatomic) NSInteger count;

@end


@implementation UFViewLoadingUpdater

- (void)setLoadingView:(UFLoadingView *)loadingView
{
    if (loadingView != _loadingView)
    {
        [_loadingView removeFromSuperview];
        
        [self.view addSubview:loadingView];
        
        _loadingView = loadingView;
        
        if (loadingView)
        {
            loadingView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                                    [NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                                    [NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                                    [NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                                    [NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0], nil]];
        }
    }
}

- (void)start
{
    self.loadingView.hidden = NO;
    
    // 为达到启动计数或替换了新的loadingView
    if (self.count <= 0 || !self.loadingView.isLoading)
    {
        [self.loadingView startLoading];
    }
    
    self.count ++;
}

- (void)stop
{
    self.count = 0;
    
    [self.loadingView stopLoading];
    
    self.loadingView.hidden = YES;
}

- (void)stopCountly
{
    self.count --;
    
    if (self.count <= 0)
    {
        [self.loadingView stopLoading];
        
        self.loadingView.hidden = YES;
    }
}

@end
