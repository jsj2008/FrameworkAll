//
//  UFEmojiImage.m
//  Test
//
//  Created by ww on 15/12/24.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFEmojiImage.h"
#import <ImageIO/ImageIO.h>

@interface UFEmojiImage ()

@property (nonatomic) NSArray *sources;

@end


@implementation UFEmojiImage

- (NSArray<UFEmojiImageSource *> *)imageSources
{
    return self.sources;
}

+ (UFEmojiImage *)emojiImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    UFEmojiImageSource *source = [[UFEmojiImageSource alloc] init];
    
    source.image = image;
    
    source.duration = 0;
    
    UFEmojiImage *emojiImage = [[UFEmojiImage alloc] init];
    
    emojiImage.sources = [NSArray arrayWithObject:source];
    
    emojiImage.updatable = NO;
    
    return emojiImage;
}

+ (UFEmojiImage *)emojiImageWithPath:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UFEmojiImageSource *source = [[UFEmojiImageSource alloc] init];
    
    source.image = image;
    
    source.duration = 0;
    
    UFEmojiImage *emojiImage = [[UFEmojiImage alloc] init];
    
    emojiImage.sources = [NSArray arrayWithObject:source];
    
    emojiImage.updatable = NO;
    
    return emojiImage;
}

+ (UFEmojiImage *)emojiImageWithGifPath:(NSString *)gifPath
{
    UFEmojiImage *emojiImage = [[UFEmojiImage alloc] init];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:gifPath];
    
    if ([data length])
    {
        NSMutableArray *sources = [[NSMutableArray alloc] init];
        
        CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
        
        size_t sourceCount = CGImageSourceGetCount(gifSource);
        
        for (size_t i = 0; i < sourceCount; i ++)
        {
            UFEmojiImageSource *source = [[UFEmojiImageSource alloc] init];
            
            CGImageRef image = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
            
            source.image = [UIImage imageWithCGImage:image];
            
            NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
            
            NSDictionary *gifProperties = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            
            NSNumber *delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            
            if (!delayTime)
            {
                delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
            }
            
            source.duration = [delayTime doubleValue];
            
            if (source.image)
            {
                [sources addObject:source];
            }
        }
        
        emojiImage.sources = sources;
        
        emojiImage.updatable = YES;
    }
    
    return emojiImage;
}

@end


@implementation UFEmojiImageSource

@end
