//
//  UFDataPickSource.m
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPickSource.h"

@implementation UFDataPickSource

- (NSInteger)numberOfComponents
{
    return 0;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

- (NSArray *)titlesAtIndexes:(NSArray *)indexes
{
    return nil;
}

@end


@implementation UFDataPickDictionarySource

- (NSInteger)numberOfComponents
{
    return self.componentsNumber;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i <= component; i ++)
    {
        NSInteger index = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickSource:selectedRowInComponent:)])
        {
            index = [self.delegate dataPickSource:self selectedRowInComponent:i];
        }
        
        NSArray *array = [[data allValues] firstObject];
        
        number = [array count];
        
        if (number > 0)
        {
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                data = object;
            }
            else
            {
                data = nil;
                
                break;
            }
        }
    }
    
    return number;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i < component; i ++)
    {
        NSInteger index = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickSource:selectedRowInComponent:)])
        {
            index = [self.delegate dataPickSource:self selectedRowInComponent:i];
        }
        
        NSArray *array = [[data allValues] firstObject];
        
        if ([array count] > 0)
        {
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                data = object;
            }
            else
            {
                data = nil;
                
                break;
            }
        }
    }
    
    NSArray *array = [[data allValues] firstObject];
    
    if ([array count] > row)
    {
        id object = [array objectAtIndex:row];
        
        if ([object isKindOfClass:[NSString class]])
        {
            title = object;
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            title = [[(NSDictionary *)object allKeys] firstObject];
        }
    }
    
    return title;
}

- (NSArray *)titlesAtIndexes:(NSArray *)indexes
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i < [indexes count]; i ++)
    {
        NSInteger index = [[indexes objectAtIndex:i] integerValue];
        
        NSArray *array = [[data allValues] firstObject];
        
        if ([array count] > index)
        {
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSString class]])
            {
                [titles addObject:object];
                
                break;
            }
            else if ([object isKindOfClass:[NSDictionary class]])
            {
                [titles addObject:[[(NSDictionary *)object allKeys] firstObject]];
                
                data = object;
            }
            else
            {
                break;
            }
        }
    }
    
    return titles;
}

@end
