//
//  UFSceneDirector.m
//  MarryYou
//
//  Created by ww on 15/11/12.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UFSceneDirector.h"
#import "UINavigationController+SceneDirector.h"
#import "UIViewController+Anchor.h"

@interface UFSceneDirector ()
{
    __weak UINavigationController *_navigationController;
}

@end


@implementation UFSceneDirector

@synthesize navigationController = _navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super init])
    {
        _navigationController = navigationController;
    }
    
    return self;
}

- (void)start
{
    
}

- (void)setStartAnchoredViewController:(UIViewController *)startAnchoredViewController
{
    self.navigationController.anchoredBaseViewControllerOfSceneDirector = startAnchoredViewController;
}

- (UIViewController *)startAnchoredViewController
{
    return self.navigationController.anchoredBaseViewControllerOfSceneDirector;
}

@end


@implementation UFSceneDirector (Navigation)

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if ([self.navigationController.viewControllers count] == 0)
    {
        [self.navigationController pushViewController:controller animated:NO];
    }
    if (self.navigationController.anchoredBaseViewControllerOfSceneDirector)
    {
        self.navigationController.anchoredBaseViewControllerOfSceneDirector = nil;
        
        [self.navigationController pushViewController:controller onNewTopViewController:self.startAnchoredViewController animated:animated];
    }
    else
    {
        [self.navigationController pushViewController:controller animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = nil;
    
    if (self.navigationController.anchoredBaseViewControllerOfSceneDirector)
    {
        NSArray *viewControllers = self.navigationController.viewControllers;
        
        NSInteger index = [viewControllers indexOfObject:self.navigationController.anchoredBaseViewControllerOfSceneDirector];
        
        self.navigationController.anchoredBaseViewControllerOfSceneDirector = nil;
        
        if (index == NSNotFound)
        {
            controller = [self.navigationController popViewControllerAnimated:animated];
        }
        else if (index > 0)
        {
            controller = [viewControllers objectAtIndex:(index - 1)];
            
            [self.navigationController popToViewController:controller animated:animated];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:animated];
        }
    }
    else
    {
        controller = [self.navigationController popViewControllerAnimated:animated];
    }
    
    return controller;
}

- (NSArray<UIViewController *> *)popToStartAnchoredViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popToViewController:self.startAnchoredViewController animated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [self.navigationController popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

@end
