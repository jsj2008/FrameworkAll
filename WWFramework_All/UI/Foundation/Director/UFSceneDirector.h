//
//  UFSceneDirector.h
//  MarryYou
//
//  Created by ww on 15/11/12.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFSceneDirector
 
    @abstract
        场景导演，管理特定的页面和逻辑组成的UI业务场景，调度controller间的跳转
 
    @discussion
        场景内部使用UINavigationController管理controller的跳转
 
 *********************************************************/

@interface UFSceneDirector : NSObject

/*!
 * @brief 内部页面导航
 */
@property (nonatomic, readonly) UINavigationController *navigationController;

/*!
 * @brief 内部页面导航的起始锚点controller
 * @discussion 场景内部将本controller设置为导航栈顶，所有页面都从本controller出发
 */
@property (nonatomic) UIViewController *startAnchoredViewController;

/*!
 * @brief 初始化场景导演
 * @param navigationController 页面导航
 * @result 场景导演
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

/*!
 * @brief 启动场景
 */
- (void)start;

@end


/*********************************************************
 
    @category
        UFSceneDirector (Navigation)
 
    @abstract
        UFSceneDirector的导航扩展，与NavigationController类似，封装了对controller的一些跳转操作，并在内部作了一些特殊的处理
 
 *********************************************************/

@interface UFSceneDirector (Navigation)

/*!
 * @brief 导入页面
 * @param controller 新页面
 * @param animated 是否需要动画
 */
- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated;

/*!
 * @brief 退出当前页面
 * @param animated 是否需要动画
 * @result 退出的页面
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/*!
 * @brief 退出到启动锚点页面
 * @param animated 是否需要动画
 * @result 退出的页面
 */
- (NSArray<__kindof UIViewController *> *)popToStartAnchoredViewControllerAnimated:(BOOL)animated;

/*!
 * @brief 退出到指定页面
 * @param viewController 指定页面
 * @param animated 是否需要动画
 * @result 退出的页面
 */
- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

/*!
 * @brief 退出根页面
 * @param animated 是否需要动画
 * @result 退出的页面
 */
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

@end
