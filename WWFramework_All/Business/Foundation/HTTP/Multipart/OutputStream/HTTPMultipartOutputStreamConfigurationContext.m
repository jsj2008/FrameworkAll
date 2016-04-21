//
//  HTTPMultipartOutputStreamConfigurationContext.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-20.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartOutputStreamConfigurationContext.h"
#import "MainFileDirectoryCenter.h"

@implementation HTTPMultipartOutputStreamConfigurationContext

- (id)init
{
    if (self = [super init])
    {
        self.maxFragmentHeaderFieldsSize = 4 * 1024;
        
        self.fragmentSizeLimitToFile = 1024 * 1024;
        
        self.savingDirectory = [[MainFileDirectoryCenter sharedInstance] HTTPMultipartParseTempFileRootDirectory];
    }
    
    return self;
}

- (NSString *)validFilePathForSaving
{
    static unsigned long long flag = 1;
    
    NSString *path = nil;
    
    if ([self.savingDirectory length])
    {
        flag ++;
        
        path = [self.savingDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld", flag]];
    }
    
    return path;
}

@end
