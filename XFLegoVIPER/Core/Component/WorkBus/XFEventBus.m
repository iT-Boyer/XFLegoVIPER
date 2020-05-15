//
//  XFEventBus.m
//  XFLegoVIPER
//
//  Created by Yizzuide on 2016/11/3.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import "XFEventBus.h"
#import "XFComponentRoutable.h"
#import "XFLegoMarco.h"
#import "XFComponentManager.h"


@interface XFEventBus ()

/**
 *  可运行组件
 */
@property (nonatomic, weak) __kindof id<XFComponentRoutable> componentRoutable;

/**
 *  所有用侦听通知的对象
 */
@property (nonatomic, strong) NSMutableArray *observers;
/*
 * 定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XFEventBus

- (instancetype)init
{
    NSAssert(NO, @"请使用-initWithComponentRoutable来初始化！");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self initWithComponentRoutable:nil];
#pragma clang diagnostic pop
}

- (instancetype)initWithComponentRoutable:(__kindof id<XFComponentRoutable>)componentRoutable
{
    self = [super init];
    if (self) {
        _componentRoutable = componentRoutable;
    }
    return self;
}

- (void)sendEventName:(NSString *)eventName intentData:(nullable id)intentData,...
{
    // 指向变参的指针
    va_list args;
    // 使用最后一个参数来初使化list指针
    va_start(args, intentData);
    while (YES)
    {
        // 返回可变参数，va_arg第二个参数为可变参数类型，如果有多个可变参数，依次调用可获取各个参数
        NSString *componentName = va_arg(args, NSString*);
        if (!componentName || ![componentName isKindOfClass:[NSString class]]) {
            break;
        }
        [XFComponentManager sendEventName:eventName intentData:intentData forComponent:componentName];
    }
    // 结束可变参数的获取
    va_end(args);
}

- (void)sendEventName:(NSString *)eventName intentData:(nullable id)intentData forComponents:(NSArray<NSString *> *)componentNames
{
    for (NSString *componentName in componentNames) {
        [XFComponentManager sendEventName:eventName intentData:intentData forComponent:componentName];
    }
}

- (void)sendNotificationForMVxWithName:(NSString *)notiName intentData:(nullable id)intentData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil userInfo:intentData];
}

- (void)registerMVxNotificationsForTarget:(id)target,... {
    // 如果没有接收方法，直接返回
    if (![self.componentRoutable respondsToSelector:@selector(receiveComponentEventName:intentData:)]) {
        NSAssert(NO, @"当前可运行组件没有接收方法！");
        return;
    }
    va_list args;
    va_start(args, target);
    while (YES)
    {
        NSString *notiName = va_arg(args, NSString*);
        if (!notiName) {
            break;
        }
        [self _innerRegisterNotiName:notiName];
    }
    va_end(args);
}

- (void)registerMVxNotifications:(NSArray<NSString *> *)notiNames
{
    if (notiNames == nil || notiNames.count == 0) {
        return;
    }
    for (NSString *notiName in notiNames) {
        [self _innerRegisterNotiName:notiName];
    }
}

- (void)_innerRegisterNotiName:(NSString *)notiName
{
    XF_Define_Weak
    // 侦听通知
    id<NSObject> observer=
    [[NSNotificationCenter defaultCenter]
     addObserverForName:notiName
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * _Nonnull note) {
         XF_Define_Strong
         // 通知组件接收事件
         [self.componentRoutable receiveComponentEventName:note.name intentData:note.userInfo];
     }];
    // 添加到侦听数组
    [self.observers addObject:observer];
}

- (void)setupTimerWithTimeInterval:(NSTimeInterval)interval
{
    if (![self.componentRoutable respondsToSelector:@selector(run)]) {
        NSAssert(NO, @"当前可运行组件没有实现run方法！");
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:interval target:self.componentRoutable selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)startTimer
{
    self.timer.fireDate = [NSDate distantPast];
}

- (void)pauseTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)resumeTimer
{
    self.timer.fireDate = [NSDate date];
}

- (void)stopTimer
{
    if (self.timer.isValid) {
        [self.timer invalidate]; // 从运行循环中移除，对运行循环的引用进行一次 release
        self.timer = nil; // 将销毁定时器
    }
}

- (NSMutableArray *)observers
{
    if (_observers == nil) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

// 删除所有侦听
- (void)_removeObservers {
    if (_observers) {
        for (id<NSObject> observer in _observers) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        _observers = nil;
    }
}

- (void)dealloc
{
    [self _removeObservers];
}
@end
