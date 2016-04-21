//
//  HTTPMultipartExtensionData.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-21.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "HTTPMultipartExtensionData.h"

@implementation HTTPMultipartContentDisposition

- (id)initWithHeaderFieldValue:(NSString *)value
{
    if (self = [super init])
    {
        NSArray *valueComponents = [value componentsSeparatedByString:@";"];
        
        NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
        
        for (NSString *valueComponent in valueComponents)
        {
            NSArray *components = [valueComponent componentsSeparatedByString:@"="];
            
            if ([components count] == 1)
            {
                if (!self.type)
                {
                    self.type = [components objectAtIndex:0];
                }
            }
            else if ([components count] >= 2)
            {
                NSString *componentKey = [components objectAtIndex:0];
                
                NSUInteger componentValueLocation = [componentKey length] + 1;
                
                if ([componentKey length] + 3 <= [valueComponent length])
                {
                    if ([[valueComponent substringWithRange:NSMakeRange(componentValueLocation, 1)] isEqualToString:@"\""] && [[valueComponent substringWithRange:NSMakeRange([valueComponent length] - 1, 1)] isEqualToString:@"\""])
                    {
                        componentValueLocation ++;
                        
                        NSString *componentValue = [valueComponent substringWithRange:NSMakeRange(componentValueLocation, [valueComponent length] - [componentKey length] - 3)];
                        
                        [allParameters setObject:componentValue forKey:componentKey];
                    }
                }
            }
        }
        
        if ([allParameters count])
        {
            self.parameters = allParameters;
        }
    }
    
    return self;
}

@end
