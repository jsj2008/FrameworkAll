//
//  HTTPDigestAuthentication.m
//  Application
//
//  Created by Baymax on 14-2-24.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "HTTPDigestAuthentication.h"
#import "NSString+CharacterHandle.h"
#import "MD5Cryptor.h"
#import "Base64Cryptor.h"
#import "HTTPRequest.h"
#import "HTTPResponse.h"
#import "DataOutputStream.h"
#import "StringComponent.h"

@interface HTTPDigestAuthentication ()

/*!
 * @brief 请求的URI
 * @param request1 请求
 * @result URI
 */
- (NSString *)authenticationURIOfRequest:(HTTPRequest *)request1;

- (NSString *)authorizationValueForAuthenticateString:(NSString *)authenticateString ofAccount:(HTTPAccount *)account;

/*!
 * @brief 当前nonce
 */
@property (nonatomic, copy) NSString *currentNonce;

/*!
 * @brief 当前nc
 */
@property (nonatomic, copy) NSString *currentNc;

/*!
 * @brief 当前cnonce
 */
@property (nonatomic, copy) NSString *currentcnonce;

/*!
 * @brief 当前HA1
 */
@property (nonatomic, copy) NSString *currentHA1;

/*!
 * @brief 当前qop
 */
@property (nonatomic, copy) NSString *currentQop;

@end


@implementation HTTPDigestAuthentication

- (NSDictionary<NSString *,NSString *> *)authenticationHeaderFieldsToChallengeURLResponse:(NSHTTPURLResponse *)URLResponse
{
    if (!self.authenticationAccount)
    {
        return nil;
    }
    
    // 摘要认证不允许同时进行基础认证和代理认证，通常基础认证和代理认证不会同时存在（HTTP响应状态码不同）
    
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
                
                break;
            }
        }
    }
    else
    {
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
                    
                    break;
                }
            }
        }
    }
    
    return [authenticationHeaderFields count] ? authenticationHeaderFields : nil;
}

