//
//  FileListener.h
//  FileListen
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileListenerDelegate;


/*********************************************************
 
    @class
        FileListenType
 
    @abstract
        文件监听类型
 
    @discussion
        支持|操作
 
 *********************************************************/

typedef enum
{
    SMFILELISTEN_DELETE = 0x1,
    SMFILELISTEN_WRITE = 0x2,
    SMFILELISTEN_EXTEND = 0x4,
    SMFILELISTEN_ATTRIB = 0x8,
    SMFILELISTEN_LINK = 0x10,
    SMFILELISTEN_RENAME = 0x20,
    SMFILELISTEN_REVOKE = 0x40
}FileListenType;


/*********************************************************
 
    @class
        FileListener
 
    @abstract
        文件监听器，监听指定文件的状态变化
 
    @discussion
        1、监听器采用GCD方式监听事件，需要指定监听器挂载的队列
        2、监听器支持暂停和继续操作
        3、释放监听器之前必须先取消监听任务，否则会造成内存泄漏
        4、监听到指定事件时，在－listen方法所在线程上使用协议回调方式发送消息
 
 *********************************************************/

@interface FileListener : NSObject
{
    // 监听文件的路径
    NSString *_filePath;
    
    // 监听类型
    FileListenType _listenType;
    
    // 挂载监听事件源的队列
    dispatch_queue_t _listenQueue;
    
    // 运行标志
    BOOL _isRunning;
    
    // 取消标志
    BOOL _isCancelled;
}

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<FileListenerDelegate> delegate;

/*!
 * @brief 监听文件的路径
 */
@property (nonatomic, readonly) NSString *filePath;

/*!
 * @brief 监听类型
 */
@property (nonatomic, readonly) FileListenType listenType;

/*!
 * @brief 初始化
 * @param filePath 监听文件的路径
 * @param listenType 监听类型
 * @param listenQueue 挂载监听事件源的队列
 * @result 初始化后的对象
 */
- (id)initWithFilePath:(NSString *)filePath listenType:(FileListenType)listenType listenQueue:(dispatch_queue_t)listenQueue;

/*!
 * @brief 监听文件
 * @discussion 每次监听到文件状态变化，调用-SMFileListenerDidListenEvent:方法通知代理；只允许执行一次
 */
- (BOOL)listen;

/*!
 * @brief 取消监听，释放所有监听资源
 * @discussion 调用-SMFileListenerDidCancel:方法通知代理。一旦取消监听，无法再继续或者重新监听；只允许执行一次
 */
- (void)cancel;

/*!
 * @brief 挂起监听
 * @discussion 允许执行多次
 */
- (void)suspend;

/*!
 * @brief 继续监听
 * @discussion 允许执行多次
 */
- (void)resume;

@end


/*********************************************************
 
    @protocol
        FileListenerDelegate
 
    @abstract
        文件监听的代理协议
 
 *********************************************************/

@protocol FileListenerDelegate <NSObject>

/*!
 * @brief 监听到文件状态变化
 * @param listener 文件监听器
 * @param event 监听到的事件类型
 */
- (void)fileListener:(FileListener *)listener didListenEvent:(FileListenType)event;

/*!
 * @brief 已取消监听文件
 * @param listener 文件监听器
 */
- (void)fileListenerDidCancel:(FileListener *)listener;

@end
