//
//  DrawerView.h
//  DrawerTest
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 youtui.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DrawerView : UIView 
{
    NSMutableArray *strokeContentArray;                //点数组
}

//截图图片
@property (nonatomic,assign)CGImageRef imageRef;

//画笔颜色
@property (nonatomic,strong)UIColor *strokeColor;

//画笔粗细
@property (nonatomic,assign)float strokeWidth;

//是否是矩形
@property (nonatomic,assign)BOOL isRectangle;

//清空涂鸦
- (void)clearDrawerView;

@end
