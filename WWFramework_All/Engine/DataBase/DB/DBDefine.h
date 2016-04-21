//
//  DBDefine.h
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import <Foundation/Foundation.h>

/********************** DBValueType **********************
 
    @enum
        DBValueType：数据库支持的数据类型。
 
    @abstract
        数据库内部使用的标准数据类型描述

 ********************** DBValueType **********************/

typedef enum
{
    DBValueType_Int         = 1,
    DBValueType_LongLong    = 2,
    DBValueType_Double      = 3,
    DBValueType_Text        = 4,
    DBValueType_Blob        = 5,
    DBValueType_NULL        = 6
}DBValueType;


/********************** DBTableField **********************
 
    @class
        DBTableField：数据列。
 
    @abstract
        DBTableField是数据列的完整表述，是数据库中数据表格的标准的列描述。
 
    @discussion
        DBTableField是在DB中使用的列的唯一表示方法，在DB开头的对象中使用到的field和fields参数，无特殊说明，均指DBTableField对象或由其构成的数组
 
 ********************** DBTableField **********************/

@interface DBTableField : NSObject

/*!
 * @brief 列名
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 列数据类型
 */
@property (nonatomic) DBValueType type;

/*!
 * @brief 是否主键（之一）
 */
@property (nonatomic) BOOL primary;

/*!
 * @brief 初始化
 * @param name 列名
 * @param type 列数据类型
 * @param primary 是否主键（之一）
 * @result 初始化后的对象
 */
- (id)initWithName:(NSString *)name type:(DBValueType)type primary:(BOOL)primary;

@end
