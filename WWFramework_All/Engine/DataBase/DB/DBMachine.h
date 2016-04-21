//
//  DBMachine.h
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBDefine.h"

/********************** DBMachine **********************
 
    @class
        DBMachine：数据库虚拟机。
 
    @abstract
        DBMachine是对数据库文件进行操作的基础单位。
 
    @discussion
        1. DBMachine通过SQLite3的C函数执行特定的基本命令；
        2. DBMachine的操作是单线程的操作，必须通过DBHandle才能才能保证线程安全。
 
 ********************** DBMachine **********************/

@interface DBMachine : NSObject
{
    // 数据库文件路径
    NSString *_filePath;
    
    // sqlite3连接
    sqlite3 *_db;
}

/*!
 * @brief 初始化，并不真正创建或打开数据库文件
 * @param filePath 数据库文件路径
 * @result 初始化后的对象
 */
- (id)initWithFile:(NSString *)filePath;

/*!
 * @brief 启动。创建或打开数据库文件。若指定路径上的数据库文件不存在，将创建文件
 * @result 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 执行SQL语句
 * @param sql SQL语句
 * @result 执行是否成功
 */
- (BOOL)executeSQL:(NSString *)sql;

/*!
 * @brief 准备statement
 * @param sql SQL语句
 * @result 准备好的statement。准备失败时返回NULL
 */
- (sqlite3_stmt *)preparedStatementForSQL:(NSString *)sql;

/*!
 * @brief 绑定数据到statement
 * @param value 值
 * @param type 类型
 * @param statement statement语句
 * @param location 绑定位置，从1开始
 */
- (void)bindValue:(id)value byType:(DBValueType)type toPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location;

/*!
 * @brief 从statement解绑数据
 * @param statement statement语句
 * @param location 绑定位置，从0开始
 * @param type 类型
 * @result 指定位置的数据
 */
- (id)columnValueFromPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location inType:(DBValueType)type;

/*!
 * @brief 从statement解绑数据
 * @param statement statement语句
 * @param location 绑定位置，从0开始
 * @result 指定位置的列名
 */
- (NSString *)columnNameOfPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location;

/*!
 * @brief 从statement解绑数据
 * @param statement statement语句
 * @result 数据总数
 */
- (int)columnDataCountOfPreparedStatement:(sqlite3_stmt *)statement;

/*!
 * @brief 单步执行statement
 * @param statement statement语句
 * @result 执行结果，SQLite状态码（SQLITE_OK等）
 */
- (int)stepStatement:(sqlite3_stmt *)statement;

/*!
 * @brief 重置statement
 * @param statement statement语句
 * @result 执行结果，SQLite状态码（SQLITE_OK等）
 */
- (void)resetStatement:(sqlite3_stmt *)statement;

/*!
 * @brief 清理statement
 * @param statement statement语句
 * @result 执行结果，SQLite状态码（SQLITE_OK等）
 */
- (void)finalizeStatement:(sqlite3_stmt *)statement;

// 手动提交事务
/*!
 * @brief 手动提交事务
 * @param block 待执行得事务块
 * @result 执行是否成功，若失败，将自动执行回滚操作
 */
- (BOOL)commitTransactionBlock:(void (^)(void))block;

@end
