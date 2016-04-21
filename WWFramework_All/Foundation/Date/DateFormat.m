//
//  DateFormat.m
//  FoundationProject
//
//  Created by user on 13-11-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "DateFormat.h"

#pragma mark - DateFormat

NSString * const DateFormatComponent_Blank = @" ";

NSString * const DateFormatComponent_Hyphen = @"-";

NSString * const DateFormatComponent_Colon = @":";

NSString * const DateFormatComponent_Comma = @",";

NSString * const DateFormatComponent_Virgule = @"/";


NSString * const DateFormatComponent_Year = @"Y";

NSString * const DateFormatComponent_Month = @"M";

NSString * const DateFormatComponent_Day = @"D";

NSString * const DateFormatComponent_Hour = @"H";

NSString * const DateFormatComponent_Minute = @"m";

NSString * const DateFormatComponent_Second = @"S";

NSString * const DateFormatComponent_Weekday = @"W";


@implementation DateFormat

@end


#pragma mark - NSDate (Format)

@implementation NSDate (Format)

+ (NSDate *)dateWithFormatString:(NSString *)formatString ofFormat:(DateFormat *)dateFormat
{
    NSDate *date = nil;
    
    if (formatString && dateFormat)
    {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        NSMutableArray *components = [NSMutableArray arrayWithArray:[formatString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,:-"]]];
        
        [components removeObject:@""];
        
        NSMutableArray *formatComponents = [NSMutableArray arrayWithArray:dateFormat.formatComponents];
        
        [formatComponents removeObjectsInArray:[NSArray arrayWithObjects:DateFormatComponent_Blank, DateFormatComponent_Colon, DateFormatComponent_Comma, DateFormatComponent_Hyphen, nil]];
        
        if ([formatComponents count] == [components count])
        {
            for (int i = 0; i < [components count]; i ++)
            {
                NSString *component = [components objectAtIndex:i];
                
                NSString *formatComponent = [formatComponents objectAtIndex:i];
                
                if ([formatComponent isEqualToString:DateFormatComponent_Year])
                {
                    NSUInteger year = [component intValue];
                    
                    if (dateFormat.yearInAbbreviation)
                    {
                        if (year < 30)
                        {
                            year = year + 2000;
                        }
                        else if (year < 100)
                        {
                            year = year + 1900;
                        }
                    }
                    
                    [dateComponents setYear:year];
                }
                else if ([formatComponent isEqualToString:DateFormatComponent_Month])
                {
                    [dateComponents setMonth:([dateFormat.monthStrings indexOfObject:component] + 1)];
                }
                else if ([formatComponent isEqualToString:DateFormatComponent_Day])
                {
                    [dateComponents setDay:[component intValue]];
                }
                else if ([formatComponent isEqualToString:DateFormatComponent_Hour])
                {
                    [dateComponents setHour:[component intValue]];
                }
                else if ([formatComponent isEqualToString:DateFormatComponent_Minute])
                {
                    [dateComponents setMinute:[component intValue]];
                }
                else if ([formatComponent isEqualToString:DateFormatComponent_Second])
                {
                    [dateComponents setSecond:[component intValue]];
                }
            }
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        date = [calendar dateFromComponents:dateComponents];
    }
    
    return date;
}

- (NSString *)formatStringOfFormat:(DateFormat *)dateFormat
{
    if (([dateFormat.monthStrings count] < 12) || ([dateFormat.weekdayStrings count] < 7))
    {
        return nil;
    }
    
    NSMutableString *formatString = [NSMutableString string];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:kCFCalendarUnitYear | kCFCalendarUnitMonth |
                                        kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute |
                                        kCFCalendarUnitSecond | kCFCalendarUnitWeekday
                                                   fromDate:self];
    
    for (NSString *formatComponent in dateFormat.formatComponents)
    {
        if ([formatComponent isEqualToString:DateFormatComponent_Year])
        {
            NSInteger year = [dateComponents year];
            
            if (dateFormat.yearInAbbreviation)
            {
                if (year >= 2000 && year <= 2029)
                {
                    year = year - 2000;
                }
                else if (year >= 1930 && year <= 1999)
                {
                    year = year - 1900;
                }
            }
            
            [formatString appendFormat:@"%ld", (long)year];
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Month])
        {
            [formatString appendFormat:@"%@", [dateFormat.monthStrings objectAtIndex:([dateComponents month] - 1)]];
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Day])
        {
            [formatString appendFormat:@"%ld", (long)[dateComponents day]];
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Hour])
        {
            NSInteger hour = [dateComponents hour];
            
            if (hour < 10)
            {
                [formatString appendFormat:@"0%ld", (long)hour];
            }
            else
            {
                [formatString appendFormat:@"%ld", (long)hour];
            }
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Minute])
        {
            NSInteger minute = [dateComponents minute];
            
            if (minute < 10)
            {
                [formatString appendFormat:@"0%ld", (long)minute];
            }
            else
            {
                [formatString appendFormat:@"%ld", (long)minute];
            }
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Second])
        {
            NSInteger second = [dateComponents second];
            
            if (second < 10)
            {
                [formatString appendFormat:@"0%ld", (long)second];
            }
            else
            {
                [formatString appendFormat:@"%ld", (long)second];
            }
        }
        else if ([formatComponent isEqualToString:DateFormatComponent_Weekday])
        {
            [formatString appendFormat:@"%@", [dateFormat.weekdayStrings objectAtIndex:([dateComponents weekday] - 1)]];
        }
        else
        {
            [formatString appendString:formatComponent];
        }
    }
    
    return formatString;
}

