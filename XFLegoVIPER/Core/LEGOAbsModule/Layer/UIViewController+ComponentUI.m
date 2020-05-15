//
//  UIViewController+ComponentUI.m
//  XFLegoVIPER
//
//  Created by Yizzuide on 2017/2/10.
//  Copyright © 2017年 Yizzuide. All rights reserved.
//

#import "UIViewController+ComponentUI.h"
#import <objc/runtime.h>
#import "XFUInterfaceFactory.h"
#import "UIView+ComponentSubView.h"
#import "NSObject+XFLegoSwizzle.h"
#import "XFComponentBindEvent.h"

#define MatchComponent \
id<XFComponentBindEvent> component = (id)[XFComponentReflect componentForUInterface:self];

@implementation UIViewController (ComponentUI)

- (void)setPoppingProgrammatically:(NSNumber *)popingBool
{
    objc_setAssociatedObject(self, @selector(poppingProgrammatically), popingBool, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)poppingProgrammatically
{
    NSNumber *popingNumber = objc_getAssociatedObject(self, _cmd);
    return popingNumber.boolValue;
}

#pragma mark - 生命周期
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self xfLego_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(xfLego_viewDidLoad)];
        [self xfLego_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(xfLego_viewWillAppear:)];
        [self xfLego_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(xfLego_viewDidAppear:)];
        [self xfLego_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(xfLego_viewWillDisappear:)];
        [self xfLego_swizzleMethod:@selector(viewDidDisappear:) withMethod:@selector(xfLego_viewDidDisappear:)];
//        [self xfLego_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(xfLego_didMoveToSuperview)];
    });
}

- (void)xfLego_viewDidLoad
{
    [self xfLego_viewDidLoad];
    // 初始化事件处理
    [self _xfLego_initEventHandlerWithAdditionWorkBlock:nil];
    // 由于[[UITabBarController alloc] init]执行会立即调用当前viewDidLoad方法，所以这里要单独处理
    if ([self isKindOfClass:[UITabBarController class]]) {
        XF_Define_Weak
        LEGORunAfter0_015({
            XF_Define_Strong
            // 重新绑定关系层
            [self _xfLego_initEventHandlerWithAdditionWorkBlock:^{
                // 调用自定义加载完成方法
                [self xfLego_viewDidLoadForTabBarViewController];
                
                MatchComponent
                Class<XFComponentHandlerPlug> componentHandler = [XFComponentReflect componentHandlerForComponent:component];
                [componentHandler willReBindRelationFromSubUserInterfaces:self.childViewControllers toParentUserInterface:self];
            }];
        })
    }
}

- (void)xfLego_viewWillAppear:(BOOL)animated
{
    [self xfLego_viewWillAppear:animated];
    MatchComponent
    if ([component respondsToSelector:@selector(viewWillAppear)])
        [component viewWillAppear];
}

- (void)xfLego_viewDidAppear:(BOOL)animated
{
    [self xfLego_viewDidAppear:animated];
    MatchComponent
    if ([component respondsToSelector:@selector(viewDidAppear)])
        [component viewDidAppear];
}

- (void)xfLego_viewWillDisappear:(BOOL)animated
{
    [self xfLego_viewWillDisappear:animated];
    MatchComponent
    if ([component respondsToSelector:@selector(viewWillDisappear)])
        [component viewWillDisappear];
}

- (void)xfLego_viewDidDisappear:(BOOL)animated
{
    [self xfLego_viewDidDisappear:animated];
    MatchComponent
    if ([component respondsToSelector:@selector(viewDidDisappear)])
        [component viewDidDisappear];
    
    // 如果当前控制器属于TabBar直接子控制器，直接返回 (因为该组件不需要移除)
    if ([self.parentViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    if ([self.parentViewController isKindOfClass:[UINavigationController class]] &&
        [self.parentViewController.parentViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    // 如果当前控制器出于某种原因拒绝被移除，直接返回
    if (![self xfLego_enableAutoRemoveSelfComp]) {
        return;
    }
    
    // 如果当前视图被pop或dismiss
    if (self.isMovingFromParentViewController ||
        self.isBeingDismissed ||
        self.navigationController.isMovingFromParentViewController ||
        self.navigationController.isBeingDismissed) {
        // 调用视图层，视图将被移除方法
        [self _xfLego_viewWillPopOrDismiss];
        // 如果是通过框架方式，直接返回
        if (self.poppingProgrammatically) return;
        // 事件层响应移除操作，如：内存释放、断开组件关系链等
        [component xf_viewWillPopOrDismiss];
        // 事件层同步当前视图生命周期
        if ([component respondsToSelector:@selector(viewWillPopOrDismiss)]) {
            [component viewWillPopOrDismiss];
        }
    }
}

/*- (void)xfLego_didMoveToSuperview
{
    [self xfLego_didMoveToSuperview];
    if (self.view.superview){
        // the view was added as a subview to superview
    } else {
        // the view was removed from its superview
    }
}*/

#pragma mark - 子类可覆盖方法
- (void)xfLego_viewDidLoadForTabBarViewController {}
- (void)xfLego_viewWillPopOrDismiss {}
- (BOOL)xfLego_enableAutoRemoveSelfComp
{
    return YES;
}
// 实现退出键盘
- (void)needDismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
// 通知所有子视图当前Activity将被移除
- (void)_xfLego_viewWillPopOrDismiss
{
    for (UIView *view in self.view.subviews) {
        [view xfLego_viewWillPopOrDismiss];
    }
    [self xfLego_viewWillPopOrDismiss];
}

- (void)_xfLego_initEventHandlerWithAdditionWorkBlock:(void(^)())additionWorkBlock
{
    MatchComponent
    [self setPoppingProgrammatically:@NO];
    if ([component respondsToSelector:@selector(xfLego_bindView:)]) {
        [component xfLego_bindView:self];
    }
    if (additionWorkBlock) {
        additionWorkBlock();
    }
}
@end
