//
//  HTTPResourceRequest.m
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPResourceRequest.h"

@implementation HTTPResourceRequest

- (NSString *)identifier
{
    return [NSString stringWithFormat:@"%@_%d", [super identifier], self.cachePolicy];
}

@end
