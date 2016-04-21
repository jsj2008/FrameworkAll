//
//  DBSQL.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBSQL.h"

/******************** DBSQL ********************/

#pragma mark - DBSQL

@implementation DBSQL

+ (NSString *)SQLOfConfigureCacheSize:(long long)size;
{
    int page = (int)(size / 1500);
    
    return [NSString stringWithFormat:@"pragma cache_size = %d;", page];
}

+ (NSString *)SQLOfConfigureJournalMode:(BOOL)journalOrWAL
{
    return [NSString stringWithFormat:@"pragma journal_mode = %@;", journalOrWAL ? @"delete" : @"wal"];
}

+ (NSString *)SQLOfVacuum
{
    return @"vacuum;";
}

+ (NSString *)SQLOfVacuumTable:(NSString *)tableName
{
    return tableName ? [NSString stringWithFormat:@"vacuum %@;", tableName] : nil;
}

+ (NSString *)SQLOfCreateTableIfNotExistsWithTableName:(NSString *)tableName fields:(NSArray *)fields
{
    NSString *sql = nil;
    
    if ([fields count])
    {
        NSMutableString *fieldString = [NSMutableString string];
        NSMutableString *primaryString = [NSMutableString string];
        
        for (DBTableField *field in fields)
        {
            if ([field.name length])
            {
                [fieldString appendFormat:@"%@ %@, ", field.name, [DBSQL stringOfDBValueType:field.type]];
                
                if (field.primary)
                {
                    if ([primaryString length])
                    {
                        [primaryString appendFormat:@", %@", field.name];
                    }
                    else
                    {
                        [primaryString appendString:field.name];
                    }
                }
            }
        }
        
        if ([fieldString hasSuffix:@", "])
        {
            [fieldString deleteCharactersInRange:NSMakeRange([fieldString length] - 2, 2)];
        }
        
        if ([fieldString length] && [primaryString length])
        {
            sql = [NSString stringWithFormat:@"create table if not exists %@ (%@, primary key(%@));", tableName, fieldString, primaryString];
        }
        else if ([fieldString length])
        {
            sql = [NSString stringWithFormat:@"create table if not exists %@ (%@);", tableName, fieldString];
        }
    }
    
    return sql;
}

+ (NSString *)SQLOfRenameTableFromName:(NSString *)fromName toName:(NSString *)toName
{
    return fromName && toName ? [NSString stringWithFormat:@"alter table rename %@ to %@;", fromName, toName] : nil;
}

+ (NSString *)SQLOfAddField:(DBTableField *)field toTable:(NSString *)tableName
{
    return field && tableName ? [NSString stringWithFormat:@"alter table %@ add %@ %@;", tableName, field.name, [DBSQL stringOfDBValueType:field.type]] : nil;
}

+ (NSString *)SQLOfGetAllFieldsOfTable:(NSString *)tableName
{
    return tableName ? [NSString stringWithFormat:@"pragma table_info (%@);", tableName] : nil;
}

+ (NSString *)SQLOfDeleteTable:(NSString *)tableName inCondition:(NSString *)condition
{
    return tableName ? [NSString stringWithFormat:@"delete from %@ %@;", tableName, condition ? condition : @""] : nil;
}

+ (NSString *)SQLOfDropTable:(NSString *)tableName
{
    return tableName ? [NSString stringWithFormat:@"drop table %@;", tableName] : nil;
}

+ (NSString *)SQLOfInsertIntoTable:(NSString *)tableName withFields:(NSArray *)fields method:(NSString *)method
{
    NSString *sql = nil;
    
    if (tableName && [fields count])
    {
        NSMutableString *fieldString = [NSMutableString string];
        NSMutableString *valueString = [NSMutableString string];
        
        for (DBTableField *field in fields)
        {
            if ([fieldString length])
            {
                [fieldString appendFormat:@", %@", field.name];
                [valueString appendString:@", ?"];
            }
            else
            {
                [fieldString appendString:field.name];
                [valueString appendString:@"?"];
            }
        }
        
        if ([fieldString length] && [valueString length])
        {
            sql = [NSString stringWithFormat:@"%@ into %@ (%@) values (%@);", method ? method : @"insert or replace", tableName, fieldString, valueString];
        }
    }
    
    return sql;
}

