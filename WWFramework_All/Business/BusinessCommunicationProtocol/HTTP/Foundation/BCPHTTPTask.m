//
//  BCPHTTPTask.m
//  FoundationProject
//
//  Created by Baymax on 13-12-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "BCPHTTPTask.h"

#pragma mark - BCPHTTPTask

@implementation BCPHTTPTask

@synthesize URL = _URL;

- (id)init
{
    if (self = [super init])
    {
        self.loadSize = 1;
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        self.loadSize = 1;
        
        _URL = [URL copy];
    }
    
    return self;
}

@end
