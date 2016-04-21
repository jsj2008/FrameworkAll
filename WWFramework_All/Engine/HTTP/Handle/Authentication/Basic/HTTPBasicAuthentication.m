//
//  HTTPBasicAuthentication.m
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPBasicAuthentication.h"
#import "NSString+CharacterHandle.h"
#import "Base64Cryptor.h"
#import "HTTPBasicAuthenticationStorage.h"
#import "HTTPRequest.h"
#import "StringComponent.h"

@interface HTTPBasicAuthentication ()

- (NSString *)authorizationValueForAuthenticateString:(NSString *)authenticateString ofAccount:(HTTPAccount *)account;

@end


@implementation HTTPBasicAuthentication

- (NSDictionary<NSString *,NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse
{
    if (!self.authenticationAccount)
    {
        return nil;
    }
    
    // 基本认证允许同时进行基础认证和代理认证，尽管通常基础认证和代理认证不会同时存在（HTTP响应状态码不同）
    
    // 在生成认证证书的同时，存储该认证证书
    
    NSMutableDictionary *authenticationHeaderFields = [NSMutableDictionary dictionary];
    
    NSDictionary *responseHeaderFields = [URLResponse allHeaderFields];
    
    NSString *WWWAuthenticateValue = [responseHeaderFields objectForKey:@"WWW-Authenticate"];
    
    if (WWWAuthenticateValue && self.authenticationAccount.userAccount)
    {
        NSArray *components = [WWWAuthenticateValue componentsSeparatedByString:@","];
        
        for (NSString *authenticateString in components)
        {
            NSString *authorizationValue = [self authorizationValueForAuthenticateString:authenticateString ofAccount:self.authenticationAccount.userAccount];
            
            if (authorizationValue)
            {
                [authenticationHeaderFields setObject:authorizationValue forKey:@"Authorization"];
                
                HTTPBasicCreditial *creditial = [[HTTPBasicCreditial alloc] init];
                
                creditial.account = self.authenticationAccount.userAccount;
                
                creditial.host = [self.request.URL host];
                
                creditial.value = authorizationValue;
                
                creditial.authenticationHeaderField = @"WWW-Authenticate";
                
                [[HTTPBasicAuthenticationStorage sharedInstance] saveCreditial:creditial forAuthenticationHeaderField:@"WWW-Authenticate" ofHost:[self.request.URL host] account:self.authenticationAccount.userAccount];
                
                break;
            }
        }
    }
    
    NSString *proxyAuthenticateValue = [responseHeaderFields objectForKey:@"Proxy-Authenticate"];
    
    if (proxyAuthenticateValue && self.authenticationAccount.proxyUserAccount)
    {
        NSArray *components = [proxyAuthenticateValue componentsSeparatedByString:@","];
        
        for (NSString *authenticateString in components)
        {
            NSString *authorizationValue = [self authorizationValueForAuthenticateString:authenticateString ofAccount:self.authenticationAccount.proxyUserAccount];
            
            if (authorizationValue)
            {
                [authenticationHeaderFields setObject:authorizationValue forKey:@"Proxy-Authorization"];
                
                HTTPBasicCreditial *creditial = [[HTTPBasicCreditial alloc] init];
                
                creditial.account = self.authenticationAccount.proxyUserAccount;
                
                creditial.host = [self.request.URL host];
                
                creditial.value = authorizationValue;
                
                creditial.authenticationHeaderField = @"Proxy-Authenticate";
                
                [[HTTPBasicAuthenticationStorage sharedInstance] saveCreditial:creditial forAuthenticationHeaderField:@"Proxy-Authenticate" ofHost:[self.request.URL host] account:self.authenticationAccount.proxyUserAccount];
                
                break;
            }
        }
    }
    
    return [authenticationHeaderFields count] ? authenticationHeaderFields : nil;
}

- (NSString *)authorizationValueForAuthenticateString:(NSString *)authenticateString ofAccount:(HTTPAccount *)account
{
    NSString *authenticationValue = nil;
    
    if ([authenticateString hasPrefix:@"Basic "])
    {
        NSDictionary *parameters = nil;
        
        NSArray *initialComponents = [authenticateString componentsSeparatedByString:@" "];
        
        if ([initialComponents count] == 2)
        {
            NSString *parameterString = [initialComponents objectAtIndex:1];
            
            parameters = [parameterString KVedComponentsBySeparator:parameterString];
        }
        
        NSString *rawString = [NSString stringWithFormat:@"%@:%@", account.accountId, account.password];
        
        authenticationValue = [NSString stringWithFormat:@"Basic %@", [rawString base64EncodedString]];
    }
    
    return authenticationValue;
}

- (void)addAuthenticationHeaderFieldsToRequest
{
    if (!self.authenticationAccount)
    {
        return;
    }
    
    HTTPBasicCreditial *creditialForWWW = self.authenticationAccount.userAccount ? [[HTTPBasicAuthenticationStorage sharedInstance] creditialForAuthenticationHeaderField:@"WWW-Authenticate" ofHost:[self.request.URL host] account:self.authenticationAccount.userAccount] : nil;
    
    HTTPBasicCreditial *creditialForProxy = self.authenticationAccount.proxyUserAccount ? [[HTTPBasicAuthenticationStorage sharedInstance] creditialForAuthenticationHeaderField:@"Proxy-Authenticate" ofHost:[self.request.URL host] account:self.authenticationAccount.proxyUserAccount] : nil;
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    
    if (creditialForWWW.value)
    {
        [headerFields setObject:creditialForWWW.value forKey:@"WWW-Authenticate"];
    }
    
    if (creditialForProxy.value)
    {
        [headerFields setObject:creditialForProxy.value forKey:@"Proxy-Authenticate"];
    }
    
    // 这里需要先添加认证首部，再添加原始首部
    // 目的是保证当原始首部中已经包含认证信息时，仍能使用
    
    [headerFields addEntriesFromDictionary:self.request.headerFields];
    
    self.request.headerFields = headerFields;
}

@end
