//
//  UFLoadingView.m
//  Test
//
//  Created by ww on 16/3/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFLoadingView.h"

@implementation UFLoadingView

- (void)startLoading
{
    self.isLoading = YES;
    
    [self customStartLoading];
}

- (void)customStartLoading
{
    
}

- (void)stopLoading
{
    self.isLoading = NO;
    
    [self customStopLoading];
}

- (void)customStopLoading
{
    
}

@end
