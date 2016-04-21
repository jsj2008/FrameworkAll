//
//  UFScrollLoadMoreUpdater.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadMoreUpdater.h"
#import "UFScrollContentOffsetUpdater.h"

@interface UFScrollLoadMoreUpdater () <UFScrollLoadingViewDelegate>
{
    UIScrollView *_scrollView;
    
    UFScrollLoadMoreView *_loadMoreView;
}

@property (nonatomic) UFScrollLoadMoreStatus status;

@property (nonatomic) UIEdgeInsets contentInsetOffset;

- (void)prepareLoadMore;

- (void)resetLoadMore;

@end


@implementation UFScrollLoadMoreUpdater

@synthesize scrollView = _scrollView;

@synthesize loadMoreView = _loadMoreView;

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
    // contentInset的调整会触发contentOffset的KVO，因此必须在KVO解除后执行本操作
    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom - self.contentInsetOffset.bottom, self.scrollView.contentInset.right);
    
    [self.loadMoreView removeFromSuperview];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = UFScrollLoadMoreStatus_Reset;
        
        self.enableLoadMore = YES;
    }
    
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView loadMoreView:(UFScrollLoadMoreView *)loadMoreView
{
    if (self = [super init])
    {
        _scrollView = scrollView;
        
        _loadMoreView = loadMoreView;
        
        if (scrollView && loadMoreView)
        {
            [scrollView addSubview:loadMoreView];
            
            self.contentInsetOffset = UIEdgeInsetsMake(0, 0, loadMoreView.contentSize.height, 0);
            
            // contentInset的调整会触发contentOffset的KVO，因此必须在KVO开始前执行本操作
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom + self.contentInsetOffset.bottom, scrollView.contentInset.right);
            
            loadMoreView.frame = CGRectZero;
            
            loadMoreView.delegate = self;
            
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
        }
        
        self.status = UFScrollLoadMoreStatus_Reset;
        
        self.enableLoadMore = YES;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentSize"])
    {
        if (self.scrollView.contentSize.height > 0)
        {
            self.loadMoreView.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.contentSize.width, self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height);
        }
        else
        {
            self.loadMoreView.frame = CGRectZero;
        }
    }
    
    if (self.isLoadMoreEnabled)
    {
        if ([keyPath isEqualToString:@"contentOffset"])
        {
            if (self.status == UFScrollLoadMoreStatus_Loading)
            {
                ;
            }
            else if (self.scrollView.contentSize.height == 0)
            {
                ;
            }
            else if (self.scrollView.contentSize.height + self.loadMoreView.contentSize.height <= self.scrollView.frame.size.height)
            {
                if (self.scrollView.isTracking)
                {
                    if (self.scrollView.contentOffset.y > 0)
                    {
                        if (self.status != UFScrollLoadMoreStatus_Prepare)
                        {
                            [self prepareLoadMore];
                        }
                    }
                    else if (self.scrollView.contentOffset.y < 0)
                    {
                        if (self.status != UFScrollLoadMoreStatus_Reset)
                        {
                            [self resetLoadMore];
                        }
                    }
                }
                else
                {
                    if (self.autoLoadingWhenContentSizeVisible)
                    {
                        [self startLoadingMore];
                    }
                    else
                    {
                        if (self.scrollView.contentOffset.y == 0)
                        {
                            if (self.status == UFScrollLoadMoreStatus_Prepare)
                            {
                                [self startLoadingMore];
                            }
                        }
                    }
                }
            }
            else
            {
                if (self.scrollView.isTracking)
                {
                    if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height + self.loadMoreView.contentSize.height)
                    {
                        if (self.status != UFScrollLoadMoreStatus_Prepare)
                        {
                            [self prepareLoadMore];
                        }
                    }
                    else
                    {
                        if (self.status != UFScrollLoadMoreStatus_Reset)
                        {
                            [self resetLoadMore];
                        }
                    }
                }
                else
                {
                    if (fabs(self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height - self.loadMoreView.contentSize.height) < 1)
                    {
                        if (self.status == UFScrollLoadMoreStatus_Prepare)
                        {
                            [self startLoadingMore];
                        }
                    }
                }
            }
        }
    }
}

- (void)startLoadingMore
{
    if (self.status != UFScrollLoadMoreStatus_Loading)
    {
        self.status = UFScrollLoadMoreStatus_Loading;
        
        if (self.loadMoreView.status != UFScrollLoadingViewStatus_Loading)
        {
            [self.loadMoreView start];
        }
    }
}

- (void)stopLoadingMore
{
    if (self.status == UFScrollLoadMoreStatus_Loading)
    {
        if (self.loadMoreView.status == UFScrollLoadingViewStatus_Loading)
        {
            [self.loadMoreView stop];
        }
    }
}

- (void)prepareLoadMore
{
    if (self.status != UFScrollLoadMoreStatus_Prepare)
    {
        self.status = UFScrollLoadMoreStatus_Prepare;
        
        if (self.loadMoreView.status != UFScrollLoadingViewStatus_Prepare)
        {
            [self.loadMoreView prepare];
        }
    }
}

- (void)resetLoadMore
{
    if (self.status != UFScrollLoadMoreStatus_Reset)
    {
        self.status = UFScrollLoadMoreStatus_Reset;
        
        if (self.loadMoreView.status != UFScrollLoadingViewStatus_Reset)
        {
            [self.loadMoreView reset];
        }
    }
}

- (UFScrollLoadMoreStatus)currentLoadMoreStatus
{
    return self.status;
}

- (void)scrollLoadingViewDidStart:(UFScrollLoadingView *)view
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadMoreUpdaterDidStartLoadingMore:)])
    {
        [self.delegate scrollLoadMoreUpdaterDidStartLoadingMore:self];
    }
}

- (void)scrollLoadingViewDidStop:(UFScrollLoadingView *)view
{
    self.status = UFScrollLoadMoreStatus_Reset;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollLoadMoreUpdaterDidStopLoadingMore:)])
    {
        [self.delegate scrollLoadMoreUpdaterDidStopLoadingMore:self];
    }
}

- (void)scrollLoadingViewDidChangeContentSize:(UFScrollLoadingView *)view
{
    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top - self.contentInsetOffset.top, self.scrollView.contentInset.left - self.contentInsetOffset.left, self.scrollView.contentInset.bottom - self.contentInsetOffset.bottom + view.contentSize.height, self.scrollView.contentInset.right - self.contentInsetOffset.right);
    
    self.contentInsetOffset = UIEdgeInsetsMake(0, 0, view.contentSize.height, 0);
}

@end
