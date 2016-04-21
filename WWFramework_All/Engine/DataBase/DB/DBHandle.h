//
//  DBHandle.h
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDefine.h"

@class DBMachine;

/********************** DBHandle **********************
 
    @class
        DBHandle：数据库句柄对象。
 
    @abstract
        DBHandle是对数据库文件进行完整操作的最基本的单位。
 
    @discussion
        1. 通过DBHandle执行的操作都是线程安全的，不会产生死锁；
        2. 一个数据库文件应当只配置一个DBHandle，如果配置多个DBHandle，不保证访问数据库文件时的线程安全和死锁问题。
        3. DBHandle执行dealloc方法时会等待所有正在操作的数据库命令结束，因此可能会占用一段时间
 
********************** DBHandle **********************/

@interface DBHandle : NSObject
{
    DBMachine *_machine;
}

/*!
 * @brief 初始化
 * @param path 数据库文件路径
 * @result 初始化后的对象
 */
- (id)initWithPath:(NSString *)path;

/*!
 * @brief 启动数据库
 * @result 启动是否成功
 */
- (BOOL)start;

/*!
 * @brief 更改数据库，执行SQL语句
 * @param sqls SQL语句
 * @result 执行是否成功，若失败，数据自动回滚
 */
- (BOOL)updateDBByExecutingSQLs:(NSArray<NSString *> *)sqls;

/*!
 * @brief 更改数据库，执行SQL绑定语句
 * @param unbindSQL SQL语句
 * @param fields 绑定列
 * @param records 绑定数据
 * @result 执行是否成功，若失败，数据自动回滚
 */
- (BOOL)updateDBByBindingSQL:(NSString *)unbindSQL withFields:(NSArray<DBTableField *> *)fields records:(NSArray *)records;

// 查询数据库，执行SQL查询语句
/*!
 * @brief 查询数据库，执行SQL查询语句
 * @param fields 绑定列
 * @param sql SQL语句
 * @result 查询到的数据，成员变量为字典，字典键为列名，字典值为数据
 */
- (NSArray<NSDictionary<NSString *, id> *> *)selectRecordsInFields:(NSArray<DBTableField *> *)fields bySQL:(NSString *)sql;

/*!
 * @brief 查询数据库，执行数量查询语句
 * @param sql SQL语句
 * @result 查询到的数据纪录的数量
 */
- (int)selectRecordCountBySQL:(NSString *)sql;

@end
