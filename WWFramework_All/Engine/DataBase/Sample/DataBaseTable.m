//
//  DataBaseTable.m
//  Demo
//
//  Created by Baymax on 13-10-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DataBaseTable.h"

@implementation DataBaseTable

- (id)initWithHandle:(DBHandle *)handle
{
    if (self = [super init])
    {
        _handle = handle;
    }
    
    return self;
}

- (BOOL)start
{
    return [self.table start];
}

- (void)mapFieldsFrom:(NSArray *)fromFields to:(NSArray *)toFields
{
    NSMutableArray *removeFields = [NSMutableArray arrayWithArray:fromFields];
    
    NSMutableArray *addFields = [NSMutableArray arrayWithArray:toFields];
    
    NSMutableArray *remainFields = [NSMutableArray array];
    
    for (DBTableField *field1 in fromFields)
    {
        for (DBTableField *field2 in toFields)
        {
            if ([field1.name isEqualToString:field2.name])
            {
                [remainFields addObject:field1];
            }
        }
    }
    
    [removeFields removeObjectsInArray:remainFields];
    
    [addFields removeObjectsInArray:remainFields];
    
    if ([removeFields count])
    {
        NSMutableArray *mappedFields = [NSMutableArray array];
        
        for (int i = 0; i < [removeFields count]; i ++)
        {
            [mappedFields addObject:[NSNull null]];
        }
        
        [self.table mapFields:removeFields toFields:mappedFields];
    }
    
    if ([addFields count])
    {
        [self.table addNewFields:addFields];
    }
}

- (BOOL)saveRecords:(NSArray *)records inMethod:(NSString *)method
{
    NSArray *dbRecords = [self dbRecordsFromDataRecords:records];
    
    return [dbRecords count] ? [self.table insertRecords:dbRecords intoFields:self.fields withInsertMethod:method] : YES;
}

- (NSArray *)allRecords
{
    NSArray *dbRecords = [self.table recordsFromFields:self.fields inCondition:nil];
    
    return [self dataRecordsFromDBRecords:dbRecords];
}

- (BOOL)cleanAllRecords
{
    return [self.table deleteRecordsInCondition:nil];
}

- (NSArray *)dataRecordsFromDBRecords:(NSArray *)dbRecords
{
    return nil;
}

- (NSArray *)dbRecordsFromDataRecords:(NSArray *)dataRecords
{
    return nil;
}

@end
