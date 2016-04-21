//
//  FileInputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-15.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "InputStream.h"
#import "InputStreamResetting.h"

/*********************************************************
 
    @class
        FileInputStream
 
    @abstract
        文件输入流
 
 *********************************************************/

@interface FileInputStream : InputStream <InputStreamResetting>
{
    // 文件路径
    NSString *_filePath;
}

/*!
 * @brief 文件起始位置
 */
@property (nonatomic) unsigned long long startLocation;

/*!
 * @brief 文件结束位置
 * @discussion 0表征文件尾
 */
@property (nonatomic) unsigned long long endLocation;

/*!
 * @brief 初始化
 * @param filePath 文件路径
 * @result 初始化后的对象
 */
- (id)initWithFilePath:(NSString *)filePath;

@end
