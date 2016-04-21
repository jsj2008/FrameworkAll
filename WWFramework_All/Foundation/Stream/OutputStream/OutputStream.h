//
//  OutputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        OutputStream
 
    @abstract
        输出流
 
    @discussion
        OutputStream是一个纯基类，需要子类继承来实现具体功能
 
 *********************************************************/

@interface OutputStream : NSObject

/*!
 * @brief 用户字典
 * @discussion 用于传递用户信息
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 向流中写入数据
 * @param data 数据
 */
- (void)writeData:(NSData *)data;

@end
