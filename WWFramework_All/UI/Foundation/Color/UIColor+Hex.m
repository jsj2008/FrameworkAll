//
//  UIColor+Hex.m
//  WWFramework_All
//
//  Created by ww on 15/12/17.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexRGB:(NSUInteger)hexRGB alpha:(CGFloat)alpha
{
    NSUInteger hexColor = hexRGB;
    
    NSUInteger bColor = hexColor & 0xff;
    
    NSUInteger gColor = (hexColor >>= 8) & 0xff;
    
    NSUInteger rColor = (hexColor >>= 8) & 0xff;
    
    return [UIColor colorWithRed:rColor / 255.0 green:gColor / 255.0 blue:bColor / 255.0 alpha:alpha];
}

@end
