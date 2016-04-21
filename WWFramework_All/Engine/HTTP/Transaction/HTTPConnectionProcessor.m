//
//  HTTPConnectionProcessor.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPConnectionProcessor.h"

@interface HTTPConnectionProcessor ()
{
    NSURLRequest *_URLRequest;
}

@property (nonatomic) NSURLConnection *connection;

- (void)finishWithCode:(HTTPTransactionCode)code;

@end


@implementation HTTPConnectionProcessor

- (id)initWithURLRequest:(NSURLRequest *)URLRequest
{
    if (self = [super init])
    {
        _URLRequest = URLRequest;
    }
    
    return self;
}

- (void)run
{
    self.connection = [NSURLConnection connectionWithRequest:_URLRequest delegate:self];
}

- (void)cancel
{
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)finishWithCode:(HTTPTransactionCode)code
{
    [self cancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPConnectionProcessor:didFinishWithCode:)])
    {
        [self.delegate HTTPConnectionProcessor:self didFinishWithCode:code];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self finishWithCode:HTTPTransactionCode_OK];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self finishWithCode:[error HTTPTransactionCodeFromNSURLConnectionError]];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSURLRequest *redirectedRequest = nil;
    
    if (!response)
    {
        redirectedRequest = request;
    }
    
    return redirectedRequest;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if (challenge.previousFailureCount == 0)
    {
        // HTTPS认证，使用服务器证书
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
            
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
            
            return;
        }
    }
    
    [challenge.sender cancelAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        if ([self.delegate respondsToSelector:@selector(HTTPConnectionProcessor:didReceiveURLResponse:)])
        {
            [self.delegate HTTPConnectionProcessor:self didReceiveURLResponse:(NSHTTPURLResponse *)response];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPConnectionProcessor:didReceiveResponseBodyData:)])
    {
        [self.delegate HTTPConnectionProcessor:self didReceiveResponseBodyData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPConnectionProcessor:didSendRequestBodyData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPConnectionProcessor:self didSendRequestBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

@end
