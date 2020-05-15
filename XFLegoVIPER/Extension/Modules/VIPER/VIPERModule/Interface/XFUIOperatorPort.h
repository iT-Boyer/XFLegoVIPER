//
//  XFUIOperatorPort.h
//  XFLegoVIPER
//
//  Created by Yizzuide on 15/12/22.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#ifndef XFUIOperatorPort_h
#define XFUIOperatorPort_h

#import <UIKit/UIKit.h>
#import "XFUserInterfacePort.h"
#import "XFVIPERModuleRunnable.h"

@protocol XFUIOperatorPort <XFVIPERModuleRunnable>

/**
 *  当前UI交互者的视图给Routing的接口
 */
@property (nonatomic, weak, readonly) id<XFUserInterfacePort> userInterface;
@end


#endif /* XFUIOperatorPort_h */
