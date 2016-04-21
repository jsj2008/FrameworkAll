//
//  JsonSerialize.m
//  FoundationProject
//
//  Created by user on 13-11-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "JsonSerialize.h"
#import "APPDebug.h"

#pragma mark - NSData (JsonSerialize)

@implementation NSData (JsonSerialize)

- (id)jsonRootNode
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}

+ (NSData *)dataWithJsonRootNode:(id)node
{
    return node ? [NSJSONSerialization dataWithJSONObject:node options:0 error:nil] : nil;
}

@end


#pragma mark - NSString (JsonSerialize)

@implementation NSString (JsonSerialize)

- (id)jsonRootNode
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] jsonRootNode];
}

+ (NSString *)stringWithJsonRootNode:(id)node
{
    // NSJSONSerialization会将/转义成\/，需手动将其反转
    return node ? [[[NSString alloc] initWithData:[NSData dataWithJsonRootNode:node] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] : nil;
}

@end


#pragma mark - NSDictionary (JsonObject)

@implementation NSDictionary (JsonObject)

- (id)jsonObjectForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNull class]])
    {
        value = nil;
    }
    
    return value;
}

- (NSString *)jsonStringForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSString class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for string"];
        
        value = nil;
    }
    
    return value;
}

- (NSArray *)jsonArrayForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSArray class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array"];
        
        value = nil;
    }
    
    return value;
}

- (NSDictionary *)jsonDictionaryForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSDictionary class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for dictionary"];
        
        value = nil;
    }
    
    return value;
}

- (int)jsonIntForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSNumber class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for int"];
        
        value = nil;
    }
    
    return [(NSNumber *)value intValue];
}

- (float)jsonFloatForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSNumber class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for float"];
        
        value = nil;
    }
    
    return [(NSNumber *)value floatValue];
}

- (double)jsonDoubleForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if (value && ![value isKindOfClass:[NSNumber class]])
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for double"];
        
        value = nil;
    }
    
    return [(NSNumber *)value doubleValue];
}

@end


#pragma mark - NSMutableDictionary (JsonObject)

@implementation NSMutableDictionary (JsonObject)

- (void)setJsonObject:(id)object forKey:(NSString *)key
{
    if (key && object && [key length] && ![object isKindOfClass:[NSNull class]])
    {
        [self setObject:object forKey:key];
    }
}

@end


#pragma mark - NSArray (JsonObject)

@implementation NSArray (JsonObject)

- (id)jsonObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return object;
}

- (NSString *)jsonStringAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSString class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for string"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return object;
}

- (NSArray *)jsonArrayAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSArray class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for array"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return object;
}

- (NSDictionary *)jsonDictionaryAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSDictionary class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for dictionary"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return object;
}

- (int)jsonIntAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for int"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return [object intValue];
}

- (float)jsonFloatAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for float"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return [object floatValue];
}

- (double)jsonDoubleAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            [APPDebug assertWithCondition:NO string:@"json parse failed for double"];
            
            object = nil;
        }
    }
    else
    {
        [APPDebug assertWithCondition:NO string:@"json parse failed for array index"];
    }
    
    return [object doubleValue];
}

@end
