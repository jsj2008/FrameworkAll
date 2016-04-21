//
//  RefreshAndLoadMoreTableController.m
//  DuomaiFrameWork
//
//  Created by Baymax on 5/7/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "RefreshAndLoadMoreTableController.h"
#import "UFScrollRefreshView.h"
#import "UFScrollLoadMoreView.h"
#import "UFScrollRefreshAndLoadMoreContainer.h"
#import "UITextView+PlaceHolder.h"

@interface RefreshAndLoadMoreTableController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UFScrollRefreshAndLoadMoreContainerDelegate>

@property (nonatomic) UITableView *table;

@property (nonatomic) NSMutableArray *datas;

@property (nonatomic) UFScrollRefreshAndLoadMoreContainer *container;

@property (nonatomic) UITextView *textView;

@property (nonatomic) UIButton *button;

- (void)buttonPressed;

@end


@implementation RefreshAndLoadMoreTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    CGFloat height = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    
    textView.backgroundColor = [UIColor grayColor];
    
    UFTextViewPlaceHolder *placeHolder = [[UFTextViewPlaceHolder alloc] init];
    
    placeHolder.text = @"123";
    
    placeHolder.textColor = [UIColor redColor];
    
    placeHolder.font = [UIFont systemFontOfSize:20];
    
    textView.placeHolder = placeHolder;
    
    self.textView = textView;
    
    [self.view addSubview:textView];
    
    textView.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"hello" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    button.frame = CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width + 20, 150, 100, 50);
    
    button.backgroundColor = [UIColor grayColor];
    
    self.button = button;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
        
        cell.textLabel.backgroundColor = [UIColor redColor];
        
        cell.backgroundColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

- (void)scrollRefreshAndLoadMoreContainerDidStartRefresh:(UFScrollRefreshAndLoadMoreContainer *)container
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.container stopRefreshingWithCompletion:^{
            
            NSLog(@"hello");
        }];
    });
}

- (void)scrollRefreshAndLoadMoreContainerDidStartLoadMore:(UFScrollRefreshAndLoadMoreContainer *)container
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.container stopLoadingMoreWithCompletion:^{
            
            static int a = 1;
            
            a++;
            
            if (a < 3)
            {
                for (int i = 0; i < 5; i ++)
                {
                    [self.datas addObject:@"a"];
                }
                
                [self.table reloadData];
            }
            else
            {
                self.container.enableLoadMore = NO;
            }
        }];
        
    });
}

- (void)buttonPressed
{
    [self.view endEditing:YES];
}

@end
