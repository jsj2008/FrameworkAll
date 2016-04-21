//
//  ResourceLoadCode.h
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        ResourceLoadCode
 
    @abstract
        资源加载状态码
 
 *********************************************************/

typedef enum
{
    ResourceLoadCode_OK = 0,             // 加载成功
    ResourceLoadCode_HTTPLoadFail = 1,   // 加载失败
    ResourceLoadCode_InvalidRequest = 2  // 无效请求
}ResourceLoadCode;
