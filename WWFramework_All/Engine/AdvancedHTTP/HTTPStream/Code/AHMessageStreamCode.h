//
//  AHHTTPDataStreamCode.h
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AHMessageStreamCode_Unknown = -1,
    AHMessageStreamCode_Success = 0,
    AHMessageStreamCode_UnrecognizedHeader = 1,
    AHMessageStreamCode_ChunkedParsingError = 2,
    AHMessageStreamCode_UnknownLength = 3,
    AHMessageStreamCode_UnrecognizedTrailer = 4,
    AHMessageStreamCode_CompressError = 5,
    AHMessageStreamCode_DecompressError = 6
}AHMessageStreamCode;


@protocol AHMessageStreamCoding <NSObject>

- (AHMessageStreamCode)AHMessageStreamCode;

@end
