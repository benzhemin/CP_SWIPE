//
//  PosMini.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMini.h"
#import "DeviceIntrospection.h"
#import "PosMiniSettings.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Helper.h"

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
    
    [DeviceIntrospection sharedInstance];
    [PosMiniSettings instance];
    
    
    //initialize NSDefault settings
    
    //设置刷新账户信息
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
    //设置刷新订单信息
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_ORDER_NEED_REFRESH];
    //初始设备号
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_DEVICE_ID];
    //设置session
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_LOCAL_SESSION];
    //是否已登陆
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_LOGIN];
    
    //每日交易限额
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_ONE_LIMIT_AMOUNT];
    //单笔交易限额
    [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_SUM_LIMIT_AMOUNT];
    
    //是否需要向下传递用户名
    
    //是否让用户输入密码
    
    
    
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
    
    [DeviceIntrospection destroySharedInstance];
    [PosMiniSettings destroyInstance];
    
    [PosMini destroySharedInstance];
}


//Setting global PosMini request　
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
	
	[hud hide:YES afterDelay:2];
}

-(void) displaySysPromptAutomatically:(NSNotification *)notification
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:2];
}

-(void)applicationWillTerminate{
	
	[PosMini shutdown];
}

@end
