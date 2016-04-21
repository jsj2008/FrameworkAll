//
//  UFLocalURLImageLoader.h
//  WWFramework_All
//
//  Created by ww on 16/3/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UFLocalURLImageLoaderDelegate;


/*********************************************************
 
    @class
        UFLocalURLImageLoader
 
    @abstract
        本地URL图片加载器
 
 *********************************************************/

@interface UFLocalURLImageLoader : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFLocalURLImageLoaderDelegate> delegate;

/*!
 * @brief 初始化
 * @param URL 图片URL
 * @result 初始化对象
 */
- (instancetype)initWithURL:(NSURL *)URL;

/*!
 * @brief 图片URL
 */
@property (nonatomic, readonly) NSURL *URL;

/*!
 * @brief 加载
 */
- (void)load;

@end


/*********************************************************
 
    @category
        UFLocalURLImageLoaderDelegate
 
    @abstract
        本地URL图片加载器消息协议
 
 *********************************************************/

@protocol UFLocalURLImageLoaderDelegate <NSObject>

/*!
 * @brief 图片加载结束
 * @param loader 加载器
 * @param data 图片数据
 */
- (void)localURLImageLoader:(UFLocalURLImageLoader *)loader didLoadWithData:(NSData *)data;

@end
