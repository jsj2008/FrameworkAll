//
//  DateComputing.m
//  FoundationProject
//
//  Created by Baymax on 13-12-23.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DateComputing.h"

@implementation NSDate (Compute)

- (NSDate *)dateAfterDateComponents:(NSDateComponents *)components
{
    return components ? [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0] : nil;
}

- (NSDate *)dateAfterYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setYear:year];
    
    [dateComponents setMonth:month];
    
    [dateComponents setDay:day];
    
    [dateComponents setHour:hour];
    
    [dateComponents setMinute:minute];
    
    [dateComponents setSecond:second];
    
    return [self dateAfterDateComponents:dateComponents];
}

@end
