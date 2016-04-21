//
//  AHCCode.h
//  Application
//
//  Created by WW on 14-4-25.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHMessageStreamCode.h"

typedef enum
{
    AHCCode_Unknown = -1,
    
    AHCCode_Success = 0,
    
    AHCCode_Connection_ClosedByClient = 101,
    AHCCode_Connection_InputClosedByServer = 102,
    AHCCode_Connection_InputClosedByClient = 103,
    AHCCode_Connection_OutputClosedByServer = 104,
    AHCCode_Connection_OutputClosedByClient = 105,
    
    AHCCode_Data_UnrecognizedHeader = 201,
    AHCCode_Data_ChunkedParsingError = 202,
    AHCCode_Data_UnknownLength = 203,
    AHCCode_Data_UnrecognizedTrailer = 204,
    AHCCode_Data_CompressError = 205,
    AHCCode_Data_DecompressError = 206,
    AHCCode_Data_UnrecognizedContentEncoding = 207
    
}AHCCode;


@interface AHCCodeSwitcher : NSObject

+ (AHCCode)clientCodeOfMessageStreamCode:(AHMessageStreamCode)messageStreamCode;

@end
