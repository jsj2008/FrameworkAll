//
//  UFLocalURLImageLoader.m
//  WWFramework_All
//
//  Created by ww on 16/3/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFLocalURLImageLoader.h"
#import "SPTaskDispatcher.h"
#import "BlockTask.h"
#import "ImageManager.h"

static NSString * const kURLKey = @"URL";

static NSString * const kDataKey = @"data";


@interface UFLocalURLImageLoader () <BlockTaskDelegate>
{
    NSURL *_URL;
}

@property (nonatomic) SPTaskDispatcher *taskDispatcher;

@end


@implementation UFLocalURLImageLoader

@synthesize URL = _URL;

- (void)dealloc
{
    [self.taskDispatcher cancel];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        self.taskDispatcher = [[SPTaskDispatcher alloc] init];
        
        _URL = [URL copy];
    }
    
    return self;
}

- (void)load
{
    BlockTask *task = [[BlockTask alloc] init];
    
    [task.context setBlockTaskContextObject:self.URL forKey:kURLKey];
        
    __weak typeof(task) weakTask = task;
    
    task.block = ^(void){
        
        NSData *data = [[ImageManager sharedInstance] localImageDataByURL:self.URL];
        
        [weakTask.context setBlockTaskContextObject:data forKey:kDataKey];
    };
    
    task.delegate = self;
    
    [self.taskDispatcher asyncAddTask:task];
}

- (void)blockTaskDidFinish:(BlockTask *)task
{
    NSData *data = [task.context objectForKey:kDataKey];
    
    [self.taskDispatcher removeTask:task];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(localURLImageLoader:didLoadWithData:)])
    {
        [self.delegate localURLImageLoader:self didLoadWithData:data];
    }
}

@end
