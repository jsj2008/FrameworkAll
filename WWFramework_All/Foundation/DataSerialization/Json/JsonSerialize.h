//
//  JsonSerialize.h
//  FoundationProject
//
//  Created by user on 13-11-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSData (JsonSerialize)

/*********************************************************
 
    @class
        NSData (JsonSerialize)
 
    @abstract
        NSData的Json序列化扩展
 
 *********************************************************/

@interface NSData (JsonSerialize)

/*!
 * @brief 生成json根节点
 * @discussion 支持UTF-8, UTF-16LE, UTF-16BE, UTF-32LE, UTF-32BE编码，但除UTF－8外不保证一定能成功转换
 * @result json根节点
 */
- (id)jsonRootNode;

/*!
 * @brief 根据json根节点生成NSData对象
 * @param node json根节点
 * @result 生成的NSData对象，采用UTF－8编码
 */
+ (NSData *)dataWithJsonRootNode:(id)node;

@end


#pragma mark - NSString (JsonSerialize)

/*********************************************************
 
    @class
        NSString (JsonSerialize)
 
    @abstract
        NSString的Json序列化扩展，使用UTF8编码
 
    @discussion
        内部调用NSData (JsonSerialize)实现功能，若字符串非UTF8编码，可以将字符串转换成NSData对象，调用NSData (Json)实现相应功能
 
 *********************************************************/

@interface NSString (JsonSerialize)

/*!
 * @brief 生成json根节点
 * @result json根节点
 */
- (id)jsonRootNode;

/*!
 * @brief 根据json根节点生成NSString对象
 * @param node json根节点
 * @result 生成的NSString对象
 */
+ (NSString *)stringWithJsonRootNode:(id)node;

@end


#pragma mark - NSDictionary (JsonObject)

/*********************************************************
 
    @category
        NSDictionary (JsonObject)
 
    @abstract
        字典的Json对象扩展
 
 *********************************************************/

@interface NSDictionary (JsonObject)

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的对象，若为NSNull对象，返回nil
 */
- (id)jsonObjectForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的字符串，若键对应的不是字符串变量，返回nil
 */
- (NSString *)jsonStringForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的数组，若键对应的不是数组变量，返回nil
 */
- (NSArray *)jsonArrayForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的字典，若键对应的不是字典变量，返回nil
 */
- (NSDictionary *)jsonDictionaryForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的int值，若键对应的不是数字变量，返回0
 */
- (int)jsonIntForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的float值，若键对应的不是数字变量，返回0.0
 */
- (float)jsonFloatForKey:(NSString *)key;

/*!
 * @brief 字典的json键值
 * @param key 键
 * @result 键对应的double值，若键对应的不是数字变量，返回0.0
 */
- (double)jsonDoubleForKey:(NSString *)key;

@end


#pragma mark - NSMutableDictionary (JsonObject)

/*********************************************************
 
    @category
        NSMutableDictionary (JsonObject)
 
    @abstract
        字典的Json对象扩展
 
 *********************************************************/

@interface NSMutableDictionary (JsonObject)

/*!
 * @brief 设置字典的json键值
 * @param object 值，若为nil或者NSNull对象，将不会设置键值对
 * @param key 键，若长度为0，将不会设置键值对
 */
- (void)setJsonObject:(id)object forKey:(NSString *)key;

@end


#pragma mark - NSArray (JsonObject)

/*********************************************************
 
    @category
        NSArray (JsonObject)
 
    @abstract
        数组的Json对象扩展
 
 *********************************************************/

@interface NSArray (JsonObject)

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的对象，若对象为NSNull对象或索引超过数组大小，返回nil
 */
- (id)jsonObjectAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的字符串，若索引处不是字符串变量或索引超过数组大小，返回nil
 */
- (NSString *)jsonStringAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的数组，若索引处不是数组变量或索引超过数组大小，返回nil
 */
- (NSArray *)jsonArrayAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的字典，若索引处不是字典变量或索引超过数组大小，返回nil
 */
- (NSDictionary *)jsonDictionaryAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的int值，若索引处不是数字变量或索引超过数组大小，返回0
 */
- (int)jsonIntAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的float值，若索引处不是数字变量或索引超过数组大小，返回0.0
 */
- (float)jsonFloatAtIndex:(NSUInteger)index;

/*!
 * @brief 字典的json键值
 * @param index 数组中的索引
 * @result 索引处的double值，若索引处不是数字变量或索引超过数组大小，返回0。0
 */
- (double)jsonDoubleAtIndex:(NSUInteger)index;

@end
