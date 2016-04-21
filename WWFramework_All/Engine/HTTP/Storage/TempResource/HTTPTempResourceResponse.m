//
//  HTTPTempResourceResponse.m
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPTempResourceResponse.h"

@implementation HTTPTempResourceResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.URLResponse forKey:@"response"];
    
    [aCoder encodeObject:self.expireDate forKey:@"expireDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.URLResponse = [aDecoder decodeObjectForKey:@"response"];
        
        self.expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
    }
    
    return self;
}

@end
