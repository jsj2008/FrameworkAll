//
//  HTTPRequest.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

- (id)init
{
    if (self = [super init])
    {
        self.method = @"GET";
        
        self.timeout = 60;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    HTTPRequest *copy = [[[self class] allocWithZone:zone] init];
    
    copy.URL = self.URL;
    
    copy.method = self.method;
    
    copy.headerFields = [NSDictionary dictionaryWithDictionary:self.headerFields];
    
    copy.timeout = self.timeout;
    
    copy.bodyStream = self.bodyStream;
    
    return copy;
}

@end
