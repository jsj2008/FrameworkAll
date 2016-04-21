//
//  ViewController.m
//  Application
//
//  Created by Baymax on 14-2-15.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "ViewController.h"
#import "SPTask.h"
#import "SPTaskDispatcher.h"
#import "BlockTask.h"
#import "SPTaskServiceProvider.h"
#import "RefreshAndLoadMoreTableController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        RefreshAndLoadMoreTableController *vc = [[RefreshAndLoadMoreTableController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
