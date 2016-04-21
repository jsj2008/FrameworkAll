//
//  HTTPMultipartFragmentEntityOutputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-20.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "BufferOutputStream.h"
#import "HTTPMultipartBody.h"
#import "HTTPMultipartOutputStreamConfigurationContext.h"

#pragma mark - HTTPMultipartFragmentEntityOutputStream

/*********************************************************
 
    @class
        HTTPMultipartFragmentEntityOutputStream
 
    @abstract
        HTTP表单实体数据输出流
 
    @discussion
        在向流内写入数据的同时，对写入的数据按照HTTP规范解析表单实体数据
 
 *********************************************************/

@interface HTTPMultipartFragmentEntityOutputStream : OutputStream

/*!
 * @brief 配置上下文
 */
@property (nonatomic) HTTPMultipartOutputStreamConfigurationContext *configurationContext;

/*!
 * @brief 解析出的表单片段数据
 * @result 表单片段数据，解析未完成时返回nil
 */
- (HTTPMultipartFragment *)fragment;

@end


#pragma mark - HTTPMultipartFragmentHeaderFieldOutputStream

/*********************************************************
 
    @class
        HTTPMultipartFragmentHeaderFieldOutputStream
 
    @abstract
        HTTP表单首部数据输出流
 
    @discussion
        在向流内写入数据的同时，对写入的数据按照HTTP规范解析表单首部数据
 
 *********************************************************/

@interface HTTPMultipartFragmentHeaderFieldOutputStream : OverFlowableOutputStream

/*!
 * @brief 最大首部流数据长度
 */
@property (nonatomic) NSUInteger maxHeaderFieldStreamSize;

/*!
 * @brief 解析到的首部
 * @result 解析到的首部
 */
- (NSDictionary<NSString *, NSString *> *)allHeaderFields;

@end


#pragma mark - HTTPMultipartFragmentContentOutputStream

@class HTTPMultipartFragmentContentOutput;

/*********************************************************
 
    @class
        HTTPMultipartFragmentContentOutputStream
 
    @abstract
        HTTP表单内容数据输出流
 
    @discussion
        1，所有写入的数据都将作为有效的内容数据被存储
        2，为防止数据过大导致内存紧张，允许进行设置，在数据过大时使用文件形式保存数据
 
 *********************************************************/

@interface HTTPMultipartFragmentContentOutputStream : OutputStream

/*!
 * @brief 配置上下文
 */
@property (nonatomic) HTTPMultipartOutputStreamConfigurationContext *configurationContext;

/*!
 * @brief 内部数据输出流，仅供子类使用
 */
@property (nonatomic) OutputStream *outputStream;

/*!
 * @brief 将写入的数据封装成输出对象
 * @result 输出对象
 */
- (HTTPMultipartFragmentContentOutput *)output;

@end


/*********************************************************
 
    @class
        HTTPMultipartFragmentMultipartedContentOutputStream
 
    @abstract
        内容为多表单数据的HTTP表单内容数据输出流
 
 *********************************************************/

@interface HTTPMultipartFragmentMultipartedContentOutputStream : HTTPMultipartFragmentContentOutputStream

/*!
 * @brief 初始化
 * @param boundary 分隔符
 * @result 初始化后的对象
 */
- (id)initWithBoundary:(NSString *)boundary;

@end


#pragma mark - HTTPMultipartFragmentContentOutput

/*********************************************************
 
    @class
        HTTPMultipartFragmentContentOutput
 
    @abstract
        HTTP表单内容数据
 
 *********************************************************/

@interface HTTPMultipartFragmentContentOutput : NSObject

@end


/*********************************************************
 
    @class
        HTTPMultipartFragmentDataContentOutput
 
    @abstract
        字节型HTTP表单内容数据
 
 *********************************************************/

@interface HTTPMultipartFragmentDataContentOutput : HTTPMultipartFragmentContentOutput

/*!
 * @brief 字节数据
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        HTTPMultipartFragmentFileContentOutput
 
    @abstract
        文件型HTTP表单内容数据
 
 *********************************************************/

@interface HTTPMultipartFragmentFileContentOutput : HTTPMultipartFragmentContentOutput

/*!
 * @brief 文件路径
 */
@property (nonatomic, copy) NSString *filePath;

@end


/*********************************************************
 
    @class
        HTTPMultipartFragmentMultipartedContentOutput
 
    abstract
        多表单型HTTP表单内容数据
 
 *********************************************************/

@interface HTTPMultipartFragmentMultipartedContentOutput : HTTPMultipartFragmentContentOutput

/*!
 * @brief 多表单数据
 */
@property (nonatomic) HTTPMultipartBody *multipartBody;

@end
