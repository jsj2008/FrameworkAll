//
//  DateComputing.h
//  FoundationProject
//
//  Created by Baymax on 13-12-23.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSDate (Compute)
 
    @abstract
        NSDate的扩展，用于计算时间
 
 *********************************************************/

@interface NSDate (Compute)

/*!
 * @brief 计算若干时间后/前的日期
 * @param components 时间要素
 * @result 计算获得的时间
 */
- (NSDate *)dateAfterDateComponents:(NSDateComponents *)components;

/*!
 * @brief 计算若干时间后/前的日期
 * @discussion 所有的参数均支持负值，以表征在当前时间之前
 * @param year 年
 * @param month 月
 * @param day 日
 * @param hour 小时
 * @param minute 分钟
 * @param second 秒
 * @result 计算获得的时间
 */
- (NSDate *)dateAfterYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

@end
