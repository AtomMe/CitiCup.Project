//
//  CustomToolBar.h
//  DrawerTest
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 youtui.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransStrokeContetProtocol <NSObject>

//改变涂鸦颜色
- (void)transStrokeColor:(UIColor *)theColor;

//改变线条粗细
- (void)transStrokeWidth:(float)width;

//判断是否画矩形
- (void)transRectangle:(BOOL)isRectangle;

//进行清空
- (void)transClearDrawerView;

 //保存涂鸦
- (void)transSaveDrawerView;

@end

@interface CustomToolBar : UIView

@property(assign,nonatomic)id<TransStrokeContetProtocol>delegate;

@end
