//
//  DBTable.m
//  DB
//
//  Created by Baymax on 13-7-17.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBTable.h"
#import "DBSQL.h"

/********************** DBTable **********************/

#pragma mark - DBTable

@interface DBTable ()
{
    // 表名
    NSString *_name;
    
    // 数据列
    NSMutableArray *_fields;
    
    // 同步队列
    dispatch_queue_t _syncQueue;
}

/*!
 * @brief 表名
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 数据列
 */
@property (nonatomic) NSMutableArray *fields;

@end


@implementation DBTable

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)initWithHandle:(DBHandle *)handle tableName:(NSString *)tableName fields:(NSArray<DBTableField *> *)fields
{
    if (self = [super init])
    {
        _handle = handle;
        
        _name = [tableName copy];
        
        _fields = [[NSMutableArray alloc] initWithArray:fields];
        
        _syncQueue = dispatch_queue_create(NULL, NULL);
    }
    
    return self;
}

- (BOOL)start
{
    __block BOOL success = NO;
    
    dispatch_sync(_syncQueue, ^{
        
        NSString *createTableSQL = [DBSQL SQLOfCreateTableIfNotExistsWithTableName:_name fields:_fields];
        
        success = createTableSQL ? [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:createTableSQL]] : NO;
        
        if (success)
        {
            NSString *getFieldsSQL = [DBSQL SQLOfGetAllFieldsOfTable:_name];
            
            DBTableField *field1 = [[DBTableField alloc] initWithName:@"name" type:DBValueType_Text primary:NO];
            DBTableField *field2 = [[DBTableField alloc] initWithName:@"type" type:DBValueType_Text primary:NO];
            DBTableField *field3 = [[DBTableField alloc] initWithName:@"pk" type:DBValueType_Int primary:NO];
            
            if (getFieldsSQL)
            {
                NSArray *records = [_handle selectRecordsInFields:[NSArray arrayWithObjects:field1, field2, field3, nil] bySQL:getFieldsSQL];
                
                [_fields removeAllObjects];
                
                for (NSDictionary *record in records)
                {
                    NSString *name = [record objectForKey:@"name"];
                    NSString *typeString = [record objectForKey:@"type"];
                    int pk = [(NSNumber *)[record objectForKey:@"pk"] intValue];
                    
                    DBValueType type = [DBSQL DBValueTypeFromString:typeString];
                    BOOL primary = pk;
                    
                    DBTableField *field = [[DBTableField alloc] initWithName:name type:type primary:primary];
                    [_fields addObject:field];
                }
            }  
        }
    });
    
    return success;
}

- (NSString *)currentTableName
{
    __block NSString *name = nil;
    
    dispatch_sync(_syncQueue, ^{
        
        name = [_name copy];
    });
    
    return name;
}

- (NSArray<DBTableField *> *)currentFields
{
    NSMutableArray *fields = [NSMutableArray array];
    
    dispatch_sync(_syncQueue, ^{
        
        [fields addObjectsFromArray:_fields];
    });
    
    return fields;
}

- (BOOL)renameToNewName:(NSString *)name
{
    __block BOOL success = NO;
    
    if ([_name isEqualToString:name])
    {
        success = YES;
    }
    else
    {
        NSString *sql = [DBSQL SQLOfRenameTableFromName:_name toName:name];
        
        if (sql)
        {
            dispatch_sync(_syncQueue, ^{
                
                success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:sql]];
                
                if (success && _name)
                {
                    _name = [name copy];
                }
            });
        } 
    }
    
    return success;
}

- (BOOL)addNewFields:(NSArray<DBTableField *> *)fields
{
    __block BOOL success = YES;
    
    if ([fields count])
    {
        dispatch_sync(_syncQueue, ^{
            
            for (DBTableField *field in fields)
            {
                NSString *sql = [DBSQL SQLOfAddField:field toTable:_name];
                
                success = sql ? [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:sql]] : NO;
                
                if (success)
                {
                    [_fields addObject:field];
                }
            }
        });
    }
    
    return success;
}

