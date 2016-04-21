//
//  AHMessageOutputStreamOutput.h
//  Application
//
//  Created by WW on 14-4-23.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHMessageHeader.h"

/*********************************************************
 
    @class
        AHMessageOutputStreamOutput
 
    @abstract
        HTTP报文传输的输出流的输出对象（报文数据的内容片断）
 
 *********************************************************/

@interface AHMessageTransferParsingStreamOutput : NSObject

@end


/*********************************************************
 
    @class
        AHMessageOutputStreamHeaderOutput
 
    @abstract
        HTTP报文传输的输出流的报文头对象
 
 *********************************************************/

@interface AHMessageTransferParsingStreamHeaderOutput : AHMessageTransferParsingStreamOutput

/*!
 * @brief 报文头
 */
@property (nonatomic) AHMessageHeader *header;

@end


/*********************************************************
 
    @class
        AHMessageOutputStreamBodyDataOutput
 
    @abstract
        HTTP报文传输的输出流的Body数据内容片断对象（部分Body内容）
 
 *********************************************************/

@interface AHMessageTransferParsingStreamBodyDataOutput : AHMessageTransferParsingStreamOutput

/*!
 * @brief Body内容片断
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        AHMessageOutputStreamBodyTrailerOutput
 
    @abstract
        HTTP报文传输的输出流的Body拖挂对象
 
 *********************************************************/

@interface AHMessageTransferParsingStreamBodyTrailerOutput : AHMessageTransferParsingStreamOutput

/*!
 * @brief 拖挂
 */
@property (nonatomic) NSDictionary *trailer;

@end


/*********************************************************
 
    @class
        AHMessageOutputStreamFinishingOutput
 
    @abstract
        HTTP报文传输的输出流的报文结束标志对象
 
 *********************************************************/

@interface AHMessageTransferParsingStreamFinishingOutput : AHMessageTransferParsingStreamOutput

@end
