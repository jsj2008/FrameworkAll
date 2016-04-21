//
//  AHMessageVersion.h
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        AHMessageVersion
 
    @abstract
        HTTP版本号
 
    @discussion
        不支持HTTP0.9版本
 
 *********************************************************/

typedef enum
{
    AHMessageVersion_Undefined = 0,
    AHMessageVersion_1_0       = 1,    // HTTP1.0
    AHMessageVersion_1_1       = 2     // HTTP1.1
}AHMessageVersion;
