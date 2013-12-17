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
    
    [_businessNaviController release];
    
    [naviArray release];
    
    [vp release];
    
    [merchantService release];
    
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
    
    /* Add_S 启明 费凯峰 功能点:新增我的业务*/
    DefaultBusinessViewController *businessViewController=[[DefaultBusinessViewController alloc]init];
    businessViewController.isShowNaviBar=NO;
    self.businessNaviController=[[[CPNavigationController alloc]initWithRootViewController:businessViewController]autorelease];
    [businessViewController release];
    
    /*
    DefaultReceiptViewController *receiptController = [[DefaultReceiptViewController alloc] init];
    self.receiptNaviController = [[[CPNavigationController alloc] initWithRootViewController:receiptController] autorelease];
    [receiptController release];
    */
    /*Add_E 启明 费凯峰 功能点:新增我的业务*/
    

    DefaultOrderViewController *orderController = [[DefaultOrderViewController alloc] init];
    self.orderNaviController = [[[CPNavigationController alloc] initWithRootViewController:orderController] autorelease];
    [orderController release];
    
    DefaultAccountViewController *acctController = [[DefaultAccountViewController alloc] init];
    self.acctNaviController = [[[CPNavigationController alloc] initWithRootViewController:acctController] autorelease];
    [acctController release];
    
    DefaultHelpViewController *helpController = [[DefaultHelpViewController alloc] init];
    self.helpNaviController = [[[CPNavigationController alloc] initWithRootViewController:helpController] autorelease];
    [helpController release];
    
    /* Mod_S 启明 费凯峰 功能点:新增我的业务*/
    self.naviArray = [NSArray arrayWithObjects:_businessNaviController, orderNaviController, acctNaviController, helpNaviController, nil];
    /* Mod_E 启明 费凯峰 功能点:新增我的业务*/
    UIImage *launchImg = IS_IPHONE5 ? [UIImage imageNamed:@"Default-568h.png"]:[UIImage imageNamed:@"Default.png"];
    
    self.launchImgView = [[[UIImageView alloc] initWithImage:launchImg] autorelease];
    launchImgView.frame = CGRectMake(0, 20, launchImg.size.width, launchImg.size.height);
    [self.window.rootViewController.view addSubview:launchImgView];
    [self.window makeKeyAndVisible];
    
    [PosMini initializePosMini];
    
    //请求uid
    [[PostBeService sharedInstance] postBeForUID];
    
    //版本更新请求
    vp = [[VersionService alloc] init];
    [vp onRespondTarget:self selector:@selector(versionReqFinished)];
    [vp checkForUpdate];
}

-(void)loginSuccess{
    /* Mod_S 启明 费凯峰 功能点:查询商户信息*/
    merchantService =[[MerchantService alloc]init];
    [merchantService onRespondTarget:self selector:@selector(merchantRequestDidFinished)];
    [merchantService requestForMerchantInfo];
    
//    self.window.rootViewController = acctNaviController;
//    self.cpTabBar = [[[CPTabBar alloc] initWithFrame:CGRectMake(0, self.window.rootViewController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] autorelease];
//    cpTabBar.delegate = self;
//    [cpTabBar setTabSelected:2];
//    [self.window.rootViewController.view addSubview:cpTabBar];
//
//    //请求定位
//    [[LocationService sharedInstance] startToLocateWithAuthentication:NO];
    
    /* Mod_E 启明 费凯峰 功能点:查询商户信息*/

}

-(void)changeToIndex:(int)index
{
    [cpTabBar removeFromSuperview];
    CPNavigationController *cpNavi = [naviArray objectAtIndex:index];
    [PosMiniDevice sharedInstance].baseCTRL = cpNavi.viewControllers[0];
    self.window.rootViewController = cpNavi;
    [self.window.rootViewController.view addSubview:cpTabBar];
}

/**
　请求版本更新回调
 */
-(void)versionReqFinished{
    [launchImgView removeFromSuperview];
    self.launchImgView = nil;
}

/* Add_S 启明 费凯峰 功能点:查询商户信息*/
-(void)merchantRequestDidFinished{
    self.window.rootViewController = acctNaviController;
    self.cpTabBar = [[[CPTabBar alloc] initWithFrame:CGRectMake(0, self.window.rootViewController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] autorelease];
    cpTabBar.delegate = self;
    [cpTabBar setTabSelected:2];
    [self.window.rootViewController.view addSubview:cpTabBar];
    
    //请求定位
    [[LocationService sharedInstance] startToLocateWithAuthentication:NO];
}
/* Add_E 启明 费凯峰 功能点:查询商户信息*/

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
