//
//  HTTPResponseContentParse.h
//  FoundationProject
//
//  Created by user on 13-11-28.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLElement.h"
#import "XMLSprite.h"

#pragma mark - HTTPResponseContentParser

/*********************************************************
 
    @class
        HTTPResponseContentParser
 
    @abstract
        HTTP响应数据解析器
 
    @discussion
        1，解析器提供了判断响应数据是否有效的接口，请在判断数据有效的前提下从解析器获取数据
        2，在初始化方法中完成了数据的解析工作，当数据量庞大时，初始化方法可能占用较多时间；判断数据有效性和获取解析后数据的接口仅仅是读出解析后数据的操作，是较快的操作
 
 *********************************************************/

@interface HTTPResponseContentParser : NSObject
{
    // 内容是否可用
    BOOL _isContentValid;
    
    // 响应首部
    NSHTTPURLResponse *_response;
    
    // 内容数据
    NSData *_content;
}

/*!
 * @brief 初始化
 * @param response 响应首部
 * @param content 响应数据
 * @result 初始化后的对象
 */
- (id)initWithResponse:(NSHTTPURLResponse *)response content:(NSData *)content;

/*!
 * @brief 响应数据是否有效，仅判断数据是否可被解析，并不判断解析数据是否正确
 * @result 响应数据是否有效
 */
- (BOOL)isContentValid;

@end


#pragma mark - HTTPResponseJsonContentParser

/*********************************************************
 
    @class
        HTTPResponseJsonContentParser
 
    @abstract
        HTTPResponseDataParser的子类，封装json数据的解析
 
    @discussion
        只支持UTF8，UTF16和UTF32三类编码，若响应首部未指定编码方式，默认使用UTF8编码
 
 *********************************************************/

@interface HTTPResponseJsonContentParser : HTTPResponseContentParser
{
    // 解析得到的根节点
    id _rootNode;
}

/*!
 * @brief 解析得到的根节点
 * @result 根节点
 */
- (id)rootNode;

@end


#pragma mark - HTTPResponseXMLContentElementParser

/*********************************************************
 
    @class
        HTTPResponseXMLContentElementParser
 
    @abstract
        HTTPResponseDataParser的子类，封装XML数据的解析
 
    @discussion
        若响应首部未指定编码方式，默认使用UTF8编码
 
 *********************************************************/

@interface HTTPResponseXMLContentElementParser : HTTPResponseContentParser
{
    // 解析得到的文档节点
    XMLDocumentElement *_documentElement;
}

/*!
 * @brief 解析得到的文档节点
 * @result 文档节点
 */
- (XMLDocumentElement *)documentElement;

@end


#pragma mark - HTTPResponseXMLContentSpriteParser

/*********************************************************
 
    @class
        HTTPResponseXMLContentSpriteParser
 
    @abstract
        HTTPResponseDataParser的子类，封装XML数据的解析
 
    @discussion
        若响应首部未指定编码方式，默认使用UTF8编码
 
 *********************************************************/

@interface HTTPResponseXMLContentSpriteParser : HTTPResponseContentParser
{
    // 解析得到的文档节点
    XMLDocumentSprite *_documentSprite;
}

/*!
 * @brief 解析得到的文档节点
 * @result 文档节点
 */
- (XMLDocumentSprite *)documentSprite;

@end
