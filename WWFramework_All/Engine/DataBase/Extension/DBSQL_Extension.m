//
//  DBSQL_Extension.m
//  FoundationProject
//
//  Created by user on 13-11-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DBSQL_Extension.h"

#pragma mark - DBSQL (String)

@implementation DBSQL (String)

+ (NSString *)stringOfValues:(NSArray *)values
{
    NSMutableString *valueString = [NSMutableString string];
    
    for (int i = 0; i < [values count]; i ++)
    {
        id value = [values objectAtIndex:i];
        
        if ([value isKindOfClass:[NSString class]])
        {
            [valueString appendFormat:@"%@,", [((NSString *)value) SQLedValueString]];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            double doubleValue = [value doubleValue];
            int intValue = [value intValue];
            
            if (doubleValue == intValue)
            {
                [valueString appendFormat:@"%d,", intValue];
            }
            else
            {
                [valueString appendFormat:@"%f,", doubleValue];
            }
        }
    }
    
    if ([valueString hasSuffix:@","])
    {
        [valueString replaceOccurrencesOfString:@"," withString:@"" options:NSAnchoredSearch|NSBackwardsSearch range:NSMakeRange(0, [valueString length])];
    }
    
    return [valueString length] ? valueString : nil;
}

+ (NSString *)stringOfFieldsSequencings:(NSArray *)sequencingContexts
{
    NSMutableString *sequencingString = nil;
    
    if ([sequencingContexts count])
    {
        sequencingString = [NSMutableString stringWithString:@"order by "];
        
        for (DBFieldSequencingContext *context in sequencingContexts)
        {
            [sequencingString appendFormat:@"%@ %@,", context.fieldName, (context.sequencingType == DBSequencingType_Descendingly) ? @"desc" : @"asc"];
        }
        
        if ([sequencingString hasSuffix:@","])
        {
            [sequencingString replaceOccurrencesOfString:@"," withString:@"" options:NSAnchoredSearch|NSBackwardsSearch range:NSMakeRange(0, [sequencingString length])];
        }
    }
    
    return sequencingString;
}

@end
