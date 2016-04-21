//
//  AHCRequest.h
//  Application
//
//  Created by WW on 14-5-9.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHCRequest : NSObject

- (void)setURL:(NSURL *)URL;

- (NSURL *)URL;

- (void)setMethod:(NSString *)method;

- (NSString *)method;

- (void)setHeaderFields:(NSDictionary *)headerFields;

- (void)addHeaderFields:(NSDictionary *)headerFields;

- (NSDictionary *)headerFields;

- (void)setBodyData:(NSData *)data;

- (NSData *)bodyData;

- (void)setBodyDataStream:(NSInputStream *)stream;

- (void)setTimeout:(NSTimeInterval)timeout;

- (NSTimeInterval)timeout;

@end


@interface AHCRequest (Standard)

- (AHCRequest *)standardRequest;

@end


@interface AHCRequestBody : NSObject

@end


@interface AHCRequestDataBody : AHCRequestBody

@property (nonatomic) NSData *data;

@end


@interface AHCRequestStreamBody : AHCRequestBody

@property (nonatomic) NSInputStream *stream;

@end


extern NSTimeInterval const AHCRequestDefaultTimeout;
