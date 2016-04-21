//
//  UFInputToolBar.h
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UFInputToolBarDelegate;


/*********************************************************
 
    @class
        UFInputToolBar
 
    @abstract
        输入工具栏
 
 *********************************************************/

@interface UFInputToolBar : UIView

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFInputToolBarDelegate> delegate;

@end


/*********************************************************
 
    @class
        UFInputToolBarDelegate
 
    @abstract
        输入工具栏的代理协议
 
 *********************************************************/

@protocol UFInputToolBarDelegate <NSObject>

/*!
 * @brief 已确认
 * @param toolBar 工具栏
 */
- (void)inputToolBarDidConfirm:(UFInputToolBar *)toolBar;

/*!
 * @brief 已取消
 * @param toolBar 工具栏
 */
- (void)inputToolBarDidCancel:(UFInputToolBar *)toolBar;

@end
