//
//  UFScrollRefreshAndLoadMoreContainer.m
//  WWFramework_All
//
//  Created by ww on 16/2/28.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollRefreshAndLoadMoreContainer.h"
#import "UFScrollRefreshUpdater.h"
#import "UFScrollLoadMoreUpdater.h"

@interface UFScrollRefreshAndLoadMoreContainer () <UFScrollRefreshUpdaterDelegate, UFScrollLoadMoreUpdaterDelegate>

@property (nonatomic) UFScrollRefreshUpdater *refreshUpdater;

@property (nonatomic) UFScrollLoadMoreUpdater *loadMoreUpdater;

@property (nonatomic, copy) void(^refreshingCompletion)(void);

@property (nonatomic, copy) void(^loadingMoreCompletion)(void);

@end


@implementation UFScrollRefreshAndLoadMoreContainer

- (void)setEnableRefresh:(BOOL)enableRefresh
{
    _enableRefresh = enableRefresh;
    
    if (enableRefresh)
    {
        if (!(self.scrollView && self.refreshView && self.refreshUpdater.scrollView == self.scrollView && self.refreshUpdater.refreshView == self.refreshView))
        {
            self.refreshUpdater = [[UFScrollRefreshUpdater alloc] initWithScrollView:self.scrollView refreshView:self.refreshView];
            
            self.refreshUpdater.delegate = self;
        }
    }
    else
    {
        self.refreshUpdater = nil;
    }
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore
{
    _enableLoadMore = enableLoadMore;
    
    if (enableLoadMore)
    {
        if (!(self.scrollView && self.loadMoreView && self.loadMoreUpdater.scrollView == self.scrollView && self.loadMoreUpdater.loadMoreView == self.loadMoreView))
        {
            self.loadMoreUpdater = [[UFScrollLoadMoreUpdater alloc] initWithScrollView:self.scrollView loadMoreView:self.loadMoreView];
            
            self.loadMoreUpdater.delegate = self;
        }
    }
    else
    {
        self.loadMoreUpdater = nil;
    }
}

- (void)simulateRefreshing
{
    [self.refreshUpdater simulateRefreshing];
}

- (void)stopRefreshingWithCompletion:(void (^)(void))completion
{
    self.refreshingCompletion = completion;
    
    [self.refreshUpdater stopRefreshing];
}

- (void)stopLoadingMoreWithCompletion:(void (^)(void))completion
{
    self.loadingMoreCompletion = completion;
    
    [self.loadMoreUpdater stopLoadingMore];
}

- (void)scrollRefreshUpdaterDidStartRefreshing:(UFScrollRefreshUpdater *)updater
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollRefreshAndLoadMoreContainerDidStartRefresh:)])
    {
        [self.delegate scrollRefreshAndLoadMoreContainerDidStartRefresh:self];
    }
}

- (void)scrollRefreshUpdaterDidStopRefreshing:(UFScrollRefreshUpdater *)updater
{
    void (^completion)(void) = self.refreshingCompletion;
    
    self.refreshingCompletion = nil;
    
    if (completion)
    {
        completion();
    }
}

- (void)scrollLoadMoreUpdaterDidStartLoadingMore:(UFScrollLoadMoreUpdater *)updater
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollRefreshAndLoadMoreContainerDidStartLoadMore:)])
    {
        [self.delegate scrollRefreshAndLoadMoreContainerDidStartLoadMore:self];
    }
}

- (void)scrollLoadMoreUpdaterDidStopLoadingMore:(UFScrollLoadMoreUpdater *)updater
{
    void (^completion)(void) = self.loadingMoreCompletion;
    
    self.loadingMoreCompletion = nil;
    
    if (completion)
    {
        completion();
    }
}

@end
