//
//  UFDataPickInputer.m
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPickInputer.h"

@interface UFDataPickInputer () <UFInputToolBarDelegate>
{
    UFDataPicker *_dataPicker;
    
    UFInputToolBar *_inputToolBar;
}

@end


@implementation UFDataPickInputer

@synthesize dataPicker = _dataPicker;

@synthesize inputToolBar = _inputToolBar;

- (instancetype)initWithDataPicker:(UFDataPicker *)dataPicker inputToolBar:(UFInputToolBar *)inputToolBar
{
    if (self = [super init])
    {
        _dataPicker = dataPicker;
        
        _inputToolBar = inputToolBar;
        
        _inputToolBar.delegate = self;
    }
    
    return self;
}

- (void)setIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    [self.dataPicker setIndexes:indexes animated:animated];
}

- (void)inputToolBarDidConfirm:(UFInputToolBar *)toolBar
{    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickInputer:didSelectIndexes:)])
    {
        [self.delegate dataPickInputer:self didSelectIndexes:[self.dataPicker currentIndexes]];
    }
}

- (void)inputToolBarDidCancel:(UFInputToolBar *)toolBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickInputerDidCancel:)])
    {
        [self.delegate dataPickInputerDidCancel:self];
    }
}

@end
