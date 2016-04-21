//
//  AHServerTransaction.m
//  Application
//
//  Created by WW on 14-3-12.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHServerTransaction.h"

@implementation AHServerTransaction

- (void)cancel
{

}

- (void)didReceiveRequestHeader:(AHRequestHeader *)requestHeader
{
    [self continueReceivingRequest:YES];
}

- (void)didReceiveRequestBodyData:(NSData *)data
{
    [self continueReceivingRequest:YES];
}

- (void)didReceiveRequestTrailer:(NSDictionary *)trailer
{
    [self continueReceivingRequest:YES];
}

- (void)didFinishReceivingRequestWithCode:(AHServerCode)code
{
    [self continueReceivingRequest:YES];
    
    AHResponseHeader *header = [[AHResponseHeader alloc] init];
    
    header.version = AHVersion_1_1;
    
    header.statusCode = 500;
    
    header.statusDescription = @"Internal Server Error";
    
    AHResponse *response = [[AHResponse alloc] init];
    
    response.header = header;
    
    [self sendResponse:response];
}

- (void)continueReceivingRequest:(BOOL)continueReceiving
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransaction:canReceiveData:)])
    {
        [self.delegate AHServerTransaction:self canReceiveData:continueReceiving];
    }
}

- (void)sendResponse:(AHResponse *)response
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransaction:sendResponse:)])
    {
        [self.delegate AHServerTransaction:self sendResponse:response];
    }
}

- (void)didSendResponseHeader
{
    
}

- (void)didSendResponseBodySize:(unsigned long long)size
{
    
}

- (void)didFinishSendingResponseWithCode:(AHServerCode)code
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AHServerTransaction:didFinishAndWillCloseConnection:)])
    {
        [self.delegate AHServerTransaction:self didFinishAndWillCloseConnection:NO];
    }
}

@end
