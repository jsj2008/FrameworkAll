//
//  InputStreamResetting.h
//  FoundationProject
//
//  Created by Baymax on 14-2-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @protocol
        InputStreamResetting
 
    @abstract
        输入流重置协议
 
 *********************************************************/

@protocol InputStreamResetting <NSObject>

/*!
 * @brief 重置输入
 * @discussion 重置后，流内数据将重新从头开始读取
 */
- (void)resetInput;

@end
