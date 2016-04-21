//
//  BusinessFoundationServiceTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "BusinessFoundationServiceTask.h"
#import "NetManager.h"
#import "AccountCenter.h"
#import "ImageManager.h"

@implementation BusinessFoundationServiceStartTask

- (void)run
{
    [[NetManager sharedInstance] start];
    
    [[AccountCenter sharedInstance] start];
        
    [[ImageManager sharedInstance] start];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(businessFoundationServiceStartTaskDidFinish:)])
        {
            [self.delegate businessFoundationServiceStartTaskDidFinish:self];
        }
    }];
}

@end


@implementation BusinessFoundationServiceStopTask

- (void)run
{
    [[NetManager sharedInstance] stop];
    
    [[ImageManager sharedInstance] stop];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(businessFoundationServiceStopTaskDidFinish:)])
        {
            [self.delegate businessFoundationServiceStopTaskDidFinish:self];
        }
    }];
}

@end
