//
//  StringComponent.m
//  Application
//
//  Created by Baymax on 14-3-3.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "StringComponent.h"

@implementation NSString (KVedStringComponent)

- (NSDictionary<NSString *,NSString *> *)KVedComponentsBySeparator:(NSString *)separator
{
    NSMutableDictionary *KVedComponents = nil;
    
    NSArray *stringComponents = [self componentsSeparatedByString:separator];
    
    if ([stringComponents count])
    {
        KVedComponents = [NSMutableDictionary dictionary];
        
        for (NSString *stringComponent in stringComponents)
        {
            NSRange range = [stringComponent rangeOfString:@"="];
            
            if (range.location != NSNotFound)
            {
                NSString *key = [stringComponent substringToIndex:range.location];
                
                if (range.location < [stringComponent length] - 1)
                {
                    NSString *value = [stringComponent substringFromIndex:range.location + 1];
                    
                    [KVedComponents setObject:value forKey:key];
                }
                else
                {
                    [KVedComponents setObject:@"" forKey:key];
                }
            }
            else
            {
                [KVedComponents setObject:@"" forKey:stringComponent];
            }
        }
    }
    
    return [KVedComponents count] ? KVedComponents : nil;
}

@end


@implementation NSDictionary (KVedStringComponent)

- (NSString *)KVedStringBySeparator:(NSString *)separator
{
    NSMutableString *string = nil;
    
    NSUInteger count = [self count];
    
    if (count)
    {
        string = [NSMutableString string];
        
        NSArray *keys = [self allKeys];
        
        for (int i = 0; i < count; i ++)
        {
            NSString *key = [keys objectAtIndex:i];
            
            NSString *value = [self objectForKey:key];
            
            if ([value isEqualToString:@""])
            {
                if (i)
                {
                    [string appendFormat:@"%@%@", separator, key];
                }
                else
                {
                    [string appendString:key];
                }
            }
            else
            {
                if (i)
                {
                    [string appendFormat:@"%@%@=%@", separator, key, value];
                }
                else
                {
                    [string appendFormat:@"%@=%@", key, value];
                }
            }
        }
    }
    
    return [string length] ? string : nil;
}

@end
