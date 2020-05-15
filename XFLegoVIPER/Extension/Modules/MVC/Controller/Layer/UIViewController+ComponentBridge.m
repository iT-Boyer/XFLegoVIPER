//
//  UIViewController+ComponentBridge.m
//  XFLegoVIPER
//
//  Created by Yizzuide on 2016/12/19.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import "UIViewController+ComponentBridge.h"
#import <objc/runtime.h>
#import "NSObject+XFLegoSwizzle.h"

@implementation UIViewController (ComponentBridge)

- (void)setUiBus:(__kindof XFUIBus *)uiBus
{
    objc_setAssociatedObject(self, @selector(uiBus), uiBus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XFUIBus *)uiBus
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEventBus:(__kindof XFEventBus *)eventBus
{
    objc_setAssociatedObject(self, @selector(eventBus), eventBus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XFEventBus *)eventBus
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFromComponentRoutable:(id<XFComponentRoutable>)fromComponentRoutable
{
    objc_setAssociatedObject(self, @selector(fromComponentRoutable), fromComponentRoutable, OBJC_ASSOCIATION_ASSIGN);
}

- (id<XFComponentRoutable>)fromComponentRoutable
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextComponentRoutable:(id<XFComponentRoutable>)nextComponentRoutable
{
    objc_setAssociatedObject(self, @selector(nextComponentRoutable), nextComponentRoutable, OBJC_ASSOCIATION_ASSIGN);
}

- (id<XFComponentRoutable>)nextComponentRoutable
{
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self xfLego_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(componentBridge_viewDidLoad)];
    });
}

// 当前Component响应视图移除
- (void)xf_viewWillPopOrDismiss
{
    if (self.uiBus) {
        // 将组件移除
        [self.uiBus xfLego_implicitRemoveComponentWithTransitionBlock:^(Activity *thisInterface, Activity *nextInterface, TransitionCompletionBlock completionBlock) {
            completionBlock();
        }];
    }
    if (self.eventBus) {
        // 定时器移除
        [self.eventBus stopTimer];
    }
}


- (void)componentBridge_viewDidLoad
{
    [self componentBridge_viewDidLoad];
    if (self.uiBus) {
        // 销毁当前组件界面对象强引用
        [self.uiBus xfLego_destoryUInterfaceRef];
    }
}

@end
