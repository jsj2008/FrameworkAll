//
//  DBFormat.h
//  FoundationProject
//
//  Created by user on 13-11-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSMutableDictionary (DB)

/*********************************************************
 
    @category
        NSMutableDictionary (DB)
 
    @abstract
        NSMutableDictionary的类别扩展，封装针对数据库的操作
 
 *********************************************************/

@interface NSMutableDictionary (DB)

/*!
 * @brief 设置字典的DB键值
 * @param object 值，若为nil，将不会设置键值对
 * @param key 键，若长度为0，将不会设置键值对
 */
- (void)setDBObject:(id)object forKey:(NSString *)key;

@end


#pragma mark - NSDictionary (DB)

/*********************************************************
 
    @category
        NSDictionary (DB)
 
    @abstract
        NSDictionary的类别扩展，封装针对数据库的操作
 
 *********************************************************/

@interface NSDictionary (DB)

/*!
 * @brief 字典的DB键值
 * @param key 键
 * @result 值，若为NSNull对象，返回nil
 */
- (id)DBObjectForKey:(NSString *)key;

@end


#pragma mark - NSString (DB)

/*********************************************************
 
    @category
        NSString (DB)
 
    @abstract
        NSString的类别扩展，封装针对数据库的操作
 
 *********************************************************/

@interface NSString (DB)

/*!
 * @brief 将字符串转换成SQL当中的值字符串
 * @discussion 将字符串中的'转换成''，并在转换结果上添加''以表示字符串类型
 * @result 转换后的字符串
 */
- (NSString *)SQLedValueString;

@end


#pragma mark - NSDate (DB)

/*********************************************************
 
    @category
        NSDate (DB)
 
    @abstract
        NSDate的类别扩展，封装针对数据库的操作
 
 *********************************************************/

@interface NSDate (DB)

/*!
 * @brief 将当前时间转换成数据库时间
 * @result 数据库时间
 */
- (long long)DBDate;

/*!
 * @brief 根据数据库时间生成一个系统时间
 * @param DBDate 数据库时间
 * @result 系统时间
 */
+ (NSDate *)dateWithDBDate:(long long)DBDate;

@end


#pragma mark - DBSequencingType

/*********************************************************
 
    @enum
        DBSequencingType
 
    @abstract
        数据库排序方式
 
 *********************************************************/

typedef enum
{
    DBSequencingType_Ascendingly  = 1,  // 升序
    DBSequencingType_Descendingly = 2   // 降序
}DBSequencingType;


#pragma mark - DBFieldSequencingContext

/*********************************************************
 
    @class
        DBFieldSequencingContext
 
    @abstract
        数据表列排序配置项
 
 *********************************************************/

@interface DBFieldSequencingContext : NSObject

/*!
 * @brief 列名
 */
@property (nonatomic, copy) NSString *fieldName;

/*!
 * @brief 排序方式，默认升序
 */
@property (nonatomic) DBSequencingType sequencingType;

@end
