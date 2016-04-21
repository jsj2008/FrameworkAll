//
//  NSCoder+DataedEncoding.h
//  Application
//
//  Created by NetEase on 14-8-20.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSCoder (DataedEncoding)
 
    @abstract
        NSCoder的扩展，用于编码有数据的节点
 
    @discussion
        使用本扩展中的方法编码对象，将检查数据的可用性，只有当数据为非系统默认数据时（非nil，非NULL，非0，非0.0，YES等）进行编码，以减少编码数据量，加快编码速度；由于系统默认数据在decode时可再生，因此省略这些数据的编码不影响数据可用性。
 
 *********************************************************/

@interface NSCoder (DataedEncoding)

/*!
 * @brief 编码对象
 * @discussion 当被编码对象和key均非nil时进行编码
 */
- (void)dataedEncodeObject:(id)objv forKey:(NSString *)key;

/*!
 * @brief 编码对象
 * @discussion 当被编码对象和key均非nil时进行编码
 */
- (void)dataedEncodeConditionalObject:(id)objv forKey:(NSString *)key;

/*!
 * @brief 编码布尔量
 * @discussion 当布尔量为YES和key非nil时进行编码
 */
- (void)dataedEncodeBool:(BOOL)boolv forKey:(NSString *)key;

/*!
 * @brief 编码int量
 * @discussion 当int量!=0和key非nil时进行编码
 */
- (void)dataedEncodeInt:(int)intv forKey:(NSString *)key;	// native int

/*!
 * @brief 编码NSInteger量
 * @discussion 当NSInteger量!=0和key非nil时进行编码
 */
- (void)dataedEncodeInteger:(NSInteger)intv forKey:(NSString *)key;

/*!
 * @brief 编码int32_t量
 * @discussion 当int32_t量!=0和key非nil时进行编码
 */
- (void)dataedEncodeInt32:(int32_t)intv forKey:(NSString *)key;

/*!
 * @brief 编码int64_t量
 * @discussion 当int64_t量!=0和key非nil时进行编码
 */
- (void)dataedEncodeInt64:(int64_t)intv forKey:(NSString *)key;

/*!
 * @brief 编码float量
 * @discussion 当float量!=0.0和key非nil时进行编码
 */
- (void)dataedEncodeFloat:(float)realv forKey:(NSString *)key;

/*!
 * @brief 编码double量
 * @discussion 当double量!=0.0和key非nil时进行编码
 */
- (void)dataedEncodeDouble:(double)realv forKey:(NSString *)key;

/*!
 * @brief 编码字节流
 * @discussion 当字节流存在，编码长度存在和key非nil时进行编码
 */
- (void)dataedEncodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key;

@end
