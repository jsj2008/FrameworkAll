//
//  EPub2_Package.h
//  FoundationProject
//
//  Created by ww on 13-12-15.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPub2_OCF.h"
#import "EPub2_OPF.h"
#import "EPub2_NCX.h"


/*!
 * EPub2族
 * 版本号0.0
 *
 * EPub2族遵循EPUB2.0.1标准处理EPub档案，EPUB2.0.1标准详情可查询http://idpf.org
*/


/*********************************************************
 
    @class
        EPub2_Package
 
    @abstract
        EPub文档数据包，承载文档所有信息
 
 *********************************************************/

@interface EPub2_Package : NSObject

/*!
 * @brief EPub文档的内容文件存放目录（相对目录）
 */
@property (nonatomic, copy) NSString *ocfDirectory;

/*!
 * @brief EPub文档的元信息
 */
@property (nonatomic) EPub2_OCF *ocf;

/*!
 * @brief EPub文档的包裹信息
 */
@property (nonatomic) EPub2_OPF *opf;

/*!
 * @brief EPub文档的目录信息
 */
@property (nonatomic) EPub2_NCX *ncx;

/*!
 * @brief 初始化
 * @discussion 初始化过程中，将解析部分必须的文件，生成文档的基本信息
 * @param directory EPub文档所在的根目录
 * @result 初始化后的对象
 */
- (id)initWithEPubDirectory:(NSString *)directory;

@end
