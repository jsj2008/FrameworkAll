//
//  DBLog.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBLog.h"

@interface DBLog ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
}

@end


@implementation DBLog

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create("DB Log", NULL);
    }
    
    return self;
}

+ (DBLog *)sharedInstance
{
    static DBLog *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[DBLog alloc] init];
        }
    });
    
    return instance;
}

- (void)openLog
{
    _open = YES;
}

- (void)closeLog
{
    _open = NO;
}

- (void)logStringWithFormat:(NSString *)format, ...
{
    if (_open)
    {
        va_list argList;
        
        va_start(argList, format);
        
        NSString *logStr = [[NSString alloc] initWithFormat:format arguments:argList];
        
        va_end(argList);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_sync(_syncQueue, ^{
                
                if (self.customLogOperation)
                {
                    self.customLogOperation(logStr);
                }
                else
                {
                    NSLog(@"%@", logStr);
                }
            });
        });
    }
}

@end
