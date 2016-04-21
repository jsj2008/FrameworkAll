//
//  FoundationTask.h
//  Demo
//
//  Created by Baymax on 13-10-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTask.h"
#import "Account.h"

/*********************************************************
 
    @class
        FoundationTask
 
    @abstract
        基础Task，扩展了账户和用户字典属性
 
 *********************************************************/

@interface FoundationTask : SPTask

/*!
 * @brief 用户账户
 */
@property (nonatomic) Account *account;

/*!
 * @brief 用户字典，仅用于传递，内部不进行任何处理
 */
@property (nonatomic) NSDictionary *userInfo;

@end
