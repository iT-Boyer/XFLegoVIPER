//
//  UIView+XFLego.h
//  XFLegoVIPE
//
//  Created by Yizzuide on 16/8/26.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFEventHandlerPort.h"
#import "XFExpressPiece.h"
#import "XFRenderItem.h"
#import "UIView+ComponentSubView.h"

#define XFConvertPresenterToType(type) LEGORealPort(type, self.eventHandler)

@interface UIView (XFLego)

/**
 *  事件处理器
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id<XFEventHandlerPort> eventHandler;

@end
