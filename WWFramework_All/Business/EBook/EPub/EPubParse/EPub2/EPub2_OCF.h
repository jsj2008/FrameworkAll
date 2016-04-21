//
//  EPub2_METAINF.h
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPubXML.h"


/*!
 * EPub2_OCF族
 * 版本号0.0
 *
 * EPub2_OCF族遵循OCF2.0.1标准
 */


#pragma mark - EPub2_OCF

@class EPub2_OCF_Container;

/*********************************************************
 
    @class
        EPub2_OCF
 
    @abstract
        EPub2的容纳信息
 
    @discussion
        这里只处理container.xml文件中的信息，其它可选的xml文件（manifest等）信息被忽略
 
 *********************************************************/

@interface EPub2_OCF : NSObject

/*!
 * @brief 容器信息
 */
@property (nonatomic) EPub2_OCF_Container *container;

@end


#pragma mark - EPub2_OCF_Container

/*********************************************************
 
    @class
        EPub2_OCF_Container
 
    @abstract
        EPub2的容器信息
 
 *********************************************************/

@interface EPub2_OCF_Container : NSObject <EPubXMLParsing>

/*!
 * @brief 版本号
 */
@property (nonatomic, copy) NSString *version;

/*!
 * @brief 根文件数组
 * @discussion 由EPub2_OCF_Container_RootFile对象构成
 */
@property (nonatomic) NSArray *rootFiles;

@end


#pragma mark - EPub2_OCF_Container_RootFile

/*********************************************************
 
    @class
        EPub2_OCF_Container_RootFile
 
    @abstract
        EPub2容器信息的根文件
 
 *********************************************************/

@interface EPub2_OCF_Container_RootFile : NSObject <EPubXMLParsing>

/*!
 * @brief 路径
 */
@property (nonatomic, copy) NSString *fullPath;

/*!
 * @brief 媒体类型
 */
@property (nonatomic, copy) NSString *mediaType;

@end
