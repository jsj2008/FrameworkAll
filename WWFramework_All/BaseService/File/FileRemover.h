//
//  FileRemover.h
//  Demo
//
//  Created by Baymax on 13-10-16.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        FileRemover
 
    @abstract
        文件删除器，用于快速删除文件
 
 *********************************************************/

@interface FileRemover : NSObject

/*!
 * @brief 存放临时文件的根目录
 */
@property (nonatomic, copy) NSString *rootDirectory;

/*!
 * @brief 单例
 */
+ (FileRemover *)sharedInstance;

/*!
 * @brief 删除文件
 * @param items 待删除的文件
 */
- (void)removeItems:(NSArray<NSString *> *)items;

/*!
 * @brief 清理临时文件
 */
- (void)clean;

@end
