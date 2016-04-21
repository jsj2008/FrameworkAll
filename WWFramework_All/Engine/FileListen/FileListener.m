//
//  FileListener.m
//  FileListen
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FileListener.h"
#import "Notifier.h"

@interface FileListener ()
{
    // 事件源
    dispatch_source_t _listenSource;
}

/*!
 * @brief 通知线程
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 处理监听事件
 */
- (void)handleEvent:(int)event;

/*!
 * @brief 处理监听的取消
 */
- (void)handleCancel;

@end


@implementation FileListener

@synthesize filePath = _filePath;

@synthesize listenType = _listenType;

- (id)initWithFilePath:(NSString *)filePath listenType:(FileListenType)listenType listenQueue:(dispatch_queue_t)listenQueue
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
        
        _listenType = listenType;
        
        _listenQueue = listenQueue;
    }
    
    return self;
}

- (BOOL)listen
{
    BOOL success = NO;
    
    if (!_isCancelled)
    {
        int fileDescription = open([_filePath fileSystemRepresentation], O_EVTONLY);
        
        if (fileDescription == -1)
        {
            return success;;
        }
        
        //检查type是否符合标准，不符合标准将不再创建dispatch source
        int vnodeFlag = (_listenType < DISPATCH_VNODE_DELETE || _listenType > (DISPATCH_VNODE_DELETE | DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE)) ? 0 : _listenType;
        
        if (vnodeFlag != 0)
        {
            _listenSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileDescription, vnodeFlag, _listenQueue);
        }
        
        if (_listenQueue)
        {
            self.notifyThread = [NSThread currentThread];
            
            dispatch_source_set_event_handler(_listenSource, ^{
                
                int event = (int)dispatch_source_get_data(_listenSource);
                
                [Notifier notify:^{
                    
                    [self handleEvent:event];
                    
                } onThread:self.notifyThread];
            });
            
            dispatch_source_set_cancel_handler(_listenSource, ^{
                
                [Notifier notify:^{
                    
                    [self handleCancel];
                    
                } onThread:self.notifyThread];
                
                close(fileDescription);
            });
            
            dispatch_resume(_listenSource);
            
            _isRunning = YES;
            
            success = YES;
        }
        else
        {
            close(fileDescription);
            
            success = NO;
        }
    }
    
    return success;
}

- (void)cancel
{
    if (!_isCancelled && _listenSource)
    {
        _isCancelled = YES;
        
        dispatch_source_cancel(_listenSource);
        
        _listenSource = NULL;
    }
}

- (void)suspend
{
    if (!_isCancelled && _isRunning && _listenSource)
    {
        dispatch_suspend(_listenSource);
        
        _isRunning = NO;
    }
}

- (void)resume
{
    if (!_isCancelled && !_isRunning && _listenSource)
    {
        dispatch_resume(_listenSource);
        
        _isRunning = YES;
    }
}

- (void)handleEvent:(int)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileListener:didListenEvent:)])
    {
        [self.delegate fileListener:self didListenEvent:event];
    }
}

- (void)handleCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileListenerDidCancel:)])
    {
        [self.delegate fileListenerDidCancel:self];
    }
}

@end
