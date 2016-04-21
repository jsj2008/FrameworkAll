//
//  DataBaseUnit.h
//  Demo
//
//  Created by Baymax on 13-10-13.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandle.h"

/*********************************************************
 
    @class
        DataBaseUnit
 
    @abstract
        数据库文件对象，管理文件内数据表格等数据对象
 
    @discussion
        一些数据库对象初始化和启动过程中会进行耗时操作，堵塞当前线程，应当在－start方法创建数据表和其他数据库对象。
 
 *********************************************************/

@interface DataBaseUnit : NSObject

/*!
 * @brief 数据库文件句柄
 */
@property (nonatomic) DBHandle *handle;

/*!
 * @brief 初始化
 * @param filePath 数据库文件路径
 * @result 初始化后的对象
 */
- (id)initWithFilePath:(NSString *)filePath;

/*!
 * @brief 启动数据库
 * @result 启动是否成功
 */
- (BOOL)start;

@end
