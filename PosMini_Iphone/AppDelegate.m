//
//  AppDelegate.m
//  POS mini
//
//  Created by chinapnr on 13-7-5.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AppDelegate.h"
#import "PostBeService.h"
#import "PosMini.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize launchImgView, cpTabBar;

- (void)dealloc{
    [_window release];
    
    [launchImgView release];
    [cpTabBar release];
    
    [pb release];
    [vp release];
    
    [super dealloc];
}

- (void)performApplicationStartupLogic
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    LoginViewController *loginController = [[[LoginViewController alloc] init] autorelease];
    loginController.isShowNaviBar = NO;
    loginController.isShowTabBar = NO;
    self.window.rootViewController = loginController;
    
    /*
    self.cpTabBar = [[[CPTabBar alloc] initWithFrame:CGRectMake(0, baseController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] autorelease];
    cpTabBar.delegate = self;
    [cpTabBar setTabSelected:2];
    [loginController.view addSubview:cpTabBar];
    */
     
    UIImage *launchImg = IS_IPHONE5 ? [UIImage imageNamed:@"Default-568h.png"]:[UIImage imageNamed:@"Default.png"];
    
    self.launchImgView = [[[UIImageView alloc] initWithImage:launchImg] autorelease];
    [self.window.rootViewController.view addSubview:launchImgView];
    [self.window makeKeyAndVisible];
    
    [PosMini initializePosMini];
    
    //请求uid
    pb = [[PostBeService alloc] init];
    [pb postBeForUID];
    
    //版本更新请求
    vp = [[VersionService alloc] init];
    [vp onRespondTarget:self selector:@selector(versionReqFinished)];
    [vp checkForUpdate];
}

-(void)versionReqFinished{
    [launchImgView removeFromSuperview];
    self.launchImgView = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performApplicationStartupLogic];
    return YES;
}

/**
 隐藏下面切换Tab
 */
-(void)hiddenTabBar

{
    [cpTabBar removeFromSuperview];
}

/**
 显示下面切换Tab
 */
-(void)showTabBar

{
    [self.window.rootViewController.view addSubview:cpTabBar];
}

-(void)changeToIndex:(int)index
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application{}
- (void)applicationDidEnterBackground:(UIApplication *)application{}
- (void)applicationWillEnterForeground:(UIApplication *)application{}
- (void)applicationDidBecomeActive:(UIApplication *)application{}
- (void)applicationWillTerminate:(UIApplication *)application{}

@end
