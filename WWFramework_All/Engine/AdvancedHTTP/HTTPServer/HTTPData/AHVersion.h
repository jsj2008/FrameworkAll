//
//  AHVersion.h
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        AHVersion
 
    @abstract
        HTTP版本号
 
    @discussion
        不支持HTTP0.9版本
 
 *********************************************************/

typedef enum
{
    AHVersion_Undefined = 0,
    AHVersion_1_0       = 1,    // HTTP1.0
    AHVersion_1_1       = 2     // HTTP1.1
}AHVersion;
