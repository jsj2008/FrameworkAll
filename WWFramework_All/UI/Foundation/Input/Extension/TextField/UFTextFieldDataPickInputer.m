//
//  UFTextFieldDataPickInputer.m
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFTextFieldDataPickInputer.h"
#import "UFDataPickInputer.h"

@interface UFTextFieldDataPickInputer () <UFDataPickInputerDelegate>
{
    UITextField *_textField;
    
    UFDataPickSource *_dataPickSource;
    
    UFInputToolBar *_inputToolBar;
}

@property (nonatomic) UFDataPickInputer *inputer;

@property (nonatomic) NSArray *originalIndexes;

- (void)didReceiveTextFieldDidBeginEditingNotification:(NSNotification *)notification;

@end


@implementation UFTextFieldDataPickInputer

@synthesize textField = _textField;

@synthesize dataPickSource = _dataPickSource;

@synthesize inputToolBar = _inputToolBar;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTextField:(UITextField *)textField dataPickSouce:(UFDataPickSource *)dataPickSouce inputToolBar:(UFInputToolBar *)inputToolBar
{
    if (self = [super init])
    {
        _textField = textField;
        
        _dataPickSource = dataPickSouce;
        
        _inputToolBar = inputToolBar;
                
        UFDataPicker *picker = [[UFDataPicker alloc] initWithDataSource:dataPickSouce];
        
        self.inputer = [[UFDataPickInputer alloc] initWithDataPicker:picker inputToolBar:inputToolBar];
        
        self.inputer.delegate = self;
        
        textField.inputView = picker.pickerView;
        
        textField.inputAccessoryView = inputToolBar;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    }
    
    return self;
}

- (void)setIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    [self.inputer setIndexes:indexes animated:animated];
}

- (NSArray *)titlesAtIndexes:(NSArray *)indexes
{
    return [self.dataPickSource titlesAtIndexes:indexes];
}

- (void)dataPickInputer:(UFDataPickInputer *)inputer didSelectIndexes:(NSArray *)indexes
{
    [self.textField endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDataPickInputer:didSelectIndexes:)])
    {
        [self.delegate textFieldDataPickInputer:self didSelectIndexes:indexes];
    }
}

- (void)dataPickInputerDidCancel:(UFDataPickInputer *)inputer
{
    [self.textField endEditing:YES];
    
    [self.inputer setIndexes:self.originalIndexes animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDataPickInputerDidCancel:)])
    {
        [self.delegate textFieldDataPickInputerDidCancel:self];
    }
}

- (void)didReceiveTextFieldDidBeginEditingNotification:(NSNotification *)notification
{
    if ([self.textField isFirstResponder])
    {
        self.originalIndexes = [self.inputer.dataPicker currentIndexes];
    }
}

@end
