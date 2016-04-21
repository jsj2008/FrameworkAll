//
//  HTTPMultipartBody.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-16.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InputStream, GroupedInputStream, HTTPMultipartFragment;


#pragma mark - HTTPMultipartBody

/*********************************************************
 
    @class
        HTTPMultipartBody
 
    @abstract
        HTTP专用的多表单主体数据
 
 *********************************************************/

@interface HTTPMultipartBody : NSObject

/*!
 * @brief 分隔符
 */
@property (nonatomic, readonly) NSString *boundary;

/*!
 * @brief 表单片段
 */
@property (nonatomic, readonly) NSArray<HTTPMultipartFragment *> *fragments;

/*!
 * @brief 初始化
 * @param boundary 分隔符，不能为空
 * @param fragments 表单片段，由HTTPMultipartFragment对象构成
 * @result 初始化后的对象
 */
- (id)initWithBoundary:(NSString *)boundary fragments:(NSArray<HTTPMultipartFragment *> *)fragments;

/*!
 * @brief 序列化数据，将对象的所有数据转换成字节数据
 * @discussion 序列化过程中会根据HTTP规范进行数据拼装
 * @result 序列化后的数据
 */
- (NSData *)serializedData;

/*!
 * @brief 数据流式化，将对象的所有数据转换成输入型数据流
 * @result 数据流
 */
- (GroupedInputStream *)stream;

@end


#pragma mark - HTTPMultipartFragment

/*********************************************************
 
    @class
        HTTPMultipartFragment
 
    @abstract
        HTTP专用的表单片段
 
    @discussion
        按照规范，表单片段必须包含一个Content-Disposition首部；HTTPMultipartFragment本身可以不配置该首部，但在生成数据时，会自动为其添加“Content-Disposition＝”首部
 
 *********************************************************/

@interface HTTPMultipartFragment : NSObject

/*!
 * @brief 片段内首部
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *headerFields;

/*!
 * @brief 片段数据（不含片段内首部）
 * @result 片段数据
 */
- (NSData *)data;

/*!
 * @brief 片段数据（不含片段内首部）转换成片段流
 * @result 片段流
 */
- (InputStream *)dataStream;

@end


#pragma mark - HTTPMultipartDataFragment

/*********************************************************
 
    @class
        HTTPMultipartDataFragment
 
    @abstract
        HTTP专用的字节型表单片段
 
 *********************************************************/

@interface HTTPMultipartDataFragment : HTTPMultipartFragment

/*!
 * @brief 初始化
 * @param data 字节数据
 * @result 初始化后的对象
 */
- (id)initWithData:(NSData *)data;

@end


#pragma mark - HTTPMultipartFileFragment

/*********************************************************
 
    @class
        HTTPMultipartFileFragment
 
    @abstract
        HTTP专用的文件型表单片段
 
 *********************************************************/

@interface HTTPMultipartFileFragment : HTTPMultipartFragment

/*!
 * @brief 文件路径
 */
@property (nonatomic, readonly) NSString *filePath;

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


#pragma mark - HTTPMultipartBodyFragment

/*********************************************************
 
    @class
        HTTPMultipartBodyFragment
 
    @abstract
        HTTP专用的多表单型表单片段
 
 *********************************************************/

@interface HTTPMultipartBodyFragment : HTTPMultipartFragment

/*!
 * @brief 片段
 */
@property (nonatomic, readonly) HTTPMultipartBody *multipartBody;

/*!
 * @brief 初始化
 * @param fragment 表单片段
 * @result 初始化后的对象
 */
- (id)initWithMultipartBody:(HTTPMultipartBody *)multipartBody;

@end
