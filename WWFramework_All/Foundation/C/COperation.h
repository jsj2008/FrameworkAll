//
//  COperation.h
//  FoundationProject
//
//  Created by WW on 14-1-24.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - COperation

/*********************************************************
 
    @class
        COperation
 
    @abstract
        针对C语言形式的操作
 
 *********************************************************/

@interface COperation : NSObject

@end


#pragma mark - COperation (Array)

/*********************************************************
 
    @category
        COperation (Array)
 
    @abstract
        针对C语言的数组操作
 
 *********************************************************/

@interface COperation (Array)

/*!
 * @brief 数组中的int变量索引
 * @param number int变量
 * @param array int数组
 * @result 索引位置，若检索不到，返回－1
 */
+ (NSInteger)indexOfInt:(int)number inIntArray:(int[])array;

/*!
 * @brief 数组中的double变量索引
 * @param number double变量
 * @param array double数组
 * @result 索引位置，若检索不到，返回－1
 */
+ (NSInteger)indexOfDouble:(double)number inDoubleArray:(double[])array;

/*!
 * @brief 数组中的C字符串索引
 * @param cString C字符串
 * @param array C字符串数组
 * @result 索引位置，若检索不到，返回－1
 */
+ (NSInteger)indexOfCString:(const char *)cString inCStringArray:(char *[])array;

@end
