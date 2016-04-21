//
//  ArySystem.h
//  FoundationProject
//
//  Created by WW on 14-1-27.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (ArySystem)
 
    @abstract
        NSString的扩展，处理字符串和不同进制数字之间的转换
 
 *********************************************************/

@interface NSString (ArySystem)

/*!
 * @brief 将字符串按任意进制转换成数字
 * @discussion 字符串从第一个可识别的字符开始转换，遇到不可识别的字符停止
 * @discussion 0进制是一个比较特殊的进制，默认按照10进制转换，但遇到如’0x’前置字符则会使用16进制做转换、遇到’0’前置字符而不是’0x’的时候会使用8进制做转换
 * @param ary 进制，取值范围为0，2-36。不同取值范围可识别的字符不同，从0，1至0，...，9，a，...，z
 * @result 字符串对应的数字
 */
- (long long)numberValueWithAry:(int)ary;

/*!
 * @brief 将字符串按2进制转换成数字
 * @result 字符串对应的数字
 */
- (long long)binaryNumberValue;

/*!
 * @brief 将字符串按8进制转换成数字
 * @result 字符串对应的数字
 */
- (long long)octalNumberValue;

/*!
 * @brief 将字符串按16进制转换成数字
 * @result 字符串对应的数字
 */
- (long long)hexNumberValue;

/*!
 * @brief 将字符串按0进制转换成数字
 * @result 字符串对应的数字
 */
- (long long)autoNumberValue;

@end
