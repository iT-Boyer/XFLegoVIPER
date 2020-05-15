//
//  LEMVVMModuleReflect.h
//  XFLegoVIPER
//
//  Created by Yizzuide on 2017/1/29.
//  Copyright © 2017年 Yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>

// 获得当前MVVM组件模块名
#undef XF_ModuleName
#define XF_ModuleName \
[LEMVVMModuleReflect moduleNameForViewModel:self]

@class LEViewModel;
@interface LEMVVMModuleReflect : NSObject
/**
 *  验证模块名
 *
 *  @param moduleName 模块名
 *
 *  @return 是否是MVVM模块
 */
+ (BOOL)verifyModuleName:(NSString *)moduleName;
/**
 *  根据ViewModel返回模块名
 *
 *  @param viewModel ViewModel
 *
 *  @return 模块名
 */
+ (NSString *)moduleNameForViewModel:(LEViewModel *)viewModel;
@end
