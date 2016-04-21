//
//  GroupedInputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-16.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "InputStream.h"
#import "InputStreamResetting.h"

/*********************************************************
 
    @class
        GroupedInputStream
 
    @abstract
        集合型数据输入流，将多个输入流合并成单个输入流进行处理
 
    @discussion
        流重置时，将对流集合中的每一个支持重置操作的流进行重置，对不支持重置操作的流不做操作
 
 *********************************************************/

@interface GroupedInputStream : InputStream <InputStreamResetting>
{
    // 数据流集合
    NSArray *_streamGroup;
}

/*!
 * @brief 初始化
 * @param group 数据流集合，由InputStream对象构成
 * @result 初始化后的对象
 */
- (id)initWithStreamGroup:(NSArray *)group;

@end
