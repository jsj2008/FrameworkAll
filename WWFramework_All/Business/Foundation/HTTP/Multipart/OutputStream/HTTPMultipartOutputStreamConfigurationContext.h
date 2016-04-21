//
//  HTTPMultipartOutputStreamConfigurationContext.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-20.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPMultipartOutputStreamConfigurationContext
 
    @abstract
        HTTPMultipartBodyOutputStream的配置项
 
 *********************************************************/

@interface HTTPMultipartOutputStreamConfigurationContext : NSObject

/*!
 * @brief 允许的最大表单片段首部长度（包含分隔符）；默认4K字节
 */
@property (nonatomic) NSUInteger maxFragmentHeaderFieldsSize;

/*!
 * @brief 表单片段保存形式的数据大小限制，当数据长度大于该值时将以文件形式保存，反之以内存形式保存；默认1M字节
 */
@property (nonatomic) NSUInteger fragmentSizeLimitToFile;

/*!
 * @brief 用于保存表单数据的文件目录；默认为文件目录中心指定的存放目录
 */
@property (nonatomic, copy) NSString *savingDirectory;

/*!
 * @brief 有效的用于保存数据的文件路径
 * @result 文件路径
 */
- (NSString *)validFilePathForSaving;

@end
