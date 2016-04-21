//
//  COperation.m
//  FoundationProject
//
//  Created by WW on 14-1-24.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "COperation.h"

#pragma mark - COperation

@implementation COperation

@end


#pragma mark - COperation (Array)

@implementation COperation (Array)

+ (NSInteger)indexOfInt:(int)number inIntArray:(int [])array
{
    NSInteger index = -1;
    
    if (array)
    {
        NSUInteger arrayCount = sizeof((int *)array) / sizeof(int);
        
        for (int i = 0; i < arrayCount; i ++)
        {
            if (number == array[i])
            {
                index = i;
                
                break;
            }
        }
    }
    
    return index;
}

+ (NSInteger)indexOfDouble:(double)number inDoubleArray:(double [])array
{
    NSInteger index = -1;
    
    if (array)
    {
        NSUInteger arrayCount = sizeof((double *)array) / sizeof(double);
        
        for (int i = 0; i < arrayCount; i ++)
        {
            if (number == array[i])
            {
                index = i;
                
                break;
            }
        }
    }
    
    return index;
}

+ (NSInteger)indexOfCString:(const char *)cString inCStringArray:(char *[])array
{
    NSInteger index = -1;
    
    if (cString && array)
    {
        NSUInteger arrayCount = sizeof((char **)array) / sizeof(char *);
        
        for (int i = 0; i < arrayCount; i ++)
        {
            char *cStringInArray = array[i];
            
            if (!strcmp(cString, cStringInArray))
            {
                index = i;
                
                break;
            }
        }
    }
    
    return index;
}

@end
