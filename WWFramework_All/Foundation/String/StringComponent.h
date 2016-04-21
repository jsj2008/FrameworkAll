//
//  StringComponent.h
//  Application
//
//  Created by Baymax on 14-3-3.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (KVedStringComponent)
 
    @abstract
        NSString的键值要素扩展，封装字符串与字典间的转换
 
 *********************************************************/

@interface NSString (KVedStringComponent)

/*!
 * @brief 将字符串转换成字典
 * @discussion 字符串按照分隔符拆分成多个键值对字符串，每个键值对字符串通过“=”拆分成键和值，值可以为空字符串；若键值对字符串不含@“=”，则将键值对字符串作为键，将空字符串作为值
 * @discussion 如“a=3&b=4=5”，分隔符为“&”，转换结果为{(a,3),(b,4=5)}
 * @param separator 分隔符
 * @result 字典
 */
- (NSDictionary<NSString *, NSString *> *)KVedComponentsBySeparator:(NSString *)separator;

@end


/*********************************************************
 
    @class
        NSDictionary (KVedStringComponent)
 
    @abstract
        NSDictionary的键值要素扩展，封装字典与字符串间的转换
 
 *********************************************************/

@interface NSDictionary (KVedStringComponent)

/*!
 * @brief 将字典转换成字符串
 * @discussion 字典通过“=”连接键和值生成键值对字符串，再通过分隔符拼接键值对字符串，若值为空字符串，则不生成“=”，只保留键字符串
 * @discussion 如{(a,3),(b,4)}，分隔符为“&”，转换结果为“a=3&b=4”；{(a,3),(b,)}，分隔符为“&”，转换结果为“a=3&b”
 * @param separator 分隔符
 * @result 字符串
 */
- (NSString *)KVedStringBySeparator:(NSString *)separator;

@end
