//
//  HTTPTransactionCode.h
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @enum
        HTTPTransactionCode
 
    @abstract
        HTTP事务码
 
 *********************************************************/


typedef enum
{
    HTTPTransactionCode_Unknown                            = -1,
    
    HTTPTransactionCode_OK                                 = 0,   // 成功
    
    HTTPTransactionCode_Cancel                             = 1,
    
    HTTPTransactionCode_TimeOut                            = 2,   // 超时
    HTTPTransactionCode_HTTPServiceUnavailable             = 3,   // 框架网络服务不可用
    
    HTTPTransactionCode_BadURL                             = 11,
    HTTPTransactionCode_UnsupportedURL                     = 12,
    HTTPTransactionCode_CannotFindHost                     = 13,
    HTTPTransactionCode_CannotConnectToHost                = 14,
    HTTPTransactionCode_NetworkConnectionLost              = 15,
    HTTPTransactionCode_DNSLookupFailed                    = 16,
    HTTPTransactionCode_HTTPTooManyRedirects               = 17,
    HTTPTransactionCode_ResourceUnavailable                = 18,
    HTTPTransactionCode_NotConnectedToInternet             = 19,
    HTTPTransactionCode_RedirectToNonExistentLocation      = 20,
    HTTPTransactionCode_BadServerResponse                  = 21,
    HTTPTransactionCode_UserCancelledAuthentication        = 22,
    HTTPTransactionCode_UserAuthenticationRequired         = 23,
    HTTPTransactionCode_ZeroByteResource                   = 24,
    HTTPTransactionCode_CannotDecodeRawData                = 25,
    HTTPTransactionCode_CannotDecodeContentData            = 26,
    HTTPTransactionCode_CannotParseResponse                = 27,
    HTTPTransactionCode_FileDoesNotExist                   = 28,
    HTTPTransactionCode_FileIsDirectory                    = 29,
    HTTPTransactionCode_NoPermissionsToReadFile            = 30,
    HTTPTransactionCode_DataLengthExceedsMaximum           = 31,
    
    // SSL errors
    HTTPTransactionCode_SecureConnectionFailed             = 41,
    HTTPTransactionCode_ServerCertificateHasBadDate        = 42,
    HTTPTransactionCode_ServerCertificateUntrusted         = 43,
    HTTPTransactionCode_ServerCertificateHasUnknownRoot    = 44,
    HTTPTransactionCode_ServerCertificateNotYetValid       = 45,
    HTTPTransactionCode_ClientCertificateRejected          = 46,
    HTTPTransactionCode_ClientCertificateRequired          = 47,
    HTTPTransactionCode_CannotLoadFromNetwork              = 48,
    
    // Download and file I/O errors
    HTTPTransactionCode_CannotCreateFile                   = 51,
    HTTPTransactionCode_CannotOpenFile                     = 52,
    HTTPTransactionCode_CannotCloseFile                    = 53,
    HTTPTransactionCode_CannotWriteToFile                  = 54,
    HTTPTransactionCode_CannotRemoveFile                   = 55,
    HTTPTransactionCode_CannotMoveFile                     = 56,
    HTTPTransactionCode_DownloadDecodingFailedMidStream    = 57,
    HTTPTransactionCode_DownloadDecodingFailedToComplete   = 58,
    
    HTTPTransactionCode_InternationalRoamingOff            = 61,
    HTTPTransactionCode_CallIsActive                       = 62,
    HTTPTransactionCode_DataNotAllowed                     = 63,
    HTTPTransactionCode_RequestBodyStreamExhausted         = 64,
}HTTPTransactionCode;


/*********************************************************
 
    @category
        NSError (HTTPTransactionCode)
 
    @abstract
        NSError的扩展，封装对HTTP事务码的处理
 
 *********************************************************/

@interface NSError (HTTPTransactionCode)

/*!
 * @brief 将NSURL中的错误对象转换成HTTP事务码
 * @result HTTP事务码
 */
- (HTTPTransactionCode)HTTPTransactionCodeFromNSURLConnectionError;

@end
