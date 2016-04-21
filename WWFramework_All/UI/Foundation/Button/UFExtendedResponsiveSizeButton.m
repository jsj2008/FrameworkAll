//
//  UFExtendedResponsiveSizeButton.m
//  Test
//
//  Created by ww on 16/3/18.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFExtendedResponsiveSizeButton.h"

@implementation UFExtendedResponsiveSizeButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL response = NO;
    
    CGFloat x = self.responsiveSizeEdgeInsets.left;
    
    CGFloat y = self.responsiveSizeEdgeInsets.top;
    
    CGFloat xwidth = self.frame.size.width - self.responsiveSizeEdgeInsets.right;
    
    CGFloat yheight = self.frame.size.height - self.responsiveSizeEdgeInsets.bottom;
    
    if (point.x >= x && point.x <= xwidth && point.y >= y && point.y <= yheight)
    {
        response = YES;
    }
    
    return response;
}

@end
