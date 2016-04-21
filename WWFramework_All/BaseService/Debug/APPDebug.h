//
//  Debug.h
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        APPDebug
 
    @abstract
        调试器
 
    @discussion
        调试器用于取代系统的调试函数，以期在调试处实现更多的控制，例如log打印等
 
 *********************************************************/

@interface APPDebug : NSObject

/*!
 * @brief 断言
 * @discussion 使用方法同NSAssert
 * @param condition 条件
 * @param string 断言语句
 */
+ (void)assertWithCondition:(BOOL)condition string:(NSString *)string;

@end
