//
//  NotificationBlockLoader.m
//  FoundationProject
//
//  Created by user on 13-11-7.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "NotificationBlockLoader.h"

@interface NotificationBlockLoader ()
{
    // 承载的代码块
    void (^_block)(id);
}

@property (nonatomic, weak) id observer;

@end


@implementation NotificationBlockLoader

- (id)initWithBlock:(void (^)(id))block observer:(id)observer
{
    if (self = [super init])
    {
        _block = [block copy];
        
        self.observer = observer;
    }
    
    return self;
}

- (void)exeBlock
{
    if (_block)
    {
        _block(self.observer);
    }
}

@end
