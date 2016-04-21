//
//  HTTPDownloadRequest.m
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPDownloadRequest.h"

@implementation HTTPDownloadRequest

- (id)copyWithZone:(NSZone *)zone
{
    HTTPDownloadRequest *copy = [super copyWithZone:zone];
    
    copy.savingPath = self.savingPath;
    
    copy.referenceSize = self.referenceSize;
    
    return copy;
}

@end
