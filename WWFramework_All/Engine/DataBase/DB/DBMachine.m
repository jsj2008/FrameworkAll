//
//  DBMachine.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBMachine.h"
#import "DBLog.h"

@implementation DBMachine

- (void)dealloc
{
    sqlite3_close(_db);
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        if (filePath)
        {
            _filePath = [filePath copy];
        }
    }
    
    return self;
}

- (BOOL)start
{
    int code = sqlite3_open([_filePath UTF8String], &_db);
    
    BOOL success = code == SQLITE_OK;
    
    if (!success)
    {
        [[DBLog sharedInstance] logStringWithFormat:@"DB open error: {Path = '%@'; SQLite3_Code = '%d'}", _filePath, code];
    }
    
    return success;
}

- (BOOL)executeSQL:(NSString *)sql
{
    BOOL success = NO;
    char *errorMsg;
    
    success = (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK);
    
    if (!success && errorMsg)
    {
        [[DBLog sharedInstance] logStringWithFormat:@"DB execute error: {SQL = '%@'; Message = '%s'}", sql, errorMsg];
    }
    
    sqlite3_free(errorMsg);
    
    return success;
}

- (sqlite3_stmt *)preparedStatementForSQL:(NSString *)sql
{
    sqlite3_stmt *statement = NULL;
    
    int code = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL);
    
    if (code != SQLITE_OK)
    {
        [[DBLog sharedInstance] logStringWithFormat:@"DB prepare error: {SQL = '%@'; SQLite3_Code = '%d'}", sql, code];
        
        sqlite3_finalize(statement);
        statement = NULL;
    }
    
    return statement;
}

- (void)bindValue:(id)value byType:(DBValueType)type toPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location
{
    if (value && statement)
    {
        switch (type)
        {
            case DBValueType_Int:
            case DBValueType_LongLong:
                sqlite3_bind_int64(statement, location, [(NSNumber *)value longLongValue]);
                break;
            case DBValueType_Double:
                sqlite3_bind_double(statement, location, [(NSNumber *)value doubleValue]);
                break;
            case DBValueType_Text:
                sqlite3_bind_text(statement, location, [(NSString *)value UTF8String], -1, SQLITE_TRANSIENT);
                break;
            case DBValueType_Blob:
                sqlite3_bind_blob(statement, location, [(NSData *)value bytes], (int)[(NSData *)value length], SQLITE_TRANSIENT);
                break;
            case DBValueType_NULL:
                sqlite3_bind_null(statement, location);
            default:
                break;
        }
    }
}

- (id)columnValueFromPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location inType:(DBValueType)type
{
    id value = nil;
    
    switch (type)
    {
        case DBValueType_Int:
            value = [NSNumber numberWithLongLong:sqlite3_column_int64(statement, location)];
            break;
        case DBValueType_LongLong:
            value = [NSNumber numberWithLongLong:sqlite3_column_int64(statement, location)];
            break;
        case DBValueType_Double:
            value = [NSNumber numberWithDouble:sqlite3_column_double(statement, location)];
            break;
        case DBValueType_Text:
        {
            const unsigned char *text = sqlite3_column_text(statement, location);
            if (text)
            {
                value = [NSString stringWithUTF8String:(char *)text];
            }
        }
            break;
        case DBValueType_Blob:
            value = [NSData dataWithBytes:sqlite3_column_blob(statement, location) length:sqlite3_column_bytes(statement, location)];
            break;
        default:
            break;
    }
    
    return value;
}

- (NSString *)columnNameOfPreparedStatement:(sqlite3_stmt *)statement inLocation:(int)location
{
    return [NSString stringWithUTF8String:sqlite3_column_name(statement, location)];
}

- (int)columnDataCountOfPreparedStatement:(sqlite3_stmt *)statement
{
    return sqlite3_data_count(statement);
}

- (int)stepStatement:(sqlite3_stmt *)statement
{
    return sqlite3_step(statement);
}

- (void)resetStatement:(sqlite3_stmt *)statement
{
    sqlite3_reset(statement);
}

- (void)finalizeStatement:(sqlite3_stmt *)statement
{
    sqlite3_finalize(statement);
}

- (BOOL)commitTransactionBlock:(void (^)(void))block
{
    BOOL success = YES;
    
    if ([self executeSQL:@"begin transaction;"])
    {
        block();
        
        if (![self executeSQL:@"commit transaction;"])
        {
            success = NO;
            
            [self executeSQL:@"rollback transaction"];
        }
    }
    else
    {
        success = NO;
    }
    
    return success;
}

@end
