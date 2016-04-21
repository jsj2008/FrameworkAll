//
//  IPRouteTracer.h
//  PRIS_iPhone
//
//  Created by WW on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "IPRouteItem.h"

/*!!!!!!!!!!!!!!!!
 
 * IPRouteTracer.m文件里面引入的netinet/XXX.h在真机中运行是无法通过的，需要进行如下配置才能正确运行：
    1、将系统的netinet目录导出，存放在程序文件夹下某一目录中，本例中该目录为-应用程序/TraceRoute/SystemInclude
    2、在Targets->Build Settings->Header Search Paths中填入"$(SRCROOT)/程序名/（netinet所在子文件夹目录相对路径，本例为TraceRoute/SystemInclude）/"
 */

/**************************************************
 
    @class
        IPRouteTracer
 
    @abstract
        获取通往指定主机地址的路由信息，不支持ipv6
 
    @discussion:
        1，每次执行run方法，都将进入阻塞状态，阻塞时间上限约为TTL数*接收数据包的最大等待时间，因此需要将run方法放在独立子线程中进行
        2，run方法执行完成之后，通过routeItems方法可以得到获取到的路由信息的数组，该数组按照经过的路由顺序存放获取到的路由信息，通过isDestinationHostReached方法可以判断是否已经追踪到目标主机
        3，routeItems方法返回的数组的last object不一定指向的是host（即未追踪到目标主机），当途经的路由设备设置了过滤或拒绝trace route行为时就会出现这种情况
        4，由于run方法是阻塞的，因此提供cancel方法来停止正在执行的run方法，需要异步调用cancel方法才能实现。
 
 **************************************************/

@interface IPRouteTracer : NSObject
{
    // 目标主机
    NSString *_destinationHost;
    
    // 获取到的路由信息，成员变量是URLRouteItem对象
    NSMutableArray *_routeItems;
}

/*!
 * @brief 初始化
 * @param host 目标主机地址，可以是ip地址或域名
 * @result 初始化后的对象
 */
- (id)initWithDestinationHost:(NSString *)host;

/*!
 * @brief 获取指定host的准确ip地址
 * @param host 目标主机地址，可以是ip地址或域名
 * @result ip地址
 */
- (NSString *)ipOfHost:(NSString *)host;

/*!
 * @brief 运行，获取路由信息
 */
- (void)run;

/*!
 * @brief 取消
 * @discussion 须异步调用
 */
- (void)cancel;

/*!
 * @brief 追踪到的路由信息
 * @result 路由数组
 */
- (NSArray *)routeItems;

/*!
 * @brief 目标地址是否已达
 * @result 已达标志
 */
- (BOOL)isDestinationHostReached;

@end


/*!
 * @brief 路由追踪的最大ttl数
 */
extern NSUInteger const IPROUTETRACE_MAXTTLCOUNT;

/*!
 * @brief 路由追踪过程中接收数据包的最大等待时间，单位秒
 */
extern double const IPROUTETRACE_MAXDGRAMRECEIVINGTIME;
