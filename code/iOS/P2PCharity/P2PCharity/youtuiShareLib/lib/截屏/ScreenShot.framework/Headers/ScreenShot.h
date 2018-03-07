//
//  ScreenShot.h
//  FrameWorkTest
//
//  Created by FreeGeek on 14-12-16.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerView.h"
#import "CustomToolBar.h"
#import "PanForbidden.h"
#import "CustomButton.h"
@protocol YouTuiScreenShotDelegate<NSObject>
//获取图片
- (void)drawerSaveImage:(UIImage *)drawerImage;

@end

@interface ScreenShot : UIViewController

@property (nonatomic,strong)DrawerView *drawerView;

//截图图片
@property (nonatomic,strong)UIImage *image;

@property (assign,nonatomic)id<YouTuiScreenShotDelegate>delegate;
//截屏
+ (UIImage *)ScreenShotView:(UIView *)view;
//设置导航栏左右键Title
-(void)SetLeftItemName:(NSString *)LeftItemName WithRightItemName:(NSString *)RightItemName;
@end
