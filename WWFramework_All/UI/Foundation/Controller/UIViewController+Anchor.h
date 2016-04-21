//
//  UIViewController+Anchor.h
//  MarryYou
//
//  Created by ww on 15/12/10.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        UIViewController (Anchor)
 
    @abstract
        UIViewController的锚点扩展，用于处理controller间跳转
 
 *********************************************************/

@interface UIViewController (Anchor)

/*!
 * @brief 锚点controller
 */
@property (nonatomic, weak) UIViewController *anchoredViewController;

@end


/*********************************************************
 
    @category
        UINavigationController (ViewControllerAnchor)
 
    @abstract
        UINavigationController的锚点扩展，用于处理controller间跳转
 
 *********************************************************/

@interface UINavigationController (ViewControllerAnchor)

/*!
 * @brief 跳转到锚点controller
 * @discussion 当当前controller存在锚点时，跳转到锚点；无锚点时，pop出当前锚点
 * @param animated 是否需要跳转动画
 */
- (void)popToAnchoredViewControllerAnimated:(BOOL)animated;

/*!
 * @brief pop到新的controller栈顶，并push controller
 * @discussion 当新的栈顶controller不存在于原栈时，直接push controller
 * @param viewController 待push的controller
 * @param newTopViewController 新的栈顶controller
 * @param animated 是否需要跳转动画
 */
- (void)pushViewController:(UIViewController *)viewController onNewTopViewController:(UIViewController *)newTopViewController animated:(BOOL)animated;

@end
