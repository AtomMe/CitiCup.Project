//
//  PanForbidden.h
//  DrawerTest
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 youtui.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanForbidden : NSObject

@property (assign,nonatomic)BOOL isForbidden;

+ (PanForbidden *)defaultPanForbidden;

@end
