//
//  HTTPMultipartExtensionData.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-21.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPMultipartContentDisposition
 
    @abstract
        HTTP多表单数据的Content-Disposition首部数据
 
 *********************************************************/

@interface HTTPMultipartContentDisposition : NSObject

/*!
 * @brief 类型值
 */
@property (nonatomic, copy) NSString *type;

/*!
 * @brief 参数组
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *parameters;

/*!
 * @brief 初始化
 * @discussion 解析首部数据值来初始化内部变量
 * @param value Content-Disposition首部值
 * @result 初始化后的对象
 */
- (id)initWithHeaderFieldValue:(NSString *)value;

@end
