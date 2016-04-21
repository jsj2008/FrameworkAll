//
//  NSCoder+DataedEncoding.m
//  Application
//
//  Created by NetEase on 14-8-20.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "NSCoder+DataedEncoding.h"

@implementation NSCoder (DataedEncoding)

- (void)dataedEncodeObject:(id)objv forKey:(NSString *)key
{
    if (objv && key)
    {
        [self encodeObject:objv forKey:key];
    }
}

- (void)dataedEncodeConditionalObject:(id)objv forKey:(NSString *)key
{
    if (objv && key)
    {
        [self encodeConditionalObject:objv forKey:key];
    }
}

- (void)dataedEncodeBool:(BOOL)boolv forKey:(NSString *)key
{
    if (boolv && key)
    {
        [self encodeBool:boolv forKey:key];
    }
}

- (void)dataedEncodeInt:(int)intv forKey:(NSString *)key
{
    if (intv && key)
    {
        [self encodeInt:intv forKey:key];
    }
}

- (void)dataedEncodeInteger:(NSInteger)intv forKey:(NSString *)key
{
    if (intv && key)
    {
        [self encodeInteger:intv forKey:key];
    }
}

- (void)dataedEncodeInt32:(int32_t)intv forKey:(NSString *)key
{
    if (intv && key)
    {
        [self encodeInt32:intv forKey:key];
    }
}

- (void)dataedEncodeInt64:(int64_t)intv forKey:(NSString *)key
{
    if (intv && key)
    {
        [self encodeInt64:intv forKey:key];
    }
}

- (void)dataedEncodeFloat:(float)realv forKey:(NSString *)key
{
    if (realv && key)
    {
        [self encodeFloat:realv forKey:key];
    }
}

- (void)dataedEncodeDouble:(double)realv forKey:(NSString *)key
{
    if (realv && key)
    {
        [self encodeDouble:realv forKey:key];
    }
}

- (void)dataedEncodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key
{
    if (bytesp && lenv && key)
    {
        [self encodeBytes:bytesp length:lenv forKey:key];
    }
}

@end
