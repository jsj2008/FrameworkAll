//
//  NotificationBlockLoader.h
//  FoundationProject
//
//  Created by user on 13-11-7.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @class
        NotificationBlockLoader
 
    @abstract
        消息Block承载器
 
 **********************************************************/

@interface NotificationBlockLoader : NSObject

/*!
 * @brief 初始化
 * @param block 承载的Block
 * @result 初始化的对象
 */
- (id)initWithBlock:(void (^)(id observer))block observer:(id)observer;

/*!
 * @brief 执行Block
 */
- (void)exeBlock;

@end
