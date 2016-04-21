//
//  HTTPAuthentication.m
//  Application
//
//  Created by Baymax on 14-2-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPAuthentication.h"

@implementation HTTPAuthentication

- (NSDictionary<NSString *,NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse
{
    return nil;
}

- (BOOL)canResponsePassLocalAuthencation:(HTTPResponse *)esponse
{
    return YES;
}

- (void)addAuthenticationHeaderFieldsToRequest
{
    
}

@end
