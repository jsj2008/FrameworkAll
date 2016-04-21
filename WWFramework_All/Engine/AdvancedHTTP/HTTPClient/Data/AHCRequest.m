//
//  AHCRequest.m
//  Application
//
//  Created by WW on 14-5-9.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHCRequest.h"

@interface AHCRequest ()

@property (nonatomic) NSURL *requestURL;

@property (nonatomic) NSString *requestMethod;

@property (nonatomic) NSMutableDictionary *requestHeaderFields;

@property (nonatomic) AHCRequestBody *requestBody;

@property (nonatomic) NSTimeInterval requestTimeout;

@end


@implementation AHCRequest

- (id)init
{
    if (self = [super init])
    {
        self.requestHeaderFields = [NSMutableDictionary dictionary];
        
        self.requestTimeout = AHCRequestDefaultTimeout;
    }
    
    return self;
}

- (void)setURL:(NSURL *)URL
{
    self.requestURL = URL;
}

- (NSURL *)URL
{
    return self.requestURL;
}

- (void)setMethod:(NSString *)method
{
    self.requestMethod = method;
}

- (NSString *)method
{
    return self.requestMethod;
}

- (void)setHeaderFields:(NSDictionary *)headerFields
{
    [self.requestHeaderFields setDictionary:headerFields];
}

- (void)addHeaderFields:(NSDictionary *)headerFields
{
    [self.requestHeaderFields addEntriesFromDictionary:headerFields];
}

- (NSDictionary *)headerFields
{
    return self.requestHeaderFields;
}

- (void)setBodyData:(NSData *)data
{
    AHCRequestDataBody *body = [[AHCRequestDataBody alloc] init];
    
    body.data = data;
    
    self.requestBody = body;
}

- (NSData *)bodyData
{
    return [self.requestBody isKindOfClass:[AHCRequestDataBody class]] ? ((AHCRequestDataBody *)(self.requestBody)).data : nil;
}

- (void)setBodyDataStream:(NSInputStream *)stream
{
    AHCRequestStreamBody *body = [[AHCRequestStreamBody alloc] init];
    
    body.stream = stream;
    
    self.requestBody = body;
}

- (void)setTimeout:(NSTimeInterval)timeout
{
    if (timeout > 0)
    {
        self.requestTimeout = timeout;
    }
    else
    {
        self.requestTimeout = AHCRequestDefaultTimeout;
    }
}

- (NSTimeInterval)timeout
{
    return self.requestTimeout;
}

@end


@implementation AHCRequestBody

@end


@implementation AHCRequestDataBody

@end


@implementation AHCRequestStreamBody

@end


NSTimeInterval const AHCRequestDefaultTimeout = 3600;
