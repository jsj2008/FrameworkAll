//
//  UFEmojiText.m
//  Test
//
//  Created by ww on 15/12/25.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFEmojiText.h"
#import "UFAttributedStringEmojiUpdater.h"
#import <objc/runtime.h>

@implementation NSString (Emoji)

- (CGSize)emojiedBoundingSizeWithSize:(CGSize)size attributes:(nullable NSDictionary<NSString *,id> *)attributes fitOption:(nullable UFEmojiTextSizeFitOption *)option
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    return [attributedString emojiedBoundingSizeWithSize:size fitOption:option];
}

@end


@implementation NSAttributedString (Emoji)

- (CGSize)emojiedBoundingSizeWithSize:(CGSize)size fitOption:(UFEmojiTextSizeFitOption *)option
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[UFAttributedStringEmojiUpdater alloc] initWithAttributedString:self];
    
    emojiUpdater.pattern = option.pattern;
    
    emojiUpdater.emojiSet = option.emojiSet;
    
    emojiUpdater.enableAutoUpdate = NO;
    
    [emojiUpdater startUpdating];
    
    NSAttributedString *emojiedAttributedString = [emojiUpdater currentUsableEmojiedAttributedString];
    
    CGSize boundingSize = CGSizeZero;
    
    switch (option.sizeFitObjectType)
    {
        case UFEmojiTextSizeFitObjectType_Label:
        {
            UILabel *label = [[UILabel alloc] init];
            
            label.numberOfLines = 0;
            
            label.attributedText = emojiedAttributedString;
            
            boundingSize = [label sizeThatFits:size];
            
            break;
        }
            
        default:
            break;
    }
    
    return boundingSize;
}

@end


@implementation UFEmojiTextSizeFitOption

@end
