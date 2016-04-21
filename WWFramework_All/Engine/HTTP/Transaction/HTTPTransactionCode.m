//
//  HTTPTransactionCode.m
//  FoundationProject
//
//  Created by Baymax on 14-2-12.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPTransactionCode.h"

@implementation NSError (HTTPTransactionCode)

- (HTTPTransactionCode)HTTPTransactionCodeFromNSURLConnectionError
{
    HTTPTransactionCode transactionCode = HTTPTransactionCode_Unknown;
    
    NSInteger connectionCode = [self code];
    
    switch (connectionCode)
    {
        case NSURLErrorUnknown:
            transactionCode = HTTPTransactionCode_Unknown;
            break;
        case 0:
            transactionCode = HTTPTransactionCode_OK;
            break;
        case NSURLErrorCancelled:
            transactionCode = HTTPTransactionCode_Cancel;
            break;
        case NSURLErrorBadURL:
            transactionCode = HTTPTransactionCode_BadURL;
            break;
        case NSURLErrorTimedOut:
            transactionCode = HTTPTransactionCode_TimeOut;
            break;
        case NSURLErrorUnsupportedURL:
            transactionCode = HTTPTransactionCode_UnsupportedURL;
            break;
        case NSURLErrorCannotFindHost:
            transactionCode = HTTPTransactionCode_CannotFindHost;
            break;
        case NSURLErrorCannotConnectToHost:
            transactionCode = HTTPTransactionCode_CannotConnectToHost;
            break;
        case NSURLErrorNetworkConnectionLost:
            transactionCode = HTTPTransactionCode_NetworkConnectionLost;
            break;
        case NSURLErrorDNSLookupFailed:
            transactionCode = HTTPTransactionCode_DNSLookupFailed;
            break;
        case NSURLErrorHTTPTooManyRedirects:
            transactionCode = HTTPTransactionCode_HTTPTooManyRedirects;
            break;
        case NSURLErrorResourceUnavailable:
            transactionCode = HTTPTransactionCode_ResourceUnavailable;
            break;
        case NSURLErrorNotConnectedToInternet:
            transactionCode = HTTPTransactionCode_NotConnectedToInternet;
            break;
        case NSURLErrorRedirectToNonExistentLocation:
            transactionCode = HTTPTransactionCode_RedirectToNonExistentLocation;
            break;
        case NSURLErrorBadServerResponse:
            transactionCode = HTTPTransactionCode_BadServerResponse;
            break;
        case NSURLErrorUserCancelledAuthentication:
            transactionCode = HTTPTransactionCode_UserCancelledAuthentication;
            break;
        case NSURLErrorUserAuthenticationRequired:
            transactionCode = HTTPTransactionCode_UserAuthenticationRequired;
            break;
        case NSURLErrorZeroByteResource:
            transactionCode = HTTPTransactionCode_ZeroByteResource;
            break;
        case NSURLErrorCannotDecodeRawData:
            transactionCode = HTTPTransactionCode_CannotDecodeRawData;
            break;
        case NSURLErrorCannotDecodeContentData:
            transactionCode = HTTPTransactionCode_CannotDecodeContentData;
            break;
        case NSURLErrorCannotParseResponse:
            transactionCode = HTTPTransactionCode_CannotParseResponse;
            break;
        case NSURLErrorFileDoesNotExist:
            transactionCode = HTTPTransactionCode_FileDoesNotExist;
            break;
        case NSURLErrorFileIsDirectory:
            transactionCode = HTTPTransactionCode_FileIsDirectory;
            break;
        case NSURLErrorNoPermissionsToReadFile:
            transactionCode = HTTPTransactionCode_NoPermissionsToReadFile;
            break;
        case NSURLErrorDataLengthExceedsMaximum:
            transactionCode = HTTPTransactionCode_DataLengthExceedsMaximum;
            break;
        case NSURLErrorSecureConnectionFailed:
            transactionCode = HTTPTransactionCode_SecureConnectionFailed;
            break;
        case NSURLErrorServerCertificateHasBadDate:
            transactionCode = HTTPTransactionCode_ServerCertificateHasBadDate;
            break;
        case NSURLErrorServerCertificateHasUnknownRoot:
            transactionCode = HTTPTransactionCode_ServerCertificateHasUnknownRoot;
            break;
        case NSURLErrorServerCertificateNotYetValid:
            transactionCode = HTTPTransactionCode_ServerCertificateNotYetValid;
            break;
        case NSURLErrorClientCertificateRejected:
            transactionCode = HTTPTransactionCode_ClientCertificateRejected;
            break;
        case NSURLErrorClientCertificateRequired:
            transactionCode = HTTPTransactionCode_ClientCertificateRequired;
            break;
        case NSURLErrorCannotLoadFromNetwork:
            transactionCode = HTTPTransactionCode_CannotLoadFromNetwork;
            break;
        case NSURLErrorCannotCreateFile:
            transactionCode = HTTPTransactionCode_CannotCreateFile;
            break;
        case NSURLErrorCannotOpenFile:
            transactionCode = HTTPTransactionCode_CannotOpenFile;
            break;
        case NSURLErrorCannotCloseFile:
            transactionCode = HTTPTransactionCode_CannotCloseFile;
            break;
        case NSURLErrorCannotWriteToFile:
            transactionCode = HTTPTransactionCode_CannotWriteToFile;
            break;
        case NSURLErrorCannotRemoveFile:
            transactionCode = HTTPTransactionCode_CannotRemoveFile;
            break;
        case NSURLErrorCannotMoveFile:
            transactionCode = HTTPTransactionCode_CannotMoveFile;
            break;
        case NSURLErrorDownloadDecodingFailedMidStream:
            transactionCode = HTTPTransactionCode_DownloadDecodingFailedMidStream;
            break;
        case NSURLErrorDownloadDecodingFailedToComplete:
            transactionCode = HTTPTransactionCode_DownloadDecodingFailedToComplete;
            break;
        case NSURLErrorInternationalRoamingOff:
            transactionCode = HTTPTransactionCode_InternationalRoamingOff;
            break;
        case NSURLErrorCallIsActive:
            transactionCode = HTTPTransactionCode_CallIsActive;
            break;
        case NSURLErrorDataNotAllowed:
            transactionCode = HTTPTransactionCode_DataNotAllowed;
            break;
        case NSURLErrorRequestBodyStreamExhausted:
            transactionCode = HTTPTransactionCode_RequestBodyStreamExhausted;
            break;
        default:
            break;
    }
    
    return transactionCode;
}

@end
