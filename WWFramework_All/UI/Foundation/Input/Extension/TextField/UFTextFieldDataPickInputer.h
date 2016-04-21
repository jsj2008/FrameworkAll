//
//  UFTextFieldDataPickInputer.h
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPickSource.h"
#import "UFInputToolBar.h"

@protocol UFTextFieldDataPickInputerDelegate;


/*********************************************************
 
    @class
        UFTextFieldDataPickInputer
 
    @abstract
        TextField数据选择输入器
 
 *********************************************************/

@interface UFTextFieldDataPickInputer : NSObject

/*!
 * @brief 初始化
 * @param textField 文本输入框
 * @param dataPickSouce 数据源
 * @param inputToolBar 输入工具栏
 * @result 初始化对象
 */
- (instancetype)initWithTextField:(UITextField *)textField dataPickSouce:(UFDataPickSource *)dataPickSouce inputToolBar:(UFInputToolBar *)inputToolBar;

/*!
 * @brief 文本输入框
 */
@property (nonatomic, readonly) UITextField *textField;

/*!
 * @brief 数据源
 */
@property (nonatomic, readonly) UFDataPickSource *dataPickSource;

/*!
 * @brief 工具栏
 */
@property (nonatomic, readonly) UFInputToolBar *inputToolBar;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFTextFieldDataPickInputerDelegate> delegate;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

/*!
 * @brief 行索引对应的文本
 * @param indexes 行索引
 * @result 文本
 */
- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes;

@end


/*********************************************************
 
    @class
        UFTextFieldDataPickInputerDelegate
 
    @abstract
        TextField数据选择输入器的代理协议
 
 *********************************************************/

@protocol UFTextFieldDataPickInputerDelegate <NSObject>

/*!
 * @brief 已选择行索引
 * @param inputer 输入器
 * @param indexes 行索引
 * @discussion 当输入工具栏选择确认后发送本通知
 */
- (void)textFieldDataPickInputer:(UFTextFieldDataPickInputer *)inputer didSelectIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 已取消
 * @param inputer 输入器
 * @discussion 当输入工具栏选择取消后发送本通知
 */
- (void)textFieldDataPickInputerDidCancel:(UFTextFieldDataPickInputer *)inputer;

@end
