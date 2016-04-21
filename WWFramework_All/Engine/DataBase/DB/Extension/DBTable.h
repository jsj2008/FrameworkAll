//
//  DBTable.h
//  DB
//
//  Created by Baymax on 13-7-17.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandle.h"

/********************** DBTable **********************
 
    @class
        DBTable：数据库的数据表操作对象。
 
    @abstract
        实现数据表格的数据操作。
 
    @discussion
        1. DBTable对DBHandle进行了封装，实现数据表的完整操作，操作（方法）之间数据独立（同时执行两个方法，方法执行过程中的数据不会产生干扰）。
        2. DBTable是线程安全的，操作（方法）之间存在线程等待的情况。
        3. DBTable执行dealloc方法时会等待所有正在操作的数据库命令结束，因此可能会占用一段时间。
 
 ********************** DBTable **********************/

@interface DBTable : NSObject
{
    // 数据库文件句柄
    DBHandle *_handle;
}

/*!
 * @brief 数据库文件句柄
 */
@property (nonatomic, readonly) DBHandle *handle;

/*!
 * @brief 初始化
 * @param handle 数据库文件句柄
 * @param tableName 数据库表名
 * @param fields 数据表列
 * @result 初始化后得对象
 */
- (id)initWithHandle:(DBHandle *)handle tableName:(NSString *)tableName fields:(NSArray<DBTableField *> *)fields;

/*!
 * @brief 在数据库文件中创建表格(执行create if not exist命令)
 * @result 表格是否创建成功
 */
- (BOOL)start;

/*!
 * @brief 获取当前数据表名称
 * @result 当前数据表名称
 */
- (NSString *)currentTableName;

/*!
 * @brief 获取当前数据表所有列
 * @result 当前数据表所有列
 */
- (NSArray<DBTableField *> *)currentFields;

/*!
 * @brief 重命名表格
 * @param name 新表名
 * @result 重命名是否成功
 */
- (BOOL)renameToNewName:(NSString *)name;

/*!
 * @brief 添加新列
 * @discussion 不支持新增的列作为主键（之一），即DBTableField.primary无效
 * @param fields 新列
 * @result 添加是否成功
 */
- (BOOL)addNewFields:(NSArray<DBTableField *> *)fields;

/*!
 * @brief 映射列：将表格数据列从原有列转换成新列，包括重命名和删除
 * @discussion 映射过程中，将结合原始表格中的数据列和toFields中的数据列重新生成新的主键
 * @discussion 映射过程不改变数据列在原始表格中的顺序
 * @discussion fromFields由DBTableField对象组成，toFields由DBTableField和NSNull对象组成，要求两个数组大小相同
 * @discussion fromFields和toFields中相同的index的两个成员变量A和B，A是原列，B是新列，B=NSNull表征A为删除列，A=B表征该列不需要变动，A！=B表征A重命名为B。重命名过程中将忽略B的数据类型，保持A的数据类型
 * @discussion SQLite不支持表格数据列的重命名和删除操作，因此映射列的操作将执行以下几个操作：1）将原表更名为临时表；2）创建拥有原表名字的新表；3）从临时表将所需数据迁移至新表；4）删除临时表。操作后的新表即为映射后的数据表
 * @discussion 映射列是一个耗时的操作，当数据量庞大时非常明显，应当慎用
 * @discussion 当映射失败时，方法内部已经做了处理，努力恢复表格原始数据
 * @discussion 通常来说，映射总是能被正确执行并返回yes；映射失败时返回no，并能正确恢复原表数据
 * @discussion 用法：将需要变动的数据列组成数组传入方法即可，不需要将所有列或无需变动的数据列传入方法
 * @param fromFields 待映射的列
 * @param toFields 映射后的列
 * @result 映射是否成功
 */
- (BOOL)mapFields:(NSArray<DBTableField *> *)fromFields toFields:(NSArray<DBTableField *> *)toFields;

/*!
 * @brief 删除表格
 * @result 删除是否成功
 */
- (BOOL)drop;

/*!
 * @brief 压缩表格
 * @discussion 此方法可能占用较长时间，请慎用
 * @result 压缩是否成功
 */
- (BOOL)vacuum;

/*!
 * @brief 插入记录
 * @discussion 内部针对批量操作进行了优化
 * @param records 待插入的数据，由字典对象构成，字典键为列名，值为数据值
 * @param fields 待插入的数据对应的列
 * @param method 插入方法，要求符合SQL语法，例如“insert”，“insert or replace”，“insert or ignore”等。method = nil等价于“insert or replace”
 * @result 插入是否成功
 */
- (BOOL)insertRecords:(NSArray<NSDictionary<NSString *, id> *> *)records intoFields:(NSArray<DBTableField *> *)fields withInsertMethod:(NSString *)method;

/*!
 * @brief 更新记录
 * @param records 待更新的数据，由字典对象构成，字典键为列名，值为数据值
 * @param fields 待更新的数据对应的列
 * @param condition 更新时的条件，要求符合SQL语法
 * @param method 更新方法，要求符合SQL语法，例如“update”，“update or replace”，“update or ignore”等。method = nil等价于“update”
 * @result 插入是否成功
 */
- (BOOL)updateRecord:(NSDictionary<NSString *, id> *)record intoFields:(NSArray<DBTableField *> *)fields inCondition:(NSString *)condition withUpdateMethod:(NSString *)method;

/*!
 * @brief 查询指定列记录
 * @param fields 待查询的数据对应的列
 * @param condition 查询时的条件，要求符合SQL语法
 * @result 查询到的数据纪录，由字典对象构成，字典键为列名，值为数据值
 */
- (NSArray<NSDictionary<NSString *, id> *> *)recordsFromFields:(NSArray<DBTableField *> *)fields inCondition:(NSString *)condition;

/*!
 * @brief 查询符合条件的记录数
 * @param condition 查询时的条件，要求符合SQL语法
 * @result 查询到的纪录数
 */
- (NSInteger)recordCountInCondition:(NSString *)condition;

/*!
 * @brief 删除记录
 * @param condition 删除时的条件，要求符合SQL语法
 * @result 删除是否成功
 */
- (BOOL)deleteRecordsInCondition:(NSString *)condition;

@end


/********************** DBTable (Operation) **********************
 
    @class
        DBTable(Operation)：数据库的数据表操作对象。
 
    @abstract
        数据表对象执行自定义操作
 
    @discussion
        1. 自定义操作与DBTable其他方法之间数据独立（同时执行两个方法，方法执行过程中的数据不会产生干扰）
        2. 自定义操作是线程安全的
        3. 自定义操作Block内建议使用DBHandle完成数据操作
 
 ********************** DBTable (Operation) **********************/

@interface DBTable (Operation)

/*!
 * @brief 安全执行一次操作
 * @discussion 执行一系列数据库操作，与其他代码执行互不干扰，且线程安全，数据独立
 * @param operation 操作的代码块
 */
- (void)exeOperation:(void (^)(void))operation;

@end
