//
//  DBSQL.h
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDefine.h"

/********************** DBSQL **********************
 
    @class
        DBSQL：SQL语句生成者。
 
    @abstract
        DBSQL用于生成一些常用的SQL语句。
 
    @discussion
        DBSQL的方法中传入的参数Fields数组均由DBTableField对象组成。
 
 ********************** DBSQL **********************/

@interface DBSQL : NSObject

+ (NSString *)SQLOfConfigureCacheSize:(long long)size;

+ (NSString *)SQLOfConfigureJournalMode:(BOOL)journalOrWAL;

+ (NSString *)SQLOfVacuum;

+ (NSString *)SQLOfVacuumTable:(NSString *)tableName;

+ (NSString *)SQLOfCreateTableIfNotExistsWithTableName:(NSString *)tableName fields:(NSArray *)fields;

+ (NSString *)SQLOfRenameTableFromName:(NSString *)fromName toName:(NSString *)toName;

+ (NSString *)SQLOfAddField:(DBTableField *)field toTable:(NSString *)tableName;

+ (NSString *)SQLOfGetAllFieldsOfTable:(NSString *)tableName;

+ (NSString *)SQLOfDeleteTable:(NSString *)tableName inCondition:(NSString *)condition;

+ (NSString *)SQLOfDropTable:(NSString *)tableName;

// method = nil等价于“insert or replace”
+ (NSString *)SQLOfInsertIntoTable:(NSString *)tableName withFields:(NSArray *)fields method:(NSString *)method;

// method = nil等价于“update”
+ (NSString *)SQLOfUpdateTable:(NSString *)tableName withFields:(NSArray *)fields inCondition:(NSString *)condition method:(NSString *)method;

+ (NSString *)SQLOfSelectFields:(NSArray *)fields fromTable:(NSString *)tableName inCondition:(NSString *)condition;

+ (NSString *)SQLOfSelectRecordCountFromTable:(NSString *)tableName inCondition:(NSString *)condition;

@end


/******************** DBSQL (ValueType) ********************
 
    @class
        DBSQL(ValueType)：SQL语句生成者。
 
    @abstract
        实现数据库数据类型和string的转换。
 
 ******************** DBSQL (ValueType) ********************/

@interface DBSQL (ValueType)

/*!
 * @brief 将数据类型转换成字符串
 * @discussion 转换表：
 * SMDBValueType_Int和SMDBValueType_LongLong：  @"integer"
 * SMDBValueType_Double：                       @"double"
 * SMDBValueType_Text：                         @"text"
 * SMDBValueType_Blob：                         @"blob"
 * SMDBValueType_NULL：                         @"null"
 * @param string 数据类型
 * @result 数据类型字符串
 */
+ (NSString *)stringOfDBValueType:(DBValueType)type;

/*!
 * @brief 将数据类型字符串转换成数据类型
 * @discussion 转换表：
 * integer，int，unsigned int，long，long long，interger，NSInteger，NSUInteger：  SMDBValueType_Int
 * double，float，real：                                                         SMDBValueType_Double
 * text，string：                                                                SMDBValueType_Text
 * blob，data：                                                                  SMDBValueType_Blob
 * null，nil，none：                                                             SMDBValueType_NULL
 * @param string 数据类型字符串
 * @result 数据类型
 */
+ (DBValueType)DBValueTypeFromString:(NSString *)string;

@end
