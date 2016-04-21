//
//  UFDataPicker.h
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPickSource.h"

/*********************************************************
 
    @class
        UFDataPicker
 
    @abstract
        数据选择器
 
 *********************************************************/

@interface UFDataPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

/*!
 * @brief 初始化
 * @param dataSource 指数据源
 * @result 初始化对象
 */
- (instancetype)initWithDataSource:(UFDataPickSource *)dataSource;

/*!
 * @brief 数据源
 */
@property (nonatomic, readonly) UFDataPickSource *dataSource;

/*!
 * @brief 选择视图
 */
@property (nonatomic, readonly) UIPickerView *pickerView;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

/*!
 * @brief 当前行索引
 * @result 当前行索引
 */
- (NSArray<NSNumber *> *)currentIndexes;

@end
