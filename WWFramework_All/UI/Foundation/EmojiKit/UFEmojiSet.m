//
//  UFEmojiSet.m
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFEmojiSet.h"

@interface UFEmojiSet ()

@property (nonatomic) NSDictionary<NSString *,UFEmoji *> *emojiDictionary;

@end


@implementation UFEmojiSet

- (instancetype)initWithEmojiDictionary:(NSDictionary<NSString *,UFEmoji *> *)emojiDictionary
{
    if (self = [super init])
    {
        self.emojiDictionary = emojiDictionary;
    }
    
    return self;
}

- (UFEmoji *)emojiForKey:(NSString *)key
{
    return [self.emojiDictionary objectForKey:key];
}

@end
