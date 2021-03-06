//
//  PosMini.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMini.h"
#import "PosMiniDevice.h"
#import "DeviceIntrospection.h"
#import "PosMiniSettings.h"
#import "LocationService.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Helper.h"
#import "RequireLoginViewController.h"

static PosMini *sInstance = nil;

@implementation PosMini

@synthesize uiPromptHUD, sysPromptHUD;

-(void)dealloc{
    [uiPromptHUD release];
    [sysPromptHUD release];
    
    [super dealloc];
}

+(PosMini *)sharedInstance
{
    if (sInstance == nil)
    {
        sInstance = [[PosMini alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance
{
    CPSafeRelease(sInstance);
}

+(void)initializePosMini
{
    PosMini *instance = [PosMini sharedInstance];
    
    //初始化pos mini设备
    [PosMiniDevice initializePosMiniDevice];
    [LocationService sharedInstance];
    [DeviceIntrospection sharedInstance];
    [PosMiniSettings instance];
    [PostBeService sharedInstance];
    
    
    //initialize NSDefault settings
    
    //设置刷新账户信息
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
    //设置刷新订单信息
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_ORDER_NEED_REFRESH];
    /*Add_S 启明 张翔 功能点:商户配置信息*/
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_MERCHANT_NEED_REFRESH];
    /*Add_E 启明 张翔 功能点:商户配置信息*/
    
    //初始设备号
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_DEVICE_ID];
    //POSmini绑定设备号
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_MTP_BINDED_DEVICE_ID];
    //设置session
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_LOCAL_SESSION];
    //是否已登陆
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_LOGIN];
    //是否在展示重新登录页面
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_SHOW_USER_LOGIN];
    //pos mini连接状态
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_CONNECTION_STATUS];
    //显示用户签名,保留,目前不需要显示用户签名
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_SHOW_USER_SIGN];
    
    //每日交易限额
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_ONE_LIMIT_AMOUNT];
    //单笔交易限额
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_SUM_LIMIT_AMOUNT];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(requireUserLogin:)
                                                 name:NOTIFICATION_REQUIRE_USER_LOGIN
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(displayUIPromptAutomatically:)
                                                 name:NOTIFICATION_UI_AUTO_PROMPT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(displaySysPromptAutomatically:)
                                                 name:NOTIFICATION_SYS_AUTO_PROMPT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(postHideUIPromptMessage)
                                                 name:NOTIFICATION_HIDE_UI_PROMPT
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter]	addObserver:instance
											 selector:@selector(applicationWillTerminate)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
}

+(void)shutdown{
    PosMini *instance = [PosMini sharedInstance];
    if (instance == nil) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:instance];
    
    [PosMiniDevice destroySharedInstance];
    [DeviceIntrospection destroySharedInstance];
    [LocationService destroySharedInstance];
    [PosMiniSettings destroyInstance];
    
    [PosMini destroySharedInstance];

    [PostBeService destroySharedInstance];
}


//Set global PosMini request　
-(void)performRequest:(ASIHTTPRequest *)req
{
    //set CHINAPNR json post
    if ([req.requestMethod isEqualToString:@"POST"]) {
        if ([req respondsToSelector:@selector(setPostBodyFormat:)]) {
            [(ASIFormDataRequest *)req setPostBodyFormat:ASIURLEncodedPostJSONFormat];
        }
    }
    
    //construct seession cookie
    //NSHTTPCookiePath and NSHTTPCookieDomain is required, or NSHTTPCookie will return nil
    NSString *sessionStr = [Helper getValueByKey:POSMINI_LOCAL_SESSION];
    if (sessionStr!=nil && ![sessionStr isEqualToString:@"#"])
    {
        NSMutableDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
        [properties setValue:POSMINI_MTP_SESSION forKey:NSHTTPCookieName];
        [properties setValue:sessionStr forKey:NSHTTPCookieValue];
        [properties setValue:@"\\" forKey:NSHTTPCookiePath];
        [properties setValue:req.url.host forKey:NSHTTPCookieDomain];
        
        NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
        
        [req setUseCookiePersistence:NO];
        [req setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    }
}

//用户重新登录
-(void)requireUserLogin:(NSNotification *)notify{
    
    if ([[Helper getValueByKey:POSMINI_SHOW_USER_LOGIN] isEqualToString:NSSTRING_NO]) {
        RequireLoginViewController *rl = [[RequireLoginViewController alloc] init];
        rl.isShowNaviBar = NO;
        rl.isShowTabBar = NO;
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentModalViewController:rl animated:YES];
        [rl release];
    }
}


#pragma mark -
#pragma mark UIPromptMessage methods
/*
 *　显示UI loading消息
 */
-(void) showUIPromptMessage:(NSString *)message animated:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (uiPromptHUD == nil)
    {
        self.uiPromptHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [window bringSubviewToFront:sysPromptHUD];
        uiPromptHUD.tag = MBPHUD_UI_PROMPT_TAG;
        uiPromptHUD.delegate = self;
        uiPromptHUD.mode = MBProgressHUDModeIndeterminate;
    }
    uiPromptHUD.labelText = message;
    [uiPromptHUD show:animated];
}

-(void)postHideUIPromptMessage{
    [self hideUIPromptMessage:YES];
}

-(void) hideUIPromptMessage:(BOOL)animated
{
    if (uiPromptHUD)
    {
        [uiPromptHUD hide:animated];
    }
}

-(void) changeUIPromptMessage:(NSString *)message
{
    if (uiPromptHUD)
    {
        uiPromptHUD.labelText = message;
    }
}


#pragma mark -
#pragma mark SysPromptMessage methods
/*
 *　显示系统提示消息
 */
-(void) showSysPromptMessage:(NSString *)message animated:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (sysPromptHUD == nil)
    {
        self.sysPromptHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [window bringSubviewToFront:sysPromptHUD];
        sysPromptHUD.tag = MBPHUD_SYS_PROMPT_TAG;
        sysPromptHUD.delegate = self;
        sysPromptHUD.margin = 10.f;
        sysPromptHUD.yOffset = 150.f;
    }
    sysPromptHUD.labelText = message;
    [sysPromptHUD show:animated];
}

-(void) hideSysPromptMessage:(BOOL)animated
{
    if (sysPromptHUD) {
        [sysPromptHUD hide:animated];
    }
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods
//clean up HUD object
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    switch (hud.tag) {
        case MBPHUD_UI_PROMPT_TAG:
            [uiPromptHUD removeFromSuperview];
            self.uiPromptHUD = nil;
            break;
            
        case MBPHUD_SYS_PROMPT_TAG:
            [sysPromptHUD removeFromSuperview];
            self.sysPromptHUD = nil;
            break;
    }
	
}

-(void) displayUIPromptAutomatically:(NSNotification *)notification
{    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
	
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5];
}

-(void) displaySysPromptAutomatically:(NSNotification *)notification
{
    /*Mod_S 启明 张翔 功能点：故障对应 弹出alertView后MBProgressHUD不表示*/
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /*Mod_E 启明 张翔 功能点：故障对应 弹出alertView后MBProgressHUD不表示*/
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5];
}

-(void)applicationWillTerminate{
	[PosMini shutdown];
}

@end
