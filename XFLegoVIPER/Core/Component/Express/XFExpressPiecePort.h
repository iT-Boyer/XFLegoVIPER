//
//  XFExpressPiecePort.h
//  XFLegoVIPER
//
//  Created by Yizzuide on 2016/11/28.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import "XFExpressPiece.h"

/**
 *  子视图渲染包协议
 */
@protocol XFExpressPiecePort <NSObject>

@property (nonatomic, weak) XFExpressPiece *expressPiece;
@end
