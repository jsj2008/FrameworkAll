//
//  ImageManager.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageManager.h"
#import "ImageDC.h"
#import "NotificationObservingSet.h"
#import "Notifier.h"
#import "AccountCenter.h"
#import "SPTaskDispatcher.h"
#import "ImageDownloadTask.h"

@interface ImageManager () <ImageDownloadTaskDelegate>

/*!
 * @brief 观察者
 */
@property (nonatomic) NSMutableDictionary *downloadImageObservers;

/*!
 * @brief 任务派发器
 */
@property (nonatomic) SPTaskDispatcher *taskDispatcher;

/*!
 * @brief 下载任务账户
 */
@property (nonatomic) Account *taskAccount;

/*!
 * @brief 同步队列
 */
@property (nonatomic) dispatch_queue_t syncQueue;

@end


@implementation ImageManager

- (void)dealloc
{
    [self.taskDispatcher cancel];
}

+ (ImageManager *)sharedInstance
{
    static ImageManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ImageManager alloc] init];
        }
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.taskAccount = [[AccountCenter sharedInstance] imageAccount];
        
        self.syncQueue = dispatch_queue_create(nil, nil);
        
        self.taskDispatcher = [[SPTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)start
{
    [[ImageDC sharedInstance] cleanTempResources];
}

- (void)stop
{
    [self.taskDispatcher cancel];
}

- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer
{
    dispatch_sync(self.syncQueue, ^{
        
        if ([URL isFileURL])
        {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            
            BOOL successfully = ([data length] > 0);
            
            [Notifier notify:^{
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:successfully:withImageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:URL successfully:successfully withImageData:successfully ? data : nil];
                }
            }];
        }
        else
        {
            NSData *data = [[ImageDC sharedInstance] imageDataByURL:URL];
            
            if (data)
            {
                [Notifier notify:^{
                    
                    if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:successfully:withImageData:)])
                    {
                        [observer imageManager:self didFinishDownloadImageByURL:URL successfully:YES withImageData:data];
                    }
                }];
            }
            else
            {
                NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
                
                if (!set)
                {
                    ImageDownloadTask *task = [[ImageDownloadTask alloc] init];
                    
                    task.account = self.taskAccount;
                    
                    task.savingPath = [[ImageDC sharedInstance] tempImagePathByURL:URL];
                    
                    [self.taskDispatcher asyncAddTask:task];
                    
                    set = [[NotificationObservingSet alloc] init];
                    
                    set.object = task;
                    
                    [self.downloadImageObservers setObject:set forKey:URL];
                }
                
                NotificationObserver *notificationObserver = [[NotificationObserver alloc] init];
                
                notificationObserver.observer = observer;
                
                notificationObserver.notifyThread = [NSThread currentThread];
                
                [set.observers addObject:notificationObserver];
            }
        }
    });
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDownloadObserving>)observer
{
    if (URL && observer)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            if (set)
            {
                NSMutableArray *toRemoveObjects = [[NSMutableArray alloc] init];
                
                for (NotificationObserver *notificationObserver in set.observers)
                {
                    if (notificationObserver.observer == observer)
                    {
                        [toRemoveObjects addObject:notificationObserver];
                    }
                }
                
                [set.observers removeObjectsInArray:toRemoveObjects];
            }
            
            if (![set.observers count])
            {
                [self.taskDispatcher cancelTask:set.object];
                
                [self.downloadImageObservers removeObjectForKey:URL];
            }
        });
    }
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL
{
    if (URL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            [self.taskDispatcher cancelTask:set.object];
            
            [self.downloadImageObservers removeObjectForKey:URL];
        });
    }
}

- (NSData *)localImageDataByURL:(NSURL *)URL
{
    __block NSData *data = nil;
    
    dispatch_sync(self.syncQueue, ^{
        
        if ([URL isFileURL])
        {
            data = [NSData dataWithContentsOfURL:URL];
        }
        else
        {
            data = [[ImageDC sharedInstance] imageDataByURL:URL];
        }
    });
    
    return data;
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishSuccessfully:(BOOL)successfully withImageData:(NSData *)data
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            [[ImageDC sharedInstance] saveImageByURL:task.imageURL withDataPath:task.savingPath];
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notify:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:successfully:withImageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:task.imageURL successfully:successfully withImageData:(successfully ? data : nil)];
                }
            } onThread:nil];
            
            [self.taskDispatcher removeTask:task];
            
            [self.downloadImageObservers removeObjectForKey:task.imageURL];
        });
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithProgress:(float)progress
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notify:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didDownloadImageByURL:withProgress:)])
                {
                    [observer imageManager:self didDownloadImageByURL:task.imageURL withProgress:progress];
                }
            } onThread:nil];
        });
    }
}

@end
