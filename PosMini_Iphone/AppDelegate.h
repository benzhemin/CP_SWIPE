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

#import "DefaultReceiptViewController.h"
#import "DefaultOrderViewController.h"
#import "DefaultAccountViewController.h"
#import "DefaultHelpViewController.h"
#import "CPNavigationController.h"
#import "LocationService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CPTabBarDelegate>{
    UIImageView *launchImgView;
    
    CPNavigationController *loginNaviController;
    
    CPNavigationController *receiptNaviController;
    CPNavigationController *orderNaviController;
    CPNavigationController *acctNaviController;
    CPNavigationController *helpNaviController;
    
    NSArray *naviArray;
    
    CPTabBar *cpTabBar;
    
    PostBeService *pb;
    VersionService *vp;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIImageView *launchImgView;

@property (nonatomic, retain) CPNavigationController *loginNaviController;

@property (nonatomic, retain) CPNavigationController *receiptNaviController;
@property (nonatomic, retain) CPNavigationController *orderNaviController;
@property (nonatomic, retain) CPNavigationController *acctNaviController;
@property (nonatomic, retain) CPNavigationController *helpNaviController;

@property (nonatomic, retain) NSArray *naviArray;

@property (nonatomic, retain) CPTabBar *cpTabBar;

-(void)versionReqFinished;
-(void)loginSuccess;

@end
