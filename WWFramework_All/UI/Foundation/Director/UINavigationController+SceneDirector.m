//
//  UINavigationController+SceneDirector.m
//  MarryYou
//
//  Created by ww on 16/1/13.
//  Copyright © 2016年 MiaoTo. All rights reserved.
//

#import "UINavigationController+SceneDirector.h"
#import <objc/runtime.h>

static const char kPropertyKey_anchoredBaseViewControllerOfSceneDirector[] = "anchoredBaseViewControllerOfSceneDirector";


@implementation UINavigationController (SceneDirector)

- (UIViewController *)anchoredBaseViewControllerOfSceneDirector
{
    return objc_getAssociatedObject(self, kPropertyKey_anchoredBaseViewControllerOfSceneDirector);
}

- (void)setAnchoredBaseViewControllerOfSceneDirector:(UIViewController *)anchoredBaseViewControllerOfSceneDirector
{
    objc_setAssociatedObject(self, kPropertyKey_anchoredBaseViewControllerOfSceneDirector, anchoredBaseViewControllerOfSceneDirector, OBJC_ASSOCIATION_RETAIN);
}

@end
