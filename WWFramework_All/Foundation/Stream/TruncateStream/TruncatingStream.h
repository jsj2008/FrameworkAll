//
//  TruncatingStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TruncatingStreamDelegate;


@class TruncatingStreamTruncatedComponent;


/*********************************************************
 
    @class
        TruncatingStream
 
    @abstract
        截断流，用于对字节数据进行截断
 
    @discussion
        进行截断操作时，根据分隔符的先后顺序进行截断匹配，一旦匹配，立即使用当前分隔符进行截断
 
 *********************************************************/

@interface TruncatingStream : NSObject
{
    // 内部数据缓冲区
    NSMutableData *_buffer;
    
    // 被截下的数据
    NSMutableArray *_truncatedComponents;
    
    // 分隔符
    NSArray *_separators;
}

/*!
 * @brief 消息协议代理
 */
@property (nonatomic, weak) id<TruncatingStreamDelegate> delegate;

/*!
 * @brief 初始化
 * @param separators 分隔符，由NSData对象构成
 * @result 初始化后的对象
 */
- (id)initWithSeparators:(NSArray<NSData *> *)separators;

/*!
 * @brief 添加待截断的数据
 * @param data 新数据
 */
- (void)appendData:(NSData *)data;

/*!
 * @brief 截断操作
 * @discussion 进行截断操作时，根据分隔符的先后顺序进行截断匹配，一旦匹配，立即使用当前分隔符进行截断
 * @discussion 每成功截断一次数据，发送一次truncatingStream:shouldContinueTruncatingOnDidTruncateOneComponent:消息，可以利用该消息控制是否继续后续的截断操作
 */
- (void)truncate;

/*!
 * @brief 被截下的数据
 * @result 被截下的数据
 */
- (NSArray<TruncatingStreamTruncatedComponent *> *)truncatedComponents;

/*!
 * @brief 清理截断数据
 */
- (void)cleanTruncatedComponents;

/*!
 * @brief 未被截断的数据
 * @result 未被截断的数据
 */
- (NSData *)untruncatedData;

/*!
 * @brief 读取可用的未被截断的数据
 * @discussion 被读取的数据将在读取后从流中移除
 * @result 可用的未被截断的数据
 */
- (NSData *)readAvailableUntruncatedData;

@end


/*********************************************************
 
    @class
        TruncatingStreamTruncatedComponent
 
    @abstract
        截断流的截断数据
 
 *********************************************************/

@interface TruncatingStreamTruncatedComponent : NSObject

/*!
 * @brief 分隔符，表征当前数据被该分隔符截断
 */
@property (nonatomic) NSData *truncatingSeparator;

/*!
 * @brief 被截下的数据
 */
@property (nonatomic) NSData *truncatedData;

@end


/*********************************************************
 
    @protocol
        TruncatingStreamDelegate
 
    @abstract
        截断流的消息协议
 
 *********************************************************/

@protocol TruncatingStreamDelegate <NSObject>

/*!
 * @brief 截断到一份数据后是否需要继续截断
 * @discussion 通过本消息可以控制截断操作是否继续
 * @param stream 截断流
 * @param component 截断数据
 * @result 是否需要继续截断
 */
- (BOOL)truncatingStream:(TruncatingStream *)stream shouldContinueTruncatingOnDidTruncateOneComponent:(TruncatingStreamTruncatedComponent *)component;

@end
