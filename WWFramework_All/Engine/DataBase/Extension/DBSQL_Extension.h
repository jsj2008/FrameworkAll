//
//  DBSQL_Extension.h
//  FoundationProject
//
//  Created by user on 13-11-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSQL.h"
#import "DBFormat.h"

#pragma mark - DBSQL (Operation)

/*********************************************************
 
    @category
        DBSQL (Operation)
 
    @abstract
        DBSQL的扩展，负责生成数据库操作语句
 
 *********************************************************/

@interface DBSQL (Operation)

@end


#pragma mark - DBSQL (String)

/*********************************************************
 
    @category
        DBSQL (String)
 
    @abstract
        DBSQL的扩展，负责SQL语句的处理
 
 *********************************************************/

@interface DBSQL (String)

/*!
 * @brief 将一组值转换成标准SQL语句
 * @discussion 转换过程只识别NSString和NSNumber类型的变量
 * @param values 待转换的值，只有NSString或NSNumber对象可被正常转换
 * @result 转换后的SQL语句
 */
+ (NSString *)stringOfValues:(NSArray *)values;

/*!
 * @brief 将一组排序命令转换成标准SQL语句
 * @param sequencingContexts 待转换的排序命令，只能由DataBaseFieldSequencingContext对象构成
 * @result 转换后的SQL语句
 */
+ (NSString *)stringOfFieldsSequencings:(NSArray *)sequencingContexts;

@end
