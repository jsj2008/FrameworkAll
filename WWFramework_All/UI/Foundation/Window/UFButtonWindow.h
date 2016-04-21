//
//  UFButtonWindow.h
//  MarryYou
//
//  Created by ww on 15/11/16.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UFButtonWindowDelegate;


/*********************************************************
 
    @class
        UFButtonWindow
 
    @abstract
        按钮窗口，提供一个点击事件的Window
 
 *********************************************************/

@interface UFButtonWindow : UIWindow

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFButtonWindowDelegate> delegate;

@end


/*********************************************************
 
    @class
        UFButtonWindowDelegate
 
    @abstract
        按钮窗口的代理协议
 
 *********************************************************/

@protocol UFButtonWindowDelegate <NSObject>

/*!
 * @brief 收到点击事件
 * @param window 窗口对象
 */
- (void)buttonWindowDidPressed:(UFButtonWindow *)window;

@end
