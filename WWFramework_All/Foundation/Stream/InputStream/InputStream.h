//
//  InputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        InputStream
 
    @abstract
        输入流
 
    @discussion
        InputStream是一个纯基类，需要子类继承来实现具体功能
 
 *********************************************************/

@interface InputStream : NSObject
{
    // 结束标志
    BOOL _over;
}

/*!
 * @brief 用户字典
 * @discussion 用于传递用户信息
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 从流中读取数据
 * @discussion 须由子类重载
 * @param length 可读取的最大长度
 * @result 读取到的数据
 */
- (NSData *)readDataOfMaxLength:(NSUInteger)length;

/*!
 * @brief 判断流是否结束
 * @result 流是否结束
 */
- (BOOL)isOver;

@end
