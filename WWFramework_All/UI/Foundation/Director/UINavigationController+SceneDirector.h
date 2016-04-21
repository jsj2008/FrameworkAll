//
//  UINavigationController+SceneDirector.h
//  MarryYou
//
//  Created by ww on 16/1/13.
//  Copyright © 2016年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UINavigationController (SceneDirector)
 
    @abstract
        UINavigationController的场景扩展，配合场景使用
 
 *********************************************************/

@interface UINavigationController (SceneDirector)

/*!
 * @brief 场景启动锚点页面
 * @discussion 场景的页面栈将本页面作为启动页面
 */
@property (nonatomic) UIViewController *anchoredBaseViewControllerOfSceneDirector;

@end
