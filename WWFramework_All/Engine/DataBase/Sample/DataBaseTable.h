//
//  DataBaseTable.h
//  Demo
//
//  Created by Baymax on 13-10-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTable.h"
#import "DBFormat.h"

#pragma mark - DataBaseRecordsConverting

/*********************************************************
 
    @protocol
        DataBaseRecordsConverting
 
    @abstract
        数据库表格中的数据记录和应用的数据记录之间的转换协议
 
 *********************************************************/

@protocol DataBaseRecordsConverting <NSObject>

/*!
 * @brief 将数据表中的数据记录转换成应用的数据记录
 * @param dbRecords 数据表中的数据纪录
 * @result 应用的数据记录
 */
- (NSArray *)dataRecordsFromDBRecords:(NSArray *)dbRecords;

// 将应用的数据记录转换成数据表中的数据记录
/*!
 * @brief 将应用的数据记录转换成数据表中的数据记录
 * @param dataRecords 应用的数据记录
 * @result 数据表中的数据纪录
 */
- (NSArray *)dbRecordsFromDataRecords:(NSArray *)dataRecords;

@end


#pragma mark - DataBaseTable

/*********************************************************
 
    @class
        DataBaseTable
 
    @abstract
        数据库表格对象
 
 *********************************************************/

@interface DataBaseTable : NSObject <DataBaseRecordsConverting>
{
    // 数据库文件句柄
    DBHandle *_handle;
}

/*!
 * @brief 框架数据表
 * @discussion 本对象应尽量避免被其他对象调用
 */
@property (nonatomic) DBTable *table;

/*!
 * @brief 当前表格内的数据列
 * @discussion 本对象应尽量避免被其他对象调用
 */
@property (nonatomic) NSArray *fields;

/*!
 * @brief 初始化
 * @param handle 数据库文件句柄
 * @result 初始化后的对象
 */
- (id)initWithHandle:(DBHandle *)handle;

/*!
 * @brief 启动表格
 * @result 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 映射列
 * @discussion fromFields和toFields中同名的列保留，不同名的列分别做删除和添加操作
 * @param fromFields 原数据列
 * @param toFields 新数据列
 */
- (void)mapFieldsFrom:(NSArray *)fromFields to:(NSArray *)toFields;

/*!
 * @brief 保存应用的数据记录，可以指定保存方法
 * @param records 待保存的数据纪录（应用数据）
 * @param method 保存方法（数据库内执行插入操作的方法，“insert”，“insert or replace”，“insert or ignore”等。method = nil等价于“insert or replace”）
 * @result 保存是否成功
 */
- (BOOL)saveRecords:(NSArray *)records inMethod:(NSString *)method;

/*!
 * @brief 获取所有表内的数据记录
 * @result 表内数据纪录（应用数据）
 */
- (NSArray *)allRecords;

/*!
 * @brief 清理所有表内的数据记录
 * @result 清理是否成功
 */
- (BOOL)cleanAllRecords;

@end
