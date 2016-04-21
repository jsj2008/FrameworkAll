//
//  DBFormat.m
//  FoundationProject
//
//  Created by user on 13-11-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DBFormat.h"

#pragma mark - NSMutableDictionary (DB)

@implementation NSMutableDictionary (DB)

- (void)setDBObject:(id)object forKey:(NSString *)key
{
    if (object && [key length] && ![object isKindOfClass:[NSNull class]])
    {
        [self setObject:object forKey:key];
    }
}

@end


#pragma mark - NSDictionary (DB)

@implementation NSDictionary (DB)

- (id)DBObjectForKey:(NSString *)key
{
    id object = nil;
    
    if (key)
    {
        object = [self objectForKey:key];
        
        if ([object isKindOfClass:[NSNull class]])
        {
            object = nil;
        }
    }
    
    return object;
}

@end


#pragma mark - NSString (DB)

@implementation NSString (DB)

- (NSString *)SQLedValueString
{
    return [NSString stringWithFormat:@"'%@'", [self stringByReplacingOccurrencesOfString:@"\'" withString:@"''"]];
}

@end


#pragma mark - NSDate (DB)

@implementation NSDate (DB)

- (long long)DBDate
{
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate];
    
    return timeInterval * 1000;
}

+ (NSDate *)dateWithDBDate:(long long)DBDate
{
    NSTimeInterval timeInterval = DBDate / 1000.0;
    
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

@end


#pragma mark - DBFieldSequencingContext

@implementation DBFieldSequencingContext

- (id)init
{
    if (self = [super init])
    {
        self.sequencingType = DBSequencingType_Ascendingly;
    }
    
    return self;
}

@end
