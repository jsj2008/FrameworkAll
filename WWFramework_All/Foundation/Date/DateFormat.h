//
//  DateFormat.h
//  FoundationProject
//
//  Created by user on 13-11-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - DateFormat

/*!
 * @brief 时间格式的间隔符
 */
extern NSString * const DateFormatComponent_Blank;

extern NSString * const DateFormatComponent_Hyphen;

extern NSString * const DateFormatComponent_Colon;

extern NSString * const DateFormatComponent_Comma;

extern NSString * const DateFormatComponent_Virgule;

/*!
 * @brief 时间格式的时间单位符
 */
extern NSString * const DateFormatComponent_Year;

extern NSString * const DateFormatComponent_Month;

extern NSString * const DateFormatComponent_Day;

extern NSString * const DateFormatComponent_Hour;

extern NSString * const DateFormatComponent_Minute;

extern NSString * const DateFormatComponent_Second;

extern NSString * const DateFormatComponent_Weekday;


/*********************************************************
 
    @class
        DateFormat
 
    @abstract
        时间格式
 
 *********************************************************/

@interface DateFormat : NSObject

/*!
 * @brief 格式
 * @discussion 必须由DateFormatComponent_XXX组成
 */
@property (nonatomic, copy) NSArray *formatComponents;

/*!
 * @brief 月份字符串
 * @discussion 成员个数必须>=12
 */
@property (nonatomic, retain) NSArray *monthStrings;

/*!
 * @brief 工作日字符串
 * @discussion 成员个数必须>=7
 */
@property (nonatomic, retain) NSArray *weekdayStrings;

/*!
 * @brief 是否以两位数表示年份
 * @discussion 如果选择是，当年份在1930~2029年之间，会自动以两位数年份来处理
 */
@property (nonatomic) BOOL yearInAbbreviation;

@end


#pragma mark - NSDate (Format)

/*********************************************************
 
    @category
        NSDate (Format)
 
    @abstract
        NSDate的扩展，负责系统时间和常见格式时间字符串间的转换
 
 *********************************************************/

@interface NSDate (Format)

/*!
 * @brief 将时间字符串转换成NSDate对象
 * @param formatString 时间字符串
 * @param dateFormat 时间格式，时间格式的格式可以忽略间隔符
 * @result 转换后的NSDate对象
 */
+ (NSDate *)dateWithFormatString:(NSString *)formatString ofFormat:(DateFormat *)dateFormat;

/*!
 * @brief 生成时间字符串
 * @param dateFormat 时间格式
 * @result 生成的字符串
 */
- (NSString *)formatStringOfFormat:(DateFormat *)dateFormat;

@end


#pragma mark - NSDate (FormatType)

/*********************************************************
 
    @enum
        DateFormatType
 
    @abstract
        时间格式类型
 
 *********************************************************/

typedef enum
{
    DateFormatType_HTTPHeaderDate = 1,  // HTTP首部的时间格式，GMT时间
    DateFormatType_HTTPCookieDate = 2   // HTTP的cookie的时间格式，GMT时间
}DateFormatType;


/*********************************************************
 
    @category
        NSDate (FormatType)
 
    @abstract
        NSDate的扩展，负责指定类型的系统时间和常见格式时间字符串间的转换
 
 *********************************************************/

@interface NSDate (FormatType)

/*!
 * @brief 将时间字符串转换成NSDate对象
 * @param formatString 时间字符串
 * @param type 时间格式
 * @result 转换后的NSDate对象
 */
+ (NSDate *)dateWithFormatString:(NSString *)formatString byType:(DateFormatType)type;

/*!
 * @brief 生成时间字符串
 * @param type 时间格式
 * @result 生成的字符串
 */
- (NSString *)formatStringByType:(DateFormatType)type;

@end
