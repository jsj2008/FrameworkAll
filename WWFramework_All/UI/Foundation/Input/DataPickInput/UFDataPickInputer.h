//
//  UFDataPickInputer.h
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPicker.h"
#import "UFInputToolBar.h"

@protocol UFDataPickInputerDelegate;


/*********************************************************
 
    @class
        UFDataPickInputer
 
    @abstract
        数据选择输入器
 
 *********************************************************/

@interface UFDataPickInputer : NSObject

/*!
 * @brief 初始化
 * @param dataPicker 数据选择器
 * @param inputToolBar 输入工具栏
 * @result 初始化对象
 */
- (instancetype)initWithDataPicker:(UFDataPicker *)dataPicker inputToolBar:(UFInputToolBar *)inputToolBar;

/*!
 * @brief 数据选择器
 */
@property (nonatomic, readonly) UFDataPicker *dataPicker;

/*!
 * @brief 输入工具栏
 */
@property (nonatomic, readonly) UFInputToolBar *inputToolBar;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFDataPickInputerDelegate> delegate;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

@end


/*********************************************************
 
    @class
        UFDataPickInputerDelegate
 
    @abstract
        数据选择输入器的代理协议
 
 *********************************************************/

@protocol UFDataPickInputerDelegate <NSObject>

/*!
 * @brief 已选择行索引
 * @param inputer 输入器
 * @param indexes 行索引
 * @discussion 当输入工具栏选择确认后发送本通知
 */
- (void)dataPickInputer:(UFDataPickInputer *)inputer didSelectIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 已取消
 * @param inputer 输入器
 * @discussion 当输入工具栏选择取消后发送本通知
 */
- (void)dataPickInputerDidCancel:(UFDataPickInputer *)inputer;

@end
