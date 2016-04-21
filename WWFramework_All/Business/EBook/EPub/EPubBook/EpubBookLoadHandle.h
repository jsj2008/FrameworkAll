//
//  EpubBookLoadHandle.h
//  FoundationProject
//
//  Created by Game_Netease on 14-1-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPubBookContainerHandle.h"

/*********************************************************
 
    @class
        EpubBookLoadHandle
 
    @abstract
        EPub书籍加载句柄，用于加载书籍信息
 
 *********************************************************/

@interface EpubBookLoadHandle : NSObject

/*!
 * @brief 书籍id
 */
@property (nonatomic, copy) NSString *bookId;

/*!
 * @brief 加载书籍内容
 */
- (void)loadBook;

/*!
 * @brief 指定id的书籍信息
 * @result 书籍包裹句柄，承载着完成的书籍信息
 */
- (EPubBookContainerHandle *)bookContainer;

@end
