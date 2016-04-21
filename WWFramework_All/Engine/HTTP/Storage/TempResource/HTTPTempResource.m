//
//  HTTPTempResource.m
//  Application
//
//  Created by Baymax on 14-2-17.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPTempResource.h"
#import "IndexingStorage.h"
#import "MD5Cryptor.h"

@interface HTTPTempResource ()
{
    FilingIndexingStorage *_storage;
}

@end


@implementation HTTPTempResource

+ (HTTPTempResource *)sharedInstance
{
    static HTTPTempResource *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPTempResource alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    if (!_storage)
    {
        _storage = [[FilingIndexingStorage alloc] initWithRootDirectory:self.rootDirectory];
    }
}

- (void)saveResponse:(HTTPTempResourceResponse *)response forDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account
{
    if (response && request && account)
    {
        [_storage saveData:[NSKeyedArchiver archivedDataWithRootObject:response] forIndex:[request cacheIndex] ofAccount:account];
    }
}

- (HTTPTempResourceResponse *)responseForDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account
{
    HTTPTempResourceResponse *response = nil;
    
    if (request && account)
    {
        NSString *cacheIndex = [request cacheIndex];
        
        if (cacheIndex)
        {
            NSDictionary *datas = [_storage datasForIndexes:[NSArray arrayWithObject:cacheIndex] ofAccount:account];
            
            if ([datas count])
            {
                NSData *data = [datas objectForKey:cacheIndex];
                
                response = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
    }
    
    return response;
}

- (void)removeResponseForDownloadRequest:(HTTPDownloadRequest *)request ofAccount:(HTTPAccount *)account
{
    if (request && account)
    {
        NSString *cacheIndex = [request cacheIndex];
        
        if (cacheIndex)
        {
            [_storage cleanDatasForIndexes:[NSArray arrayWithObject:cacheIndex] ofAccount:account];
        }
    }
}

- (void)removeResponsesOfAccount:(HTTPAccount *)account
{
    if (account)
    {
        [_storage cleanDatasOfAccount:account];
    }
}

- (void)removeAllResponse
{
    [_storage cleanAllDatas];
}

- (long long)currentResponseSize
{
    return [_storage currentDataSize];
}

@end


@implementation HTTPDownloadRequest (Cache)

- (NSString *)cacheIndex
{
    NSString *index = nil;
    
    if (self.URL && [[self.method lowercaseString] isEqualToString:@"get"] && self.savingPath)
    {
        index = [[[self.URL absoluteString] stringByAppendingString:self.savingPath] uppercaseMD5EncodedString];
    }
    
    return index;
}

@end