- (BOOL)mapFields:(NSArray<DBTableField *> *)fromFields toFields:(NSArray<DBTableField *> *)toFields
{
    __block BOOL success = NO;
    
    if (fromFields && toFields && [fromFields count] == [toFields count])
    {
        success = YES;
        
        dispatch_sync(_syncQueue, ^{
            
            NSMutableArray *fields1 = [NSMutableArray arrayWithArray:_fields];
            
            NSMutableArray *fields2 = [NSMutableArray arrayWithArray:_fields];
            
            for (int i = 0; i < [fields1 count]; i ++)
            {
                DBTableField *field1 = [fields1 objectAtIndex:i];
                
                for (int j = 0; j < [fromFields count]; j ++)
                {
                    DBTableField *fromField = [fromFields objectAtIndex:j];
                    
                    if ([field1.name isEqualToString:fromField.name])
                    {
                        [fields2 replaceObjectAtIndex:i withObject:[toFields objectAtIndex:j]];
                    }
                }
            }
            
            // 如果fields2未改变，说明传入的数据列在原表中都不存在，不需要映射
            if (![fields2 isEqualToArray:_fields])
            {
                NSString *tempTableName = [NSString stringWithFormat:@"temp_%@", _name];
                
                NSString *renameSQL = [DBSQL SQLOfRenameTableFromName:_name toName:tempTableName];
                
                if (renameSQL)
                {
                    success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:renameSQL]];
                }
                
                if (success)
                {
                    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                    
                    for (int i = 0; i < [fields2 count]; i ++)
                    {
                        if ([[fields2 objectAtIndex:i] isKindOfClass:[NSNull class]])
                        {
                            [indexSet addIndex:i];
                        }
                    }
                    
                    [fields1 removeObjectsAtIndexes:indexSet];
                    
                    [fields2 removeObjectsAtIndexes:indexSet];
                    
                    NSString *createTableSQL = [DBSQL SQLOfCreateTableIfNotExistsWithTableName:_name fields:fields2];
                    
                    if (createTableSQL)
                    {
                        success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:createTableSQL]];
                    }
                    
                    if (success && [fields1 count] && [fields2 count])
                    {
                        void (^combineFieldsToString)(NSArray *, NSMutableString *) = ^(NSArray *fields, NSMutableString *string){
                            
                            for (DBTableField *field in fields)
                            {
                                if (field.name)
                                {
                                    [string appendFormat:@"%@,", field.name];
                                }
                            }
                            
                            [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
                        };
                        
                        NSMutableString *string1 = [NSMutableString string];
                        
                        NSMutableString *string2 = [NSMutableString string];
                        
                        combineFieldsToString(fields1, string1);
                        
                        combineFieldsToString(fields2, string2);
                        
                        NSString *selectFieldsSQL = [NSString stringWithFormat:@"insert into %@ (%@) select %@ from %@;", _name, string1, string2, tempTableName];
                        
                        if (selectFieldsSQL)
                        {
                            success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:selectFieldsSQL]];
                        } 
                    }
                    
                    // 创建新表或迁移数据时出错，删除新表，将临时表转回原表（临时表是原表的拷贝，没有进行数据改动）
                    if (!success)
                    {
                        NSString *dropSQL = [DBSQL SQLOfDropTable:_name];
                        
                        if (dropSQL)
                        {
                            [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:dropSQL]];
                        }
                        
                        NSString *renameSQL = [DBSQL SQLOfRenameTableFromName:tempTableName toName:_name];
                        
                        if (renameSQL)
                        {
                            [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:renameSQL]];
                        }
                    }
                    
                    // 无论临时表是否还存在，都进行一次删除临时表的操作（临时表转回原表时理应消失，但重命名错误可能造成临时表残留），确保临时表消失
                    NSString *dropSQL = [DBSQL SQLOfDropTable:tempTableName];
                    
                    if (dropSQL)
                    {
                        success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:dropSQL]];
                    }
                }
            }
        });
    }
    
    return success;
}

- (BOOL)drop
{
    __block BOOL success = NO;
    
    NSString *sql = [DBSQL SQLOfDropTable:_name];
    
    if (sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:sql]];
        });
    }
    
    return success;
}

- (BOOL)vacuum
{
    __block BOOL success = NO;
    
    NSString *sql = [DBSQL SQLOfVacuumTable:_name];
    
    if (sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:sql]];
        });
    }
    
    return success;
}

- (BOOL)insertRecords:(NSArray<NSDictionary<NSString *,id> *> *)records intoFields:(NSArray<DBTableField *> *)fields withInsertMethod:(NSString *)method
{
    __block BOOL success = YES;
    
    NSString *sql = [DBSQL SQLOfInsertIntoTable:_name withFields:fields method:method];
    
    if (sql && [records count] && [fields count])
    {
        dispatch_sync(_syncQueue, ^{
            
            success = [_handle updateDBByBindingSQL:sql withFields:fields records:records];
        });
    }    
    
    return success;
}

- (BOOL)updateRecord:(NSDictionary<NSString *,id> *)record intoFields:(NSArray<DBTableField *> *)fields inCondition:(NSString *)condition withUpdateMethod:(NSString *)method
{
    __block BOOL success = YES;
    
    NSString *sql = [DBSQL SQLOfUpdateTable:_name withFields:fields inCondition:condition method:method];
    
    if (sql && [record count] && [fields count])
    {
        dispatch_sync(_syncQueue, ^{
            
            success = [_handle updateDBByBindingSQL:sql withFields:fields records:[NSArray arrayWithObject:record]];
        });
    }
    
    return success;
}

- (NSArray<NSDictionary<NSString *,id> *> *)recordsFromFields:(NSArray<DBTableField *> *)fields inCondition:(NSString *)condition
{
    __block NSArray *records = nil;
    
    NSArray *selectFields = fields ? fields : _fields;
    
    NSString *sql = [DBSQL SQLOfSelectFields:selectFields fromTable:_name inCondition:condition];
    
    if (sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            records = [_handle selectRecordsInFields:selectFields bySQL:sql];
        });
    }
    
    return records;
}

- (NSInteger)recordCountInCondition:(NSString *)condition
{
    __block NSInteger count = 0;
    
    NSString *sql = [DBSQL SQLOfSelectRecordCountFromTable:_name inCondition:condition];
    
    if (sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            count = [_handle selectRecordCountBySQL:sql];
        });
    }
    
    return count;
}

- (BOOL)deleteRecordsInCondition:(NSString *)condition
{
    __block BOOL success = NO;
    
    NSString *sql = [DBSQL SQLOfDeleteTable:_name inCondition:condition];
    
    if (sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            success = [_handle updateDBByExecutingSQLs:[NSArray arrayWithObject:sql]];
        });
    }
    
    return success;
}

@end


/********************** DBTable (Operation) **********************/

#pragma mark - DBTable (Operation)

@implementation DBTable (Operation)

- (void)exeOperation:(void (^)(void))operation
{
    dispatch_sync(_syncQueue, ^{
        
        operation();
    });
}

@end
