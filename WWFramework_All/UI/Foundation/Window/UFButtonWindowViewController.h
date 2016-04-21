//
//  UFButtonWindowViewController.h
//  MarryYou
//
//  Created by ww on 15/11/16.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UFButtonWindowViewControllerDelegate;


/*********************************************************
 
    @class
        UFButtonWindowViewController
 
    @abstract
        按钮窗口视图控制器
 
 *********************************************************/

@interface UFButtonWindowViewController : UIViewController

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFButtonWindowViewControllerDelegate> delegate;

@end


/*********************************************************
 
    @class
        UFButtonWindowViewControllerDelegate
 
    @abstract
        按钮窗口视图控制器的代理协议
 
 *********************************************************/

@protocol UFButtonWindowViewControllerDelegate <NSObject>

/*!
 * @brief 收到点击事件
 * @param controller 按钮窗口视图控制器
 */
- (void)buttonWindowViewControllerDidPressed:(UFButtonWindowViewController *)controller;

@end