- (NSString *)authorizationValueForAuthenticateString:(NSString *)authenticateString ofAccount:(HTTPAccount *)account
{
    NSString *authenticationValue = nil;
    
    if ([authenticateString hasPrefix:@"Digest "])
    {
        NSDictionary *parameters = nil;
        
        NSArray *initialComponents = [authenticateString componentsSeparatedByString:@" "];
        
        if ([initialComponents count] == 2)
        {
            NSString *parameterString = [initialComponents objectAtIndex:1];
            
            parameters = [parameterString KVedComponentsBySeparator:@","];
        }
        
        NSString *realm = [[parameters objectForKey:@"realm"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
        
        NSString *nonce = [[parameters objectForKey:@"nonce"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
        
        self.currentNonce = nonce;
        
        NSString *qop = [[parameters objectForKey:@"qop"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
        
        NSArray *qops = [qop componentsSeparatedByString:@","];
        
        NSString *algorithm = [[parameters objectForKey:@"algorithm"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
        
        NSString *opaque = [[parameters objectForKey:@"opaque"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
        
        NSString *cnonce = [[@"123" uppercaseMD5EncodedString] base64EncodedString];
        
        self.currentcnonce = cnonce;
        
        NSString *nc = @"00000001";
        
        self.currentNc = nc;
        
        NSString *URI = [self authenticationURIOfRequest:self.request];
        
        NSString *response = nil;
        
        NSString *A1 = [NSString stringWithFormat:@"%@:%@:%@", account.accountId, [[parameters objectForKey:@"realm"] stringByDeletingBothPrefixAndSuffixQuotationMarks], account.password];
        
        NSString *usingAlgorithm = @"MD5";
        
        if ([algorithm isEqualToString:@"MD5-sess"])
        {
            A1 = [NSString stringWithFormat:@"%@:%@:%@", [A1 uppercaseMD5EncodedString], nonce, cnonce];
            
            usingAlgorithm = @"MD5-sess";
        }
        
        NSString *HA1= [A1 uppercaseMD5EncodedString];
        
        self.currentHA1 = HA1;
        
        NSString *usingQop = nil;
        
        if ([qops containsObject:@"auth-int"])
        {
            NSString *A2 = [NSString stringWithFormat:@"%@:%@", self.request.method, URI];
            
            if (self.request.bodyStream)
            {
                [self.request.bodyStream resetInput];
                
                A2 = [NSString stringWithFormat:@"%@:%@", A2, [self.request.bodyStream uppercaseMD5EncodedString]];
            }
            
            NSString *HA2 = [A2 uppercaseMD5EncodedString];
            
            response = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@", HA1, nonce, nc, cnonce, @"auth-int", HA2] uppercaseMD5EncodedString];
            
            usingQop = @"auth-int";
        }
        else if ([qops containsObject:@"auth"])
        {
            NSString *A2 = [NSString stringWithFormat:@"%@:%@", self.request.method, URI];
            
            NSString *HA2 = [A2 uppercaseMD5EncodedString];
            
            response = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@", HA1, nonce, nc, cnonce, @"auth", HA2] uppercaseMD5EncodedString];
            
            usingQop = @"auth";
        }
        else
        {
            NSString *A2 = [NSString stringWithFormat:@"%@:%@", self.request.method, URI];
            
            NSString *HA2 = [A2 uppercaseMD5EncodedString];
            
            response = [[NSString stringWithFormat:@"%@:%@:%@", HA1, nonce, HA2] uppercaseMD5EncodedString];
        }
        
        self.currentQop = usingQop;
        
        NSMutableDictionary *valueDictionary = [NSMutableDictionary dictionary];
        
        [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", account.accountId] forKey:@"username"];
        
        [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", realm] forKey:@"realm"];
        
        [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", nonce] forKey:@"nonce"];
        
        [valueDictionary setObject:URI forKey:@"uri"];
        
        [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", response] forKey:@"response"];
        
        if (usingAlgorithm)
        {
            [valueDictionary setObject:usingAlgorithm forKey:@"algorithm"];
        }
        
        if (opaque)
        {
            [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", opaque] forKey:@"opaque"];
        }
        
        if (cnonce && usingQop)
        {
            [valueDictionary setObject:[NSString stringWithFormat:@"\"%@\"", cnonce] forKey:@"cnonce"];
        }
        
        if (usingQop)
        {
            [valueDictionary setObject:usingQop forKey:@"qop"];
        }
        
        if (nc && usingQop)
        {
            [valueDictionary setObject:nc forKey:@"nc"];
        }
        
        NSMutableDictionary *extensionParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        [extensionParameters removeObjectForKey:@"realm"];
        
        [extensionParameters removeObjectForKey:@"nonce"];
        
        [extensionParameters removeObjectForKey:@"domain"];
        
        [extensionParameters removeObjectForKey:@"opaque"];
        
        [extensionParameters removeObjectForKey:@"stale"];
        
        [extensionParameters removeObjectForKey:@"algorithm"];
        
        [extensionParameters removeObjectForKey:@"qop"];
        
        [valueDictionary addEntriesFromDictionary:extensionParameters];
        
        authenticationValue = [valueDictionary KVedStringBySeparator:@","];
    }
    
    return authenticationValue;
}

- (NSString *)authenticationURIOfRequest:(HTTPRequest *)request1
{
    NSURL *URL = request1.URL;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];
    
    components.scheme = nil;
    
    components.host = nil;
    
    components.port = nil;
    
    components.user = nil;
    
    components.password = nil;
    
    return [[components URL] absoluteString];
}

- (BOOL)canResponsePassLocalAuthencation:(HTTPResponse *)response
{
    BOOL can = YES;
    
    if (self.authenticationAccount && [self.currentQop isEqualToString:@"auth"])
    {
        NSString *authenticationInfoString = [[response.URLResponse allHeaderFields] objectForKey:@"Authentication-Info"];
        
        if (authenticationInfoString)
        {
            NSDictionary *parameters= [authenticationInfoString KVedComponentsBySeparator:@","];
            
            NSString *rspauth = [[parameters objectForKey:@"rspauth"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
            
            NSString *cnonce = [[parameters objectForKey:@"cnonce"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
            
            NSString *nc = [[parameters objectForKey:@"nc"] stringByDeletingBothPrefixAndSuffixQuotationMarks];
            
            if (rspauth && [cnonce isEqualToString:self.currentcnonce] && [nc isEqualToString:self.currentNc])
            {
                NSString *qop = [parameters objectForKey:@"qop"];
                
                if ([qop isEqualToString:self.currentQop])
                {
                    NSString *responseString = nil;
                    
                    NSString *HA1 = self.currentHA1;
                    
                    NSString *URI = [self authenticationURIOfRequest:self.request];
                    
                    NSString *A2 = URI;
                    
                    NSString *HA2 = [A2 uppercaseMD5EncodedString];
                    
                    responseString = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@", HA1, self.currentNonce, self.currentNc, self.currentcnonce, @"auth", HA2] uppercaseMD5EncodedString];
                    
                    can = [responseString isEqualToString:rspauth];
                }
            }
        }
    }
    
    return can;
}

@end
