//
//  PipedInputStream.m
//  Demo
//
//  Created by Baymax on 13-10-17.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "PipedInputStream.h"

@implementation PipedInputStream

- (NSData *)readDataOfMaxLength:(NSUInteger)length
{
    NSData *data = nil;
    
    if (!_over)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pipedInputStream:dataOfLength:)])
        {
            data = [self.delegate pipedInputStream:self dataOfLength:length];
        }
        
        if (![data length])
        {
            _over = YES;
        }
    }
    
    return data;
}

@end
