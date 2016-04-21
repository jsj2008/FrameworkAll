//
//  HTTPMultipartBodyOutputStream.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-17.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartBodyOutputStream.h"
#import "HTTPMultipartBodyTruncatingStream.h"
#import "HTTPMultipartFragmentEntityOutputStream.h"

@interface HTTPMultipartBodyOutputStream ()
{
    // 分隔符
    NSString *_boundary;
    
    // 解析到的片段数据
    NSMutableArray *_fragments;
}

/*!
 * @brief 解析出的表单数据
 */
@property (nonatomic) HTTPMultipartBody *multipartOutput;

/*!
 * @brief 截断流，用于分割表单片段
 */
@property (nonatomic) HTTPMultipartBodyTruncatingStream *truncatingStream;

/*!
 * @brief 片段输出流，用于将片段的字节流解析成片段数据对象
 */
@property (nonatomic) HTTPMultipartFragmentEntityOutputStream *fragmentOutputStream;

@end


@implementation HTTPMultipartBodyOutputStream

- (id)initWithBoundary:(NSString *)boundary
{
    if (self = [super init])
    {
        _boundary = [boundary copy];
        
        _fragments = [[NSMutableArray alloc] init];
        
        self.truncatingStream = [[HTTPMultipartBodyTruncatingStream alloc] initWithBoundary:_boundary];
        
        self.configurationContext = [[HTTPMultipartOutputStreamConfigurationContext alloc] init];
    }
    
    return self;
}

- (void)writeData:(NSData *)data
{
    if ([data length])
    {
        if (!_isOverFlowed)
        {
            [self.truncatingStream writeData:data];
            
            HTTPMultipartBodyTruncateStatus truncateStatus = [self.truncatingStream truncatingStatus];
            
            if (truncateStatus == HTTPMultipartBodyTruncateStatus_Fragment || truncateStatus == HTTPMultipartBodyTruncateStatus_End)
            {
                NSArray *truncatedDatas = [self.truncatingStream truncatedFragmentDatas];
                
                for (HTTPMultipartBodyTruncatedFragmentData *truncatedData in truncatedDatas)
                {
                    if (!self.fragmentOutputStream)
                    {
                        self.fragmentOutputStream = [[HTTPMultipartFragmentEntityOutputStream alloc] init];
                        
                        self.fragmentOutputStream.configurationContext = self.configurationContext;
                    }
                    
                    if ([truncatedData.data length])
                    {
                        [self.fragmentOutputStream writeData:truncatedData.data];
                    }
                    
                    if (truncatedData.isComplete)
                    {
                        HTTPMultipartFragment *fragment = [self.fragmentOutputStream fragment];
                        
                        if (fragment)
                        {
                            [_fragments addObject:fragment];
                        }
                        
                        self.fragmentOutputStream = nil;
                    }
                }
            }
            
            [self.truncatingStream cleanTruncatedFragmentDatas];
            
            if (truncateStatus == HTTPMultipartBodyTruncateStatus_End)
            {
                NSData *untruncatedData = [self.truncatingStream untruncatedData];
                
                if ([untruncatedData length])
                {
                    [_buffer appendData:untruncatedData];
                    
                    _isOverFlowed = YES;
                }
                
                self.truncatingStream = nil;
                
                self.multipartOutput = [[HTTPMultipartBody alloc] initWithBoundary:_boundary fragments:_fragments];
            }
        }
        else
        {
            [_buffer appendData:data];
        }
    }
}

- (HTTPMultipartBody *)multipartBody
{
    return self.multipartOutput;
}

@end
