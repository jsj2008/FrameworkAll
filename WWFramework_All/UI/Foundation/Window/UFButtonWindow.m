//
//  UFButtonWindow.m
//  MarryYou
//
//  Created by ww on 15/11/16.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UFButtonWindow.h"
#import "UFButtonWindowViewController.h"

@interface UFButtonWindow () <UFButtonWindowViewControllerDelegate>

@end


@implementation UFButtonWindow

- (instancetype)init
{
    if (self = [super init])
    {
        UFButtonWindowViewController *controller = [[UFButtonWindowViewController alloc] initWithNibName:NSStringFromClass([UFButtonWindowViewController class]) bundle:nil];
        
        controller.delegate = self;
        
        self.rootViewController = controller;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UFButtonWindowViewController *controller = [[UFButtonWindowViewController alloc] initWithNibName:NSStringFromClass([UFButtonWindowViewController class]) bundle:nil];
        
        controller.delegate = self;
        
        self.rootViewController = controller;
    }
    
    return self;
}

- (void)buttonWindowViewControllerDidPressed:(UFButtonWindowViewController *)controller
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonWindowDidPressed:)])
    {
        [self.delegate buttonWindowDidPressed:self];
    }
}

@end
