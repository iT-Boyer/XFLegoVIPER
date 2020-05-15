//
//  LEMVVMModuleHandler.m
//  XFLegoVIPER
//
//  Created by Yizzuide on 2017/1/28.
//  Copyright © 2017年 Yizzuide. All rights reserved.
//

#import "LEMVVMModuleHandler.h"
#import "UIViewController+ComponentBridge.h"
#import "LEMVVMModuleReflect.h"
#import "UIViewController+LEView.h"
#import "LEMVVMModuleFactory.h"
#import "XFModuleReflect.h"


@implementation LEMVVMModuleHandler

+ (BOOL)matchComponent:(id)component
{
    if ([component isKindOfClass:[NSString class]]) {
        return [LEMVVMModuleReflect verifyModuleName:component];
    }
    return [component respondsToSelector:@selector(view)] && ![component respondsToSelector:@selector(parentViewController)];
}

+ (BOOL)matchUInterface:(UIViewController *)uInterface
{
    return !!uInterface.dataDriver;
}

+ (id<XFComponentRoutable>)createComponentFromName:(NSString *)componentName
{
    // 引用赋值父组件名
    NSString *superComponentName;
    LEViewModel<XFComponentRoutable> *viewModel = [LEMVVMModuleFactory createViewModelFromModuleName:componentName superModule:&superComponentName];
    NSString *modulePrefix = [XFModuleReflect inspectModulePrefixWithModule:componentName stuffixName:@"ViewModel"];
    NSString *uInterfaceClazzName = [NSString stringWithFormat:@"%@%@%@",modulePrefix,superComponentName?:componentName,@"ViewController"];
    UIViewController<LEViewProtocol> *uInterface = [[NSClassFromString(uInterfaceClazzName) alloc] init];
    [uInterface setValue:viewModel forKeyPath:@"dataDriver"];
    [viewModel.uiBus setUInterface:uInterface];
    return viewModel;
}

+ (NSString *)componentNameFromComponent:(__kindof id<XFComponentRoutable>)component
{
    return [LEMVVMModuleReflect moduleNameForViewModel:component];
}

+ (UIViewController *)uInterfaceForComponent:(__kindof id<XFComponentRoutable>)component
{
    return (id)[[component uiBus] uInterface] ?: [component view];
}

+ (id<XFComponentRoutable>)componentForUInterface:(UIViewController *)uInterface
{
    return uInterface.dataDriver;
}

+ (XFUIBus *)uiBusForComponent:(__kindof id<XFComponentRoutable>)component
{
    return [component uiBus];
}

+ (id<XFComponentRoutable>)component:(__kindof id<XFComponentRoutable>)component createNextComponentFromName:(NSString *)componentName
{
    return [self createComponentFromName:componentName];
}

+ (__kindof UIViewController *)subUIterfaceFromSubComponent:(__kindof id<XFComponentRoutable>)component parentUInterface:(__kindof UIViewController *)parentUInterface
{
    return [XFComponentReflect uInterfaceForComponent:component];
}

+ (void)willReBindRelationFromSubUserInterfaces:(NSArray<UIViewController *> *)subUserInterfaces toParentUserInterface:(__kindof UIViewController *)parentUserInterface
{
}

+ (void)willRemoveComponent:(__kindof id<XFComponentRoutable>)component
{
}

+ (void)willReleaseComponent:(__kindof id<XFComponentRoutable>)component
{
}

@end
