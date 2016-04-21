//
//  HTTPMultipartTruncatingStream.h
//  FoundationProject
//
//  Created by Baymax on 14-1-18.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "BufferOutputStream.h"

@class HTTPMultipartBodyTruncatedFragmentData;


/*********************************************************
 
    @enum
        HTTPMultipartBodyTruncateStatus
 
    @abstract
        HTTP多表单数据截断流状态
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, HTTPMultipartBodyTruncateStatus)
{
    HTTPMultipartBodyTruncateStatus_Start = 1,     // 正在寻找起始标志
    HTTPMultipartBodyTruncateStatus_Fragment = 2,  // 正在截断表单片段
    HTTPMultipartBodyTruncateStatus_End = 3,       // 截断已经结束
};


/*********************************************************
 
    @class
        HTTPMultipartBodyTruncatingStream
 
    @abstract
        HTTP多表单数据截断流
 
    @discussion
        1，HTTPMultipartBodyTruncatingStream用于将多表单数据按照片段格式流式地截断成片段数据包，每次进行截断操作，流内会将当前所有可用数据组成连续的数据包，因此并非所有的数据包都是完整的片段数据
        2，在写入数据的时候进行截断操作，截断数据时，已经除去各类分隔符，截断的小数据包可以按照实际情况拼接出完整的片段
        3，当完整截断多表单数据时，进入结束状态，此时再写入数据，新数据将不会进行截断操作
 
 *********************************************************/

@interface HTTPMultipartBodyTruncatingStream : BufferOutputStream

/*!
 * @brief 初始化
 * @param boundary 分隔符
 * @result 初始化后的对象
 */
- (id)initWithBoundary:(NSString *)boundary;

/*!
 * @brief 截断状态
 * @result 截断状态
 */
- (HTTPMultipartBodyTruncateStatus)truncatingStatus;

/*!
 * @brief 被截断的数据包
 * @result 被截断的数据包，由HTTPMultipartBodyTruncatedFragmentData对象构成
 */
- (NSArray<HTTPMultipartBodyTruncatedFragmentData *> *)truncatedFragmentDatas;

/*!
 * @brief 清理内部截断的数据包
 */
- (void)cleanTruncatedFragmentDatas;

/*!
 * @brief 未截断的流数据
 * @result 未截断的流数据
 */
- (NSData *)untruncatedData;

@end


/*********************************************************
 
    @class
        HTTPMultipartBodyTruncatedFragmentData
 
    @abstract
        HTTP多表单数据截断流截断得到的数据包
 
 *********************************************************/

@interface HTTPMultipartBodyTruncatedFragmentData : NSObject

/*!
 * @brief 当前片段是否截断完毕
 */
@property (nonatomic) BOOL isComplete;

/*!
 * @brief 被截断的数据
 */
@property (nonatomic) NSData *data;

@end
