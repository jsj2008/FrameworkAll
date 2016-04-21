//
//  NSObject+Delegate.h
//  MarryYou
//
//  Created by ww on 15/7/22.
//  Copyright (c) 2015年 MiaoTo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @category
        NSObject (Delegate)
 
    @abstract
        NSObject的Delegate扩展
 
    @discussion
        所有的delegate对象都在内部弱引用
 
 **********************************************************/

@interface NSObject (Delegate)

/*!
 * @brief 添加delegate
 * @param delegate delegate对象
 */
- (void)addDelegate:(id)delegate;

/*!
 * @brief 移除delegate
 * @param delegate delegate对象
 */
- (void)removeDelegate:(id)delegate;

/*!
 * @brief 操作delegate
 * @param operation delegate操作
 */
- (void)operateDelegate:(void (^)(id delegate))operation;

@end
