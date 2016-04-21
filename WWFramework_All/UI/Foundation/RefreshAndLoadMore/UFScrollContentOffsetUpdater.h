//
//  UFScrollContentInsetUpdater.h
//  MarryYou
//
//  Created by ww on 16/2/17.
//  Copyright © 2016年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFScrollContentOffsetUpdater
 
    @abstract
        contentOffset更新控制器，用于控制contentOffset的动态更新
 
    @discussion
        1，UIScrollView调节contentOffset会受到干扰（如UITableView的数据装载会自动调节contentOffset），回调通知不便捷(需在UIScrollViewDelegate方法中接收通知)，使用UIView动画时不会触发contentOffset的变更通知(KVO失效)，故引入本控制器
        2，控制器强制contentOffset按照设定执行，即使外部修改了contentOffset，也会被立即设置回设定值
 
 *********************************************************/

@interface UFScrollContentOffsetUpdater : NSObject

/*!
 * @brief 滚动视图对象
 */
@property (nonatomic) UIScrollView *scrollView;

/*!
 * @brief 目标contentOffset
 */
@property (nonatomic) CGPoint contentOffset;

/*!
 * @brief 动画时长
 * @discussion 默认时长1秒，必须 > 0
 */
@property (nonatomic) NSTimeInterval duration;

/*!
 * @brief 结束回调
 */
@property (nonatomic,copy) void (^completion)();

/*!
 * @brief 更新contentOffset
 * @discussion 设定contentOffset从当前值，在设定时长下，线性变更到设定值
 * @discussion 开始更新操作时，会停止正在执行的更新操作
 */
- (void)update;

@end
