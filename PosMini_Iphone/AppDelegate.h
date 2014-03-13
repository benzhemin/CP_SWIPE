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
#import "DefaultBusinessViewController.h"
#import "MerchantConfigurationViewController.h"
#import "CPNavigationController.h"
#import "LocationService.h"
#import "MerchantService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CPTabBarDelegate>{
    UIImageView *launchImgView;
    
    CPNavigationController *loginNaviController;
    
    //修改为我的业务
    CPNavigationController *businessNaviController;
    
    CPNavigationController *receiptNaviController;
    CPNavigationController *orderNaviController;
    CPNavigationController *acctNaviController;
    CPNavigationController *helpNaviController;
    
    NSArray *naviArray;
    
    CPTabBar *cpTabBar;

    VersionService *vp;
    /* Add_S 启明 费凯峰 功能点:新增我的业务*/
    MerchantService *merchantService;
    /* Add_E 启明 费凯峰 功能点:新增我的业务*/
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIImageView *launchImgView;

@property (nonatomic, retain) CPNavigationController *loginNaviController;

@property (nonatomic, retain) CPNavigationController *receiptNaviController;
@property (nonatomic, retain) CPNavigationController *orderNaviController;
@property (nonatomic, retain) CPNavigationController *acctNaviController;
@property (nonatomic, retain) CPNavigationController *helpNaviController;
/* Add_S 启明 费凯峰 功能点:新增我的业务*/
@property (nonatomic, retain) CPNavigationController *businessNaviController;
/* Add_E 启明 费凯峰 功能点:新增我的业务*/
@property (nonatomic, retain) NSArray *naviArray;

@property (nonatomic, retain) CPTabBar *cpTabBar;

-(void)showTabBar;
-(void)hiddenTabBar;

-(void)versionReqFinished;
-(void)loginSuccess;

@end
