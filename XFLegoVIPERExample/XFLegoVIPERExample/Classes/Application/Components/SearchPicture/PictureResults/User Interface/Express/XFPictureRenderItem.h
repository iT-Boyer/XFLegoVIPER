//
//  XFPictureItem.h
//  XFLegoVIPERExample
//
//  Created by Yizzuide on 16/8/27.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFRenderItem.h"

@interface XFPictureRenderItem : XFRenderItem

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *thumbUrl;
@property (nonatomic, strong) NSURL *coverUrl;
@end
