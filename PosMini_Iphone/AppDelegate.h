//
//  AppDelegate.h
//  POS mini
//
//  Created by chinapnr on 13-7-5.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CPTabBarDelegate.h"
#import "CPTabBar.h"
#import "PostBeService.h"
#import "VersionService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CPTabBarDelegate>{
    UIImageView *launchImgView;
    
    CPTabBar *cpTabBar;
    
    PostBeService *pb;
    VersionService *vp;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIImageView *launchImgView;

@property (nonatomic, retain) CPTabBar *cpTabBar;

-(void)versionReqFinished;

@end
