//
//  HTTPLoadCode.m
//  FoundationProject
//
//  Created by Baymax on 14-2-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPLoadCode.h"

@implementation HTTPLoadCodeSwitcher

+ (HTTPLoadCode)HTTPLoadCodeOfHTTPTransactionCode:(HTTPTransactionCode)code withReferencedURLResponse:(NSHTTPURLResponse *)URLResponse
{
    HTTPLoadCode loadCode = HTTPLoadCode_Unknown;
    
    switch (code)
    {
        case HTTPTransactionCode_Unknown:
            loadCode = HTTPLoadCode_Unknown;
            break;
        case HTTPTransactionCode_OK:
        {
            if (URLResponse)
            {
                if ([URLResponse statusCode] == 200)
                {
                    loadCode = HTTPLoadCode_OK;
                }
                else if ([URLResponse statusCode] == 206)
                {
                    loadCode = HTTPLoadCode_PartialData;
                }
                else
                {
                    loadCode = HTTPLoadCode_Status;
                }
            }
            else
            {
                loadCode = HTTPLoadCode_NoData;
            }
        }
            break;
        case HTTPTransactionCode_Cancel:
            loadCode = HTTPLoadCode_Cancel;
            break;
        case HTTPTransactionCode_TimeOut:
            loadCode = HTTPLoadCode_TimeOut;
            break;
        case HTTPTransactionCode_HTTPServiceUnavailable:
            loadCode = HTTPLoadCode_HTTPServiceUnavailable;
            break;
        case HTTPTransactionCode_BadURL:
        case HTTPTransactionCode_UnsupportedURL:
            loadCode = HTTPLoadCode_URLError;
            break;
        case HTTPTransactionCode_CannotFindHost:
        case HTTPTransactionCode_CannotConnectToHost:
        case HTTPTransactionCode_NetworkConnectionLost:
        case HTTPTransactionCode_DNSLookupFailed:
        case HTTPTransactionCode_HTTPTooManyRedirects:
        case HTTPTransactionCode_ResourceUnavailable:
        case HTTPTransactionCode_NotConnectedToInternet:
        case HTTPTransactionCode_RedirectToNonExistentLocation:
        case HTTPTransactionCode_UserCancelledAuthentication:
        case HTTPTransactionCode_UserAuthenticationRequired:
            loadCode = HTTPLoadCode_ConnectFailed;
            break;
        case HTTPTransactionCode_BadServerResponse:
        case HTTPTransactionCode_ZeroByteResource:
        case HTTPTransactionCode_CannotDecodeRawData:
        case HTTPTransactionCode_CannotDecodeContentData:
        case HTTPTransactionCode_CannotParseResponse:
        case HTTPTransactionCode_FileDoesNotExist:
        case HTTPTransactionCode_FileIsDirectory:
        case HTTPTransactionCode_NoPermissionsToReadFile:
        case HTTPTransactionCode_DataLengthExceedsMaximum:
            loadCode = HTTPLoadCode_DataFailed;
            break;
        case HTTPTransactionCode_SecureConnectionFailed:
        case HTTPTransactionCode_ServerCertificateHasBadDate:
        case HTTPTransactionCode_ServerCertificateHasUnknownRoot:
        case HTTPTransactionCode_ServerCertificateNotYetValid:
        case HTTPTransactionCode_ClientCertificateRejected:
        case HTTPTransactionCode_ClientCertificateRequired:
        case HTTPTransactionCode_CannotLoadFromNetwork:
            loadCode = HTTPLoadCode_SSLFailed;
            break;
        case HTTPTransactionCode_CannotCreateFile:
        case HTTPTransactionCode_CannotOpenFile:
        case HTTPTransactionCode_CannotCloseFile:
        case HTTPTransactionCode_CannotWriteToFile:
        case HTTPTransactionCode_CannotRemoveFile:
        case HTTPTransactionCode_CannotMoveFile:
        case HTTPTransactionCode_DownloadDecodingFailedMidStream:
        case HTTPTransactionCode_DownloadDecodingFailedToComplete:
        case HTTPTransactionCode_InternationalRoamingOff:
            loadCode = HTTPLoadCode_DataFailed;
            break;
        case HTTPTransactionCode_CallIsActive:
            loadCode = HTTPLoadCode_ConnectFailed;
            break;
        case HTTPTransactionCode_DataNotAllowed:
        case HTTPTransactionCode_RequestBodyStreamExhausted:
            loadCode = HTTPLoadCode_DataFailed;
            break;
        default:
            break;
    }
    
    return loadCode;
}

@end
