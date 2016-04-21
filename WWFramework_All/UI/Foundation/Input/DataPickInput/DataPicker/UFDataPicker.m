//
//  UFDataPicker.m
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPicker.h"

@interface UFDataPicker () <UFDataPickSourceDelegate>
{
    UFDataPickSource *_dataSource;
    
    UIPickerView *_pickerView;
}

@end


@implementation UFDataPicker

@synthesize dataSource = _dataSource;

@synthesize pickerView = _pickerView;

- (instancetype)initWithDataSource:(UFDataPickSource *)dataSource
{
    if (self = [super init])
    {
        _pickerView = [[UIPickerView alloc] init];
        
        _pickerView.delegate = self;
        
        _pickerView.dataSource = self;
        
        _dataSource = dataSource;
        
        _dataSource.delegate = self;
    }
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataSource numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource numberOfRowsInComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSource titleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component < [self.dataSource numberOfComponents] - 1)
    {
        [pickerView reloadComponent:component + 1];
    }
}

- (NSInteger)dataPickSource:(UFDataPickSource *)source selectedRowInComponent:(NSInteger)component
{
    return [self.pickerView selectedRowInComponent:component];
}

- (void)setIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    for (int i = 0; i < [indexes count]; i ++)
    {
        NSNumber *index = [indexes objectAtIndex:i];
        
        [self.pickerView selectRow:[index integerValue] inComponent:i animated:animated];
    }
}

- (NSArray *)currentIndexes
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.pickerView numberOfComponents]; i ++)
    {
        NSInteger row = [self.pickerView selectedRowInComponent:i];
        
        [indexes addObject:[NSNumber numberWithInteger:row]];
    }
    
    return ([indexes count] > 0) ? indexes : nil;
}

@end
