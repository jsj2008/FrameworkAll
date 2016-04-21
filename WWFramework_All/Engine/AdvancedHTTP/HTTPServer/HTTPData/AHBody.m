//
//  AHBody.m
//  Application
//
//  Created by WW on 14-3-11.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "AHBody.h"
#import "DataInputStream.h"

@implementation AHBody

- (InputStream *)bodyInputStream
{
    return nil;
}

@end


@implementation AHDataBody

- (InputStream *)bodyInputStream
{
    return [[DataInputStream alloc] initWithData:self.data];
}

@end


@implementation AHStreamBody

- (InputStream *)bodyInputStream
{
    return self.stream;
}

@end