@end


#pragma mark - NSDate (FormatType)

@implementation NSDate (FormatType)

+ (NSDate *)dateWithFormatString:(NSString *)formatString byType:(DateFormatType)type
{
    if (![formatString length])
    {
        return nil;
    }
    
    NSDate *date = nil;
    
    DateFormat *format = [[DateFormat alloc] init];
    
    switch (type)
    {
        case DateFormatType_HTTPHeaderDate:
        {
            format.formatComponents = [NSArray arrayWithObjects:DateFormatComponent_Weekday,
                                       DateFormatComponent_Day,
                                       DateFormatComponent_Month,
                                       DateFormatComponent_Year,
                                       DateFormatComponent_Hour,
                                       DateFormatComponent_Minute,
                                       DateFormatComponent_Second, nil];
            
            format.monthStrings = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
            
            format.weekdayStrings = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
            
            NSDate *GMTDate = [self dateWithFormatString:[formatString stringByReplacingOccurrencesOfString:@" GMT" withString:@""] ofFormat:format];
            
            date = [GMTDate dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
            
            break;
        }
            
        case DateFormatType_HTTPCookieDate:
        {
            format.formatComponents = [NSArray arrayWithObjects:DateFormatComponent_Weekday,
                                       DateFormatComponent_Day,
                                       DateFormatComponent_Month,
                                       DateFormatComponent_Year,
                                       DateFormatComponent_Hour,
                                       DateFormatComponent_Minute,
                                       DateFormatComponent_Second, nil];
            
            format.monthStrings = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
            
            format.weekdayStrings = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
            
            format.yearInAbbreviation = YES;
            
            NSDate *GMTDate = [self dateWithFormatString:[formatString stringByReplacingOccurrencesOfString:@" GMT" withString:@""] ofFormat:format];
            
            date = [GMTDate dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
            
            break;
        }
            
        default:
            break;
    }
    
    return date;
}

- (NSString *)formatStringByType:(DateFormatType)type
{
    NSString *formatString = nil;
    
    DateFormat *format = [[DateFormat alloc] init];
    
    switch (type)
    {
        case DateFormatType_HTTPHeaderDate:
        {
            format.formatComponents = [NSArray arrayWithObjects:DateFormatComponent_Weekday,
                                       DateFormatComponent_Comma,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Day,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Month,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Year,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Hour,
                                       DateFormatComponent_Colon,
                                       DateFormatComponent_Minute,
                                       DateFormatComponent_Colon,
                                       DateFormatComponent_Second, nil];
            
            format.monthStrings = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
            
            format.weekdayStrings = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
            
            NSDate *GMTDate = [self dateByAddingTimeInterval:-[[NSTimeZone systemTimeZone] secondsFromGMT]];
            
            formatString = [[GMTDate formatStringOfFormat:format] stringByAppendingString:@" GMT"];
            
            break;
        }
            
        case DateFormatType_HTTPCookieDate:
        {
            format.formatComponents = [NSArray arrayWithObjects:DateFormatComponent_Weekday,
                                       DateFormatComponent_Comma,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Day,
                                       DateFormatComponent_Hyphen,
                                       DateFormatComponent_Month,
                                       DateFormatComponent_Hyphen,
                                       DateFormatComponent_Year,
                                       DateFormatComponent_Blank,
                                       DateFormatComponent_Hour,
                                       DateFormatComponent_Colon,
                                       DateFormatComponent_Minute,
                                       DateFormatComponent_Colon,
                                       DateFormatComponent_Second, nil];
            
            format.monthStrings = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
            
            format.weekdayStrings = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
            
            format.yearInAbbreviation = YES;
            
            NSDate *GMTDate = [self dateByAddingTimeInterval:-[[NSTimeZone systemTimeZone] secondsFromGMT]];
            
            formatString = [[GMTDate formatStringOfFormat:format] stringByAppendingString:@" GMT"];
        }
            
        default:
            break;
    }
    
    return formatString;
}

@end
