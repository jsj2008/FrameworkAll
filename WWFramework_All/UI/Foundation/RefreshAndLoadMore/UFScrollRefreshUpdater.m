//
//  UFScrollRefreshUpdater.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollRefreshUpdater.h"
#import "UFScrollContentOffsetUpdater.h"

@interface UFScrollRefreshUpdater () <UFScrollLoadingViewDelegate>
{
    UIScrollView *_scrollView;
    
    UFScrollRefreshView *_refreshView;
}

@property (nonatomic) UFScrollRefreshStatus status;

/*!
 * @brief 滚动视图的侦听开关
 * @discussion 在滚动视图自动滚动时，禁止侦听，以免状态错乱
 */
@property (nonatomic, getter=isScrollObservingEnabled) BOOL enableScrollObserving;

@property (nonatomic) UFScrollContentOffsetUpdater *contentOffsetUpdater;

- (void)prepareRefresh;

- (void)resetRefresh;

@end


@implementation UFScrollRefreshUpdater

@synthesize scrollView = _scrollView;

@synthesize refreshView = _refreshView;

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    
    [self.refreshView removeFromSuperview];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = UFScrollRefreshStatus_Reset;
        
        self.enableRefresh = YES;
        
        self.enableScrollObserving = YES;
    }
    
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView refreshView:(UFScrollRefreshView *)refreshView
{
    if (self = [super init])
    {
        _scrollView = scrollView;
        
        _refreshView = refreshView;
        
        if (scrollView && refreshView)
        {
            [scrollView addSubview:refreshView];
            
            refreshView.frame = CGRectZero;
            
            refreshView.delegate = self;
            
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
            
            [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:0 context:nil];
        }
        
        self.status = UFScrollRefreshStatus_Reset;
        
        self.enableRefresh = YES;
        
        self.enableScrollObserving = YES;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"contentOffset"])
    {
        self.refreshView.frame = CGRectMake(0, self.scrollView.contentOffset.y, self.scrollView.contentSize.width, - self.scrollView.contentOffset.y);
    }
    
    if (self.isRefreshEnabled)
    {
        if (self.isScrollObservingEnabled)
        {
            if ([keyPath isEqualToString:@"contentOffset"])
            {
                if (self.status == UFScrollRefreshStatus_Loading)
                {
                    ;
                }
                else if (self.scrollView.isTracking)
                {
                    if (- self.scrollView.contentOffset.y > self.refreshView.contentSize.height)
                    {
                        if (self.status != UFScrollRefreshStatus_Prepare)
                        {
                            [self prepareRefresh];
                        }
                    }
                    else
                    {
                        if (self.status != UFScrollRefreshStatus_Reset)
                        {
                            [self resetRefresh];
                        }
                    }
                }
                else if (- self.scrollView.contentOffset.y == self.refreshView.contentSize.height)
                {
                    if (self.status == UFScrollRefreshStatus_Prepare)
                    {
                        [self startRefreshing];
                    }
                }
            }
            
            if ([keyPath isEqualToString:@"state"])
            {
                if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
                {
                    if (self.scrollView.contentOffset.y < 0 && - self.scrollView.contentOffset.y > self.refreshView.contentSize.height)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, - self.refreshView.contentSize.height) animated:YES];
                        });
                    }
                }
            }
        }
    }
}

- (void)simulateRefreshing
{
    self.enableScrollObserving = NO;
    
    self.scrollView.userInteractionEnabled = NO;
    
    [self prepareRefresh];
    
    self.contentOffsetUpdater = [[UFScrollContentOffsetUpdater alloc] init];
    
    self.contentOffsetUpdater.scrollView = self.scrollView;
    
    self.contentOffsetUpdater.contentOffset = CGPointMake(self.scrollView.contentOffset.x, - self.refreshView.contentSize.height);
    
    self.contentOffsetUpdater.duration = 0.3;
    
    __weak typeof(self) weakSelf = self;
    
    self.contentOffsetUpdater.completion = ^(){
        
        weakSelf.enableScrollObserving = YES;
        
        weakSelf.scrollView.userInteractionEnabled = YES;
        
        [weakSelf startRefreshing];
        
    };
    
    [self.contentOffsetUpdater update];
}

- (void)startRefreshing
{
    if (self.status != UFScrollRefreshStatus_Loading)
    {
        self.status = UFScrollRefreshStatus_Loading;
        
        if (self.refreshView.status != UFScrollLoadingViewStatus_Loading)
        {
            [self.refreshView start];
        }
    }
}

- (void)stopRefreshing
{
    if (self.status == UFScrollRefreshStatus_Loading)
    {
        if (self.refreshView.status == UFScrollLoadingViewStatus_Loading)
        {
            [self.refreshView stop];
        }
    }
}

- (void)prepareRefresh
{
    if (self.status != UFScrollRefreshStatus_Prepare)
    {
        self.status = UFScrollRefreshStatus_Prepare;
        
        if (self.refreshView.status != UFScrollLoadingViewStatus_Prepare)
        {
            [self.refreshView prepare];
        }
    }
}

- (void)resetRefresh
{
    if (self.status != UFScrollRefreshStatus_Reset)
    {
        self.status = UFScrollRefreshStatus_Reset;
        
        if (self.refreshView.status != UFScrollLoadingViewStatus_Reset)
        {
            [self.refreshView reset];
        }
    }
}

- (UFScrollRefreshStatus)currentRefreshStatus
{
    return self.status;
}

- (void)scrollLoadingViewDidStart:(UFScrollLoadingView *)view
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollRefreshUpdaterDidStartRefreshing:)])
    {
        [self.delegate scrollRefreshUpdaterDidStartRefreshing:self];
    }
}

- (void)scrollLoadingViewDidStop:(UFScrollLoadingView *)view
{
    self.enableScrollObserving = NO;
    
    self.scrollView.userInteractionEnabled = NO;
    
    self.contentOffsetUpdater = [[UFScrollContentOffsetUpdater alloc] init];
    
    self.contentOffsetUpdater.scrollView = self.scrollView;
    
    self.contentOffsetUpdater.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
    
    self.contentOffsetUpdater.duration = 0.3;
    
    __weak typeof(self) weakSelf = self;
    
    self.contentOffsetUpdater.completion = ^(){
                
        weakSelf.status = UFScrollRefreshStatus_Reset;
        
        weakSelf.enableScrollObserving = YES;
        
        weakSelf.scrollView.userInteractionEnabled = YES;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollRefreshUpdaterDidStopRefreshing:)])
        {
            [weakSelf.delegate scrollRefreshUpdaterDidStopRefreshing:weakSelf];
        };
    };
    
    [self.contentOffsetUpdater update];
}

@end
