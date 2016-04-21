//
//  VoidBlockLoader.h
//  Application
//
//  Created by Baymax on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @class
        VoidBlockLoader
 
    @abstract
        无参数Block承载器
 
 **********************************************************/

@interface VoidBlockLoader : NSObject
{
    // 承载的代码块
    void (^_block)(void);
}

/*!
 * @brief 初始化
 * @param block 承载的Block
 * @result 初始化的对象
 */
- (id)initWithBlock:(void (^)(void))block;

/*!
 * @brief 执行Block
 */
- (void)exeBlock;

@end
