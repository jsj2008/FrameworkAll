//
//  NSString+CharacterHandle.h
//  Application
//
//  Created by Baymax on 14-2-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (CharacterHandle)
 
    @abstract
        NSString的字符处理扩展
 
 *********************************************************/

@interface NSString (CharacterHandle)

/*!
 * @brief 删除前后缀字符串后的字符串
 * @discussion 只有标记字符串同时为前后缀，且前后缀的标记字符串无交叉重复时才生效
 * @discussion 即：对于字符串@"ababab"，指定标记为@"abab"，删除操作将无效，因为此时前缀和后缀@"abab"拥有交叉字符@"ab"
 * @result 处理后的字符串
 */
- (NSString *)stringByDeletingBothPrefixAndSuffixMarks:(NSString *)mark;

/*!
 * @brief 删除串首和串尾的双引号后的字符串
 * @discussion 必须串首和串尾同时包含双引号时才生效
 * @result 处理后的字符串
 */
- (NSString *)stringByDeletingBothPrefixAndSuffixQuotationMarks;

@end
