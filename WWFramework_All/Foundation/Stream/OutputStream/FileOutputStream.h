//
//  FileOutputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "OutputStream.h"
#import "OutputStreamResetting.h"

/*********************************************************
 
    @class
        FileOutputStream
 
    @abstract
        文件输出流
 
    @discussion
        1，写入流中的数据将被写入文件中
        2，若在数据写入前文件已经存在，则新数据将被添加在原文件数据之后
        3，流重置后，文件内容将被清空
 
 *********************************************************/

@interface FileOutputStream : OutputStream <OutputStreamResetting>
{
    // 文件路径
    NSString *_filePath;
}

/*!
 * @brief 文件路径
 */
@property (nonatomic, readonly) NSString *filePath;

/*!
 * @brief 初始化
 * @param filePath 文件路径
 * @result 初始化后的对象
 */
- (id)initWithFilePath:(NSString *)filePath;

/*!
 * @brief 当前文件大小
 * @result 文件大小
 */
- (unsigned long long)fileSize;

@end
