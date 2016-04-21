//
//  OutputStreamResetting.h
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @protocol
        OutputStreamResetting
 
    @abstract
        输出流重置协议
 
 *********************************************************/

@protocol OutputStreamResetting <NSObject>

/*!
 * @brief 重置输出
 * @discussion 重置后，流内数据将重新从头开始写入
 */
- (void)resetOutput;

@end
