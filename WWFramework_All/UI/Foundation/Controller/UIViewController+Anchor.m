//
//  UIViewController+Anchor.m
//  MarryYou
//
//  Created by ww on 15/12/10.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UIViewController+Anchor.h"
#import <objc/runtime.h>

static char kViewControllerAnchor[] = "viewControllerAnchor";


@implementation UIViewController (Anchor)

- (UIViewController *)anchoredViewController
{
    return objc_getAssociatedObject(self, kViewControllerAnchor);
}

- (void)setAnchoredViewController:(UIViewController *)anchoredViewController
{
    if (anchoredViewController)
    {
        objc_setAssociatedObject(self, kViewControllerAnchor, anchoredViewController, OBJC_ASSOCIATION_ASSIGN);
    }
}

@end


@implementation UINavigationController (ViewControllerAnchor)

- (void)popToAnchoredViewControllerAnimated:(BOOL)animated
{
    if (self.topViewController.anchoredViewController)
    {
        [self popToViewController:self.topViewController.anchoredViewController animated:animated];
    }
    else
    {
        [self popViewControllerAnimated:animated];
    }
}

- (void)pushViewController:(UIViewController *)viewController onNewTopViewController:(UIViewController *)newTopViewController animated:(BOOL)animated
{
    if (self.topViewController == newTopViewController)
    {
        [self pushViewController:viewController animated:animated];
    }
    else
    {
        NSUInteger index = [self.viewControllers indexOfObject:newTopViewController];
        
        if (index != NSNotFound)
        {
            NSMutableArray *newViewControllers = [[NSMutableArray alloc] initWithArray:[self.viewControllers subarrayWithRange:NSMakeRange(0, index + 1)]];
            
            [newViewControllers addObject:viewController];
            
            [self setViewControllers:newViewControllers animated:animated];
        }
        else
        {
            [self pushViewController:viewController animated:animated];
        }
    }
}

@end
