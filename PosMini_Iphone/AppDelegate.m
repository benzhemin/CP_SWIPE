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

@synthesize loginNaviController;
@synthesize receiptNaviController, orderNaviController, acctNaviController, helpNaviController;
@synthesize naviArray;

- (void)dealloc{
    [_window release];
    
    [launchImgView release];
    [cpTabBar release];
    
    [loginNaviController release];
    
    [receiptNaviController release];
    [orderNaviController release];
    [acctNaviController release];
    [helpNaviController release];
    
    [naviArray release];
    
    [pb release];
    [vp release];
    
    [super dealloc];
}

//执行应用启动逻辑
- (void)performApplicationStartupLogic
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    LoginViewController *loginController = [[[LoginViewController alloc] init] autorelease];
    loginController.isShowNaviBar = NO;
    loginController.isShowTabBar = NO;
    self.loginNaviController = [[[CPNavigationController alloc] initWithRootViewController:loginController] autorelease];
    self.window.rootViewController = loginNaviController;
    
    DefaultReceiptViewController *receiptController = [[DefaultReceiptViewController alloc] init];
    self.receiptNaviController = [[[CPNavigationController alloc] initWithRootViewController:receiptController] autorelease];
    [receiptController release];
    
    DefaultOrderViewController *orderController = [[DefaultOrderViewController alloc] init];
    self.orderNaviController = [[[CPNavigationController alloc] initWithRootViewController:orderController] autorelease];
    [orderController release];
    
    DefaultAccountViewController *acctController = [[DefaultAccountViewController alloc] init];
    self.acctNaviController = [[[CPNavigationController alloc] initWithRootViewController:acctController] autorelease];
    [acctController release];
    
    DefaultHelpViewController *helpController = [[DefaultHelpViewController alloc] init];
    self.helpNaviController = [[[CPNavigationController alloc] initWithRootViewController:helpController] autorelease];
    [helpController release];
    
    self.naviArray = [NSArray arrayWithObjects:receiptNaviController, orderNaviController, acctNaviController, helpNaviController, nil];
    
    UIImage *launchImg = IS_IPHONE5 ? [UIImage imageNamed:@"Default-568h.png"]:[UIImage imageNamed:@"Default.png"];
    
    self.launchImgView = [[[UIImageView alloc] initWithImage:launchImg] autorelease];
    launchImgView.frame = CGRectMake(0, 20, launchImg.size.width, launchImg.size.height);
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

-(void)loginSuccess{
    self.window.rootViewController = acctNaviController;
    
    self.cpTabBar = [[[CPTabBar alloc] initWithFrame:CGRectMake(0, self.window.rootViewController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] autorelease];
    cpTabBar.delegate = self;
    [cpTabBar setTabSelected:2];
    [self.window.rootViewController.view addSubview:cpTabBar];
     
    //请求定位
    [[LocationService sharedInstance] startToLocateWithAuthentication:NO];
}

-(void)changeToIndex:(int)index
{
    [cpTabBar removeFromSuperview];
    self.window.rootViewController = [naviArray objectAtIndex:index];
    [self.window.rootViewController.view addSubview:cpTabBar];
}

/**
　请求版本更新回调
 */
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

- (void)applicationWillResignActive:(UIApplication *)application{}
- (void)applicationDidEnterBackground:(UIApplication *)application{}
- (void)applicationWillEnterForeground:(UIApplication *)application{}
- (void)applicationDidBecomeActive:(UIApplication *)application{}
- (void)applicationWillTerminate:(UIApplication *)application{}

@end
