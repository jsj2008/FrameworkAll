//
//  ResourceRequest.m
//  Application
//
//  Created by Baymax on 14-2-27.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "ResourceRequest.h"

@implementation ResourceRequest

- (NSString *)identifier
{
    NSString *identifier = nil;
    
    if (self.canShareLoading)
    {
        identifier = [NSString stringWithFormat:@"%@_%@", [self.URL absoluteString], [self.account identifier]];
    }
    else
    {
        static unsigned long long flag = 0;
        
        flag ++;
        
        identifier = [NSString stringWithFormat:@"%@_%@_%lld", [self.URL absoluteString], [self.account identifier], flag];
    }
    
    return identifier;
}

@end
