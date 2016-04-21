//
//  UFButtonWindowViewController.m
//  MarryYou
//
//  Created by ww on 15/11/16.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UFButtonWindowViewController.h"

@interface UFButtonWindowViewController ()

@property (nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonPressed:(id)sender;

@end


@implementation UFButtonWindowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)buttonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonWindowViewControllerDidPressed:)])
    {
        [self.delegate buttonWindowViewControllerDidPressed:self];
    }
}

@end
