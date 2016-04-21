//
//  HTTPCachedResponse.m
//  FoundationProject
//
//  Created by Baymax on 14-2-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPCachedResponse.h"

@implementation HTTPCachedResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.response forKey:@"response"];
    
    [aCoder encodeObject:self.expireDate forKey:@"expireDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.response = [aDecoder decodeObjectForKey:@"response"];
        
        self.expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
    }
    
    return self;
}

@end