+ (NSString *)SQLOfUpdateTable:(NSString *)tableName withFields:(NSArray *)fields inCondition:(NSString *)condition method:(NSString *)method;
{
    NSString *sql = nil;
    
    if (tableName && [fields count])
    {
        NSMutableString *fieldValueString = [NSMutableString string];
        
        for (DBTableField *field in fields)
        {
            if ([fieldValueString length])
            {
                [fieldValueString appendFormat:@", %@ = ?", field.name];
            }
            else
            {
                [fieldValueString appendFormat:@"%@ = ?", field.name];
            }
        }
        
        if ([fieldValueString length])
        {
            sql = [NSString stringWithFormat:@"%@ %@ set %@ %@;", method ? method : @"update", tableName, fieldValueString, condition ? condition : @""];
        }
    }
    
    return sql;
}

+ (NSString *)SQLOfSelectFields:(NSArray *)fields fromTable:(NSString *)tableName inCondition:(NSString *)condition
{
    NSString *sql = nil;
    
    if ([fields count] && tableName)
    {
        NSMutableString *fieldString = [NSMutableString string];
        
        for (DBTableField *field in fields)
        {
            if ([fieldString length])
            {
                [fieldString appendFormat:@", %@", field.name];
            }
            else
            {
                [fieldString appendFormat:@"%@", field.name];
            }
        }
        
        if ([fieldString length])
        {
            sql = [NSString stringWithFormat:@"select %@ from %@ %@;", fieldString, tableName, condition ? condition : @""];
        }
    }
    
    return sql;
}

+ (NSString *)SQLOfSelectRecordCountFromTable:(NSString *)tableName inCondition:(NSString *)condition
{
    return tableName ? [NSString stringWithFormat:@"select count(*) from %@ %@;", tableName, condition ? condition : @""] : nil;
}

@end


/******************** DBSQL (ValueType) ********************/

#pragma mark - DBSQL (ValueType)

@implementation DBSQL (ValueType)

+ (NSString *)stringOfDBValueType:(DBValueType)type
{
    NSString *string = nil;
    
    switch (type)
    {
        case DBValueType_Int:
        case DBValueType_LongLong:
            string = @"integer";
            break;
        case DBValueType_Double:
            string = @"double";
            break;
        case DBValueType_Text:
            string = @"text";
            break;
        case DBValueType_Blob:
            string = @"blob";
            break;
        case DBValueType_NULL:
            string = @"null";
            break;
        default:
            break;
    }
    
    return [string length] ? string : @"";
}

+ (DBValueType)DBValueTypeFromString:(NSString *)string
{
    DBValueType type = 0;
    
    if ([string isEqualToString:@"integer"] ||
        [string isEqualToString:@"int"] ||
        [string isEqualToString:@"unsigned int"] ||
        [string isEqualToString:@"long"] ||
        [string isEqualToString:@"long long"] ||
        [string isEqualToString:@"interger"] ||
        [string isEqualToString:@"NSInteger"] ||
        [string isEqualToString:@"NSUInteger"])
    {
        type = DBValueType_Int;
    }
    else if ([string isEqualToString:@"double"] ||
             [string isEqualToString:@"float"] ||
             [string isEqualToString:@"real"])
    {
        type = DBValueType_Double;
    }
    else if ([string isEqualToString:@"text"] ||
             [string isEqualToString:@"string"])
    {
        type = DBValueType_Text;
    }
    else if ([string isEqualToString:@"blob"] ||
             [string isEqualToString:@"data"])
    {
        type = DBValueType_Blob;
    }
    else if ([string isEqualToString:@"null"] ||
             [string isEqualToString:@"nil"] ||
             [string isEqualToString:@"none"])
    {
        type = DBValueType_NULL;
    }
    
    return type;
}

@end
