//
//  UFURLImageLoader.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/22/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UFURLImageLoaderDelegate;


/*********************************************************
 
    @class
        UFURLImageLoader
 
    @abstract
        URL图片加载器
 
    @discussion
        在dealloc时，将自动取消正在进行的加载操作
 
 *********************************************************/

@interface UFURLImageLoader : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFURLImageLoaderDelegate> delegate;

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
 * @brief 用户数据，透传
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 加载
 */
- (void)load;

/*!
 * @brief 取消加载
 */
- (void)cancel;

@end


/*********************************************************
 
    @class
        UFURLImageLoaderDelegate
 
    @abstract
        URL图片加载消息协议
 
 *********************************************************/

@protocol UFURLImageLoaderDelegate <NSObject>

/*!
 * @brief 图片加载结束
 * @param loader 加载器
 * @param successfully 加载成功标记
 * @param data 图片数据
 */
- (void)URLImageLoader:(UFURLImageLoader *)loader didLoadSuccessfully:(BOOL)successfully withData:(NSData *)data;

@end
