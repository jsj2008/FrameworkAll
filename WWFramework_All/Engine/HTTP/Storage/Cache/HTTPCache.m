//
//  HTTPCache.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPCache.h"
#import "IndexingStorage.h"
#import "MD5Cryptor.h"

@interface HTTPCache ()
{
    FilingIndexingStorage *_storage;
}

@end


@implementation HTTPCache

+ (HTTPCache *)sharedInstance
{
    static HTTPCache *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPCache alloc] init];
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

- (void)saveResponse:(HTTPCachedResponse *)response forRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account
{
    NSString *cacheIndex = [request cacheIndex];
    
    if (response && cacheIndex && account)
    {
        [_storage saveData:[NSKeyedArchiver archivedDataWithRootObject:response] forIndex:[request cacheIndex] ofAccount:account];
    }
}

- (HTTPCachedResponse *)responseForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account
{
    HTTPCachedResponse *response = nil;
    
    NSString *cacheIndex = [request cacheIndex];
    
    if (cacheIndex && account)
    {
        NSDictionary *datas = [_storage datasForIndexes:[NSArray arrayWithObject:cacheIndex] ofAccount:account];
        
        if ([datas count])
        {
            NSData *data = [datas objectForKey:cacheIndex];
            
            response = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    
    return response;
}

- (void)removeResponseForRequest:(HTTPRequest *)request ofAccount:(HTTPAccount *)account
{
    NSString *cacheIndex = [request cacheIndex];
    
    if (cacheIndex && account)
    {
        [_storage cleanDatasForIndexes:[NSArray arrayWithObject:cacheIndex] ofAccount:account];
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


@implementation HTTPRequest (Cache)

- (NSString *)cacheIndex
{
    NSString *index = nil;
    
    if (self.URL && [[self.method lowercaseString] isEqualToString:@"get"])
    {
        index = [[self.URL absoluteString] uppercaseMD5EncodedString];
    }
    
    return index;
}

@end
