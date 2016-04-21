//
//  NSString+CharacterHandle.m
//  Application
//
//  Created by Baymax on 14-2-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "NSString+CharacterHandle.h"

@implementation NSString (CharacterHandle)

- (NSString *)stringByDeletingBothPrefixAndSuffixMarks:(NSString *)mark
{
    NSMutableString *string = [NSMutableString stringWithString:self];
    
    NSUInteger markLength = [mark length];
    
    if (markLength && ([string length] >= 2 * markLength) && [string hasPrefix:mark] && [string hasSuffix:mark])
    {
        [string deleteCharactersInRange:NSMakeRange(0, markLength)];
        
        if ([string length] >= markLength)
        {
            [string deleteCharactersInRange:NSMakeRange([string length] - markLength, markLength)];
        }
    }
    
    return string;
}

- (NSString *)stringByDeletingBothPrefixAndSuffixQuotationMarks
{
    return [self stringByDeletingBothPrefixAndSuffixMarks:@"\""];
}

@end
