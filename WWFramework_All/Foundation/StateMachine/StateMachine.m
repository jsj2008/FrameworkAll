//
//  StateMachine.m
//  Application
//
//  Created by WW on 14-3-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "StateMachine.h"
#import "Notifier.h"

@interface StateMachine ()
{
    BOOL _cancelled;
}

/*!
 * @brief 当前状态信息
 */
@property (nonatomic) NSDictionary *currentInfo;

/*!
 * @brief 状态机执行一步
 */
- (void)run;

@end


@implementation StateMachine

- (id)initWithStartState:(StateMachineState)startState endState:(StateMachineState)endState
{
    if (self = [super init])
    {
        _startState = startState;
        
        _endState = endState;
        
        _currentState = startState;
    }
    
    return self;
}

- (StateMachineState)currentState
{
    return _currentState;
}

- (NSDictionary *)currentStateInfo
{
    return self.currentInfo;
}

- (void)startWithStateInfo:(NSDictionary *)stateInfo
{
    _currentState = _startState;
    
    self.currentInfo = stateInfo;
    
    [self run];
}

- (void)arriveAtState:(StateMachineState)state withStateInfo:(NSDictionary *)stateInfo
{
    _currentState = state;
    
    self.currentInfo = stateInfo;
    
    [self run];
}

- (void)cancel
{
    _cancelled = YES;
}

- (void)run
{
    if (!_cancelled)
    {
        StateMachineState state = _currentState;
        
        NSDictionary *stateInfo = self.currentStateInfo;
        
        if (state == _endState)
        {
            [Notifier notify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(stateMachine:didFinishAtState:withStateInfo:)])
                {
                    [self.delegate stateMachine:self didFinishAtState:state withStateInfo:stateInfo];
                }
            }];
        }
        else
        {
            [Notifier notify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(stateMachine:didRunFromState:withStateInfo:)])
                {
                    [self.delegate stateMachine:self didRunFromState:state withStateInfo:stateInfo];
                }
            }];
        }
    }
}

@end
