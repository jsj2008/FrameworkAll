//
//  SPTaskBlockLoader.h
//  TaskPool
//
//  Created by Baymax on 13-10-14.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @class
        SPTaskBlockLoader
 
    @abstract
        Task中使用的Block承载器
 
 **********************************************************/

@interface SPTaskBlockLoader : NSObject
{
    // 代码块
    void (^_block)(void);
}

/*!
 * @brief 初始化
 * @param block 承载的代码块
 * @result 初始化后的对象
 */
- (id)initWithBlock:(void (^)(void))block;

/*!
 * @brief 执行代码块
 */
- (void)exeBlock;

@end
