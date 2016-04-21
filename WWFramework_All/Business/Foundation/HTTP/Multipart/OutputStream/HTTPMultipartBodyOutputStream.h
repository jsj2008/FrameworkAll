//
//  HTTPMultipartBodyOutputStream.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "BufferOutputStream.h"
#import "HTTPMultipartBody.h"
#import "HTTPMultipartOutputStreamConfigurationContext.h"

/*********************************************************
 
    @class
        HTTPMultipartBodyOutputStream
 
    @abstract
        HTTP专用的多表单提交方式的主体数据输出流
 
    @discussion
        HTTPMultipartBodyOutputStream允许无限写入数据，写入数据的同时对数据进行解析，当解析出完整的多表单数据后停止解析，多余的数据（包括之后写入的数据）将存放在缓冲区中
 
 *********************************************************/

@interface HTTPMultipartBodyOutputStream : OverFlowableOutputStream

/*!
 * @brief 配置项上下文
 */
@property (nonatomic) HTTPMultipartOutputStreamConfigurationContext *configurationContext;

/*!
 * @brief 初始化
 * @param boundary 分隔符，不能为空
 * @result 初始化后的对象
 */
- (id)initWithBoundary:(NSString *)boundary;

/*!
 * @brief 解析出的多表单数据
 * @result 多表单数据，解析未完成时返回nil
 */
- (HTTPMultipartBody *)multipartBody;

@end
