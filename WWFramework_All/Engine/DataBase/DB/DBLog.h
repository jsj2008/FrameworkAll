//
//  DBLog.h
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DBLogOperation)(NSString *);

/********************** DBLog **********************
 
    @class
        DBLog：数据库日志对象。
 
    @abstract
        数据库的数据对象通过DBLog打印日志数据。
 
    @discussion
        1. DBLog是线程安全的
        2. DBLog支持自定义打印，未指定自定义打印方法时采用NSLog方式打印
 
 ********************** DBLog **********************/

@interface DBLog : NSObject
{
    // 日志开启状态
    BOOL _open;
}

/*!
 * @brief 自定义日志操作
 */
@property (nonatomic, copy) DBLogOperation customLogOperation;

/*!
 * @brief 单例
 */
+ (DBLog *)sharedInstance;

/*!
 * @brief 开启日志
 */
- (void)openLog;

/*!
 * @brief 关闭日志
 */
- (void)closeLog;

/*!
 * @brief 打印日志数据，仅限于字符串
 * @param format 数据字符串，不能为nil
 */
- (void)logStringWithFormat:(NSString *)format, ...;

@end
