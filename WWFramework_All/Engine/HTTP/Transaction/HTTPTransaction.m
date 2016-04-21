//
//  HTTPTransaction.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPTransaction.h"
#import "HTTPRequestProcessor.h"
#import "HTTPConnectionProcessor.h"
#import "HTTPNetServiceCenter.h"
#import "Notifier.h"
#import "DataInputStream.h"

@interface HTTPTransaction ()
{
    HTTPRequest *_request;
}

@property (nonatomic) HTTPRequestProcessor *requestProcessor;

@property (nonatomic) HTTPConnectionProcessor *connectionProcessor;

@property (nonatomic) NSThread *runningThread;

- (void)finishWithCode:(HTTPTransactionCode)code;

@end


@implementation HTTPTransaction

- (id)initWithRequest:(HTTPRequest *)request
{
    if (self = [super init])
    {
        _request = request;
    }
    
    return self;
}

- (void)run
{
    if ([[HTTPNetServiceCenter sharedInstance] addTransaction:self])
    {
        self.runningThread = [NSThread currentThread];
        
        self.requestProcessor = [[HTTPRequestProcessor alloc] initWithRequest:_request];
        
        self.connectionProcessor = [[HTTPConnectionProcessor alloc] initWithURLRequest:[self.requestProcessor URLRequest]];
        
        self.connectionProcessor.delegate = self;
        
        [self.connectionProcessor run];
    }
    else
    {
        [self finishWithCode:HTTPTransactionCode_HTTPServiceUnavailable];
    }
}

- (void)cancel
{
    [[HTTPNetServiceCenter sharedInstance] removeTransaction:self];
    
    self.requestProcessor = nil;
    
    self.connectionProcessor.delegate = nil;
    
    [self.connectionProcessor cancel];
    
    self.connectionProcessor = nil;
}

- (void)finishWithCode:(HTTPTransactionCode)code
{
    [self cancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPTransaction:didFinishWithCode:)])
    {
        [self.delegate HTTPTransaction:self didFinishWithCode:code];
    }
}

- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didFinishWithCode:(HTTPTransactionCode)code
{
    [self finishWithCode:code];
}

- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didReceiveURLResponse:(NSHTTPURLResponse *)response
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPTransaction:didReceiveURLResponse:)])
    {
        [self.delegate HTTPTransaction:self didReceiveURLResponse:response];
    }
}

- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didReceiveResponseBodyData:(NSData *)data
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPTransaction:didReceiveResponseBodyData:)])
    {
        [self.delegate HTTPTransaction:self didReceiveResponseBodyData:data];
    }
}

- (void)HTTPConnectionProcessor:(HTTPConnectionProcessor *)processor didSendRequestBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPTransaction:didSendRequestBodyData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPTransaction:self didSendRequestBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

@end


@implementation HTTPTransaction (HTTPNetService)

- (void)finishByNetServiceUnavailable
{
    [Notifier notify:^{
        
        [self finishWithCode:HTTPTransactionCode_HTTPServiceUnavailable];
    } onThread:self.runningThread];
}

@end
