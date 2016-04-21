//
//  AHServerCode.h
//  Application
//
//  Created by WW on 14-3-14.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        AHServerCode
 
    @abstract
        HTTP服务器端状态码
 
 *********************************************************/

typedef enum
{
    AHServerCode_Unknown                                 = -1,  // 未知错误
    
    AHServerCode_OK                                      = 0,   // 成功
    
    AHServerCode_ConnectionStream_InputClosedByClient    = 21,  // 客户端关闭连接的输入流
    AHServerCode_ConnectionStream_InputClosedByServer    = 22,  // 服务端关闭连接的输入流
    AHServerCode_ConnectionStream_OutputClosedByClient   = 23,  // 客户端关闭连接的输出流
    AHServerCode_ConnectionStream_OutputClosedByServer   = 24,  // 服务端关闭连接的输出流
    
    AHServerCode_Request_UnrecognizedHeader              = 31,  // 无法识别的首部（首部过长）
    AHServerCode_Request_UnsupportedTransferringEncoding = 32,  // 不支持的传输编码，只支持chunked传输
    AHServerCode_Request_UnsupportedContentEncoding      = 33,  // 不支持的内容编码，只支持identity，deflate和gzip编码
    AHServerCode_Request_UnknownContentLength            = 34,  // 未知的内容长度（无法得知内容何时结束）
    AHServerCode_Request_DecompressError                 = 35,  // 解压出错
    AHServerCode_Request_ChunkParseError                 = 36,  // 解析内容chunk块出错
    AHServerCode_Request_UnrecognizedTrailer             = 37,  // 无法识别的拖挂
    
    AHServerCode_Response_InvalidResponse                = 41,  // 无效的响应（缺失响应必须的信息）
    AHServerCode_Response_CompressError                  = 42   // 压缩出错
}AHServerCode;
