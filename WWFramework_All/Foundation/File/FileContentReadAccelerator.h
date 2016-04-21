//
//  FileContentReadAccelerator.h
//  Demo
//
//  Created by Baymax on 13-10-21.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        FileContentReadAccelerator
 
    @abstract
        文件数据读取加速器，用于快速批量读取文件内容
 
 *********************************************************/

@interface FileContentReadAccelerator : NSObject

/*!
 * @brief 采用极速/非极速方式批量读取文件内容
 * @param filePaths 文件路径
 * @param speeding 是否采用极速方式
 * @result 获取到的数据字典，键为filePath，值为data（文件二进制内容）
 */
- (NSDictionary<NSString *, NSData *> *)contentsOfFiles:(NSArray *)filePaths speeding:(BOOL)speeding;

@end
