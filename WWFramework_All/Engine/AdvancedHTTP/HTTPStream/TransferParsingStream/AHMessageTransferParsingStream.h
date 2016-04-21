//
//  AHHTTPDataOutputStream.h
//  Application
//
//  Created by WW on 14-4-21.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "BufferOutputStream.h"
#import "AHMessageTransferParsingStreamOutput.h"
#import "AHMessageStreamCode.h"

@interface AHMessageTransferParsingStream : OverFlowableOutputStream <AHMessageStreamCoding>

- (id)initWithRequestOrResponseType:(BOOL)requestType;

- (NSArray *)outputs;

- (void)cleanOutputs;

- (AHMessageTransferParsingStreamOutput *)firstOutputByRemovingItFromOutupts;

@end
