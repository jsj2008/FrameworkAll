//
//  StateMachine.h
//  Application
//
//  Created by WW on 14-3-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned int StateMachineState;

@protocol StateMachineDelegate;


/*********************************************************
 
    @class
        StateMachine
 
    @abstract
        状态机
 
    @discussion
        实现状态转移的具体操作，应当由delegate对象实现，StateMachine仅提供一个状态机运转的框架
 
 *********************************************************/

@interface StateMachine : NSObject
{
    // 初始状态
    StateMachineState _startState;
    
    // 结束状态
    StateMachineState _endState;
    
    // 当前状态
    StateMachineState _currentState;
}

/*!
 * @brief 初始化
 * @param startState 初始状态
 * @param endState 结束状态
 * @result 初始化后的对象
 */
- (id)initWithStartState:(StateMachineState)startState endState:(StateMachineState)endState;

/*!
 * @brief 代理对象，实现具体的状态转移操作
 */
@property (nonatomic, weak) id<StateMachineDelegate> delegate;

/*!
 * @brief 当前状态
 * @result 当前状态
 */
- (StateMachineState)currentState;

/*!
 * @brief 当前状态信息
 * @result 当前状态信息
 */
- (NSDictionary *)currentStateInfo;

/*!
 * @brief 启动状态机
 * @discussion 启动操作只能执行一次
 * @discussion stateInfo 状态信息
 */
- (void)startWithStateInfo:(NSDictionary *)stateInfo;

/*!
 * @brief 取消状态机
 * @discussion 取消后，状态机不再发送消息
 */
- (void)cancel;

/*!
 * @brief 进入指定状态
 * @discussion 进入状态后，若为结束状态，状态机将发送结束消息，由代理对象结束状态机，若为其他状态，状态机将自动激发状态转移操作并发送转移消息
 * @param state 指定状态
 * @param stateInfo 状态信息
 */
- (void)arriveAtState:(StateMachineState)state withStateInfo:(NSDictionary *)stateInfo;

@end


/*********************************************************
 
    @protocol
        StateMachineDelegate
 
    @abstract
        状态机代理协议
 
 *********************************************************/

@protocol StateMachineDelegate <NSObject>

/*!
 * @brief 状态机转移
 * @discussion 代理对象在接收到本消息后，执行具体的状态转移操作
 * @param machine 状态机
 * @param state 状态，状态机从该状态发生转移
 * @param stateInfo 状态信息
 */
- (void)stateMachine:(StateMachine *)machine didRunFromState:(StateMachineState)state withStateInfo:(NSDictionary *)stateInfo;

/*!
 * @brief 状态机结束
 * @param machine 状态机
 * @param state 状态，状态机在该状态终止
 * @param stateInfo 状态信息
 */
- (void)stateMachine:(StateMachine *)machine didFinishAtState:(StateMachineState)state withStateInfo:(NSDictionary *)stateInfo;

@end
