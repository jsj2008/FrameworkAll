//
//  IndexingStorage.h
//  Demo
//
//  Created by Baymax on 13-10-18.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

#pragma mark - IndexingStorage

/*********************************************************
 
    @class
        IndexingStorage
 
    @abstract
        索引式数据存储器，负责存储、读取和删除数据
 
    @discussion
        1，支持账户管理，账户不得为空
        2，IndexingStorage是一个纯基类，由子类实现具体功能
 
 *********************************************************/

@interface IndexingStorage : NSObject

/*!
 * @brief 存储数据
 * @param data 待存储的二进制数据
 * @param index 数据索引
 * @param account 数据账户
 * @result 存储是否成功
 */
- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index ofAccount:(Account *)account;

/*!
 * @brief 读取数据
 * @param index 数据索引
 * @param account 数据账户
 * @result 二进制数据
 */
- (NSData *)dataForIndex:(NSString *)index ofAccount:(Account *)account;

/*!
 * @brief 读取数据
 * @param indexes 数据索引
 * @param account 数据账户
 * @result 数据字典，键为index，值为data，且只包含能够成功获取到的数据，空数据不出现在字典中
 */
- (NSDictionary<NSString *, NSData *> *)datasForIndexes:(NSArray<NSString *> *)indexes ofAccount:(Account *)account;

/*!
 * @brief 索引范围中数据已存在的索引
 * @param indexScope 索引范围
 * @param account 数据账户
 * @result 数据已存在的索引
 */
- (NSArray<NSString *> *)existingDataIndexesInIndexScope:(NSArray<NSString *> *)indexScope ofAccount:(Account *)account;

/*!
 * @brief 清理数据
 * @param indexes 数据索引
 * @param account 数据账户
 */
- (void)cleanDatasForIndexes:(NSArray<NSString *> *)indexes ofAccount:(Account *)account;

/*!
 * @brief 清理数据
 * @param account 数据账户
 */
- (void)cleanDatasOfAccount:(Account *)account;

/*!
 * @brief 清理数据
 */
- (void)cleanAllDatas;

@end


#pragma mark - MemoryingIndexingStorage

/*********************************************************
 
    @class
        MemoryingIndexingStorage
 
    @abstract
        内存型索引式数据存储器，所有数据存放于内存中
 
 *********************************************************/

@interface MemoryingIndexingStorage : IndexingStorage
{
    // 内存数据
    NSMutableDictionary *_datas;
    
    // 同步队列
    dispatch_queue_t _syncQueue;
}

@end


#pragma mark - FilingIndexingStorage

/*********************************************************
 
    @class
        FilingIndexingStorageMode
 
    @abstract
        文件型索引式数据存储器的存储模式
 
 *********************************************************/

typedef enum
{
    FilingIndexingStorageMode_Common  = 1,   // 普通模式
    FilingIndexingStorageMode_Speed   = 2,   // 极速模式，在批量读取数据时做了优化
    FilingIndexingStorageMode_Default = FilingIndexingStorageMode_Common
}FilingIndexingStorageMode;


/*********************************************************
 
    @class
        FilingIndexingStorage
 
    @abstract
        文件型索引式数据存储器，所有数据存放于文件中
 
    @discussion
        文件采用根目录-账户目录-索引三级层级存储，对于账户为空的情况，跳过账户目录，直接在根目录下按照索引存储文件
 
 *********************************************************/

@interface FilingIndexingStorage : IndexingStorage
{
    // 文件管理器
    NSFileManager *_fm;
    
    // 数据根目录
    NSString *_rootDirectory;
    
    // 同步队列
    dispatch_queue_t _syncQueue;
}

/*!
 * @brief 运行模式，默认为普通模式
 */
@property (nonatomic) FilingIndexingStorageMode mode;

/*!
 * @brief 初始化
 * @param rootDirectory 文件根目录
 * @result 初始化后的对象
 */
- (id)initWithRootDirectory:(NSString *)rootDirectory;

/*!
 * @brief 数据所在的文件路径
 * @param account 数据账户
 * @result 文件路径
 */
- (NSString *)contentPathOfAccount:(Account *)account;

/*!
 * @brief 数据所在的文件路径
 * @param index 数据索引
 * @param account 数据账户
 * @result 文件路径
 */
- (NSString *)contentPathForIndex:(NSString *)index ofAccount:(Account *)account;

/*!
 * @brief 存储数据
 * @param path 待存储的数据路径
 * @param index 数据索引
 * @param account 数据账户
 * @result 存储是否成功
 */
- (BOOL)saveDataWithPath:(NSString *)path forIndex:(NSString *)index ofAccount:(Account *)account;

/*!
 * @brief 当前数据大小
 * @result 数据大小
 */
- (long long)currentDataSize;

@end
