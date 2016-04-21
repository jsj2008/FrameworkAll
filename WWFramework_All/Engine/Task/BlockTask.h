//
//  BlockTask.h
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationTask.h"

@protocol BlockTaskDelegate;

#pragma mark - BlockTask

/*********************************************************
 
    @class
        BlockTask
 
    @abstract
        功能块Task，用于执行特定的块代码
 
    @discussion
        1，Task只执行功能块中指定的代码，执行后自动调用协议结束消息
        2，Task扩展了context属性，用于执行块代码时处理和传递数据，可以在功能块中任意修改其值，在协议结束消息中可以从task参数中读取其值
        3，Task关闭了派发子Task的功能
        4，代码块开始执行后，Task的cancel操作将失去作用；欲停止代码块的运行，必须由调用者对代码块实现控制
 
 *********************************************************/

@interface BlockTask : FoundationTask

/*!
 * @brief 功能块
 */
@property (nonatomic, copy) void (^block)(void);

/*!
 * @brief 上下文属性，可以承载在功能块中处理的数据
 */
@property (nonatomic, readonly) NSMutableDictionary *context;

@end


#pragma mark - BlockTaskDelegate

/*********************************************************
 
    @protocol
        BlockTaskDelegate
 
    @abstract
        功能块Task的协议
 
 *********************************************************/

@protocol BlockTaskDelegate <NSObject>

/*!
 * @brief Task结束消息
 * @param task task对象
 */
- (void)blockTaskDidFinish:(BlockTask *)task;

@end


#pragma mark - NSMutableDictionary (BlockTask)

/*********************************************************
 
    @category
        NSMutableDictionary (BlockTask)
 
    @abstract
        字典的BlockTask扩展
 
 *********************************************************/

@interface NSMutableDictionary (BlockTask)

/*!
 * @brief 设置字典的BlockTask键值
 * @param object 值，若为nil，将不会设置键值对
 * @param key 键，若长度为0，将不会设置键值对
 */
- (void)setBlockTaskContextObject:(id)object forKey:(NSString *)key;

@end
