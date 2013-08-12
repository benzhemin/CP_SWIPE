//
//  BaseViewController.m
//  POS mini
//
//  Created by chinapnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

@synthesize bgImageView, contentView;
@synthesize naviBgView, naviTitleLabel, naviBackBtn;
@synthesize isShowNaviBar, isShowTabBar;
@synthesize uiPromptHUD, sysPromptHUD;
@synthesize pb;

-(void)dealloc{
    [bgImageView release];
    
    [naviBgView release];
    [naviTitleLabel release];
    [naviBackBtn release];
    
    [contentView release];
    
    [uiPromptHUD release];
    [sysPromptHUD release];
    
    [pb release];
    [super dealloc];
}

-(id)init{
    if (self=[super init]) {
        isShowNaviBar = YES;
        isShowTabBar = YES;
        
        //设置self.view的高度包含statusBarHeight
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHeight = statusBarFrame.size.height;
    
    self.navigationController.navigationBar.hidden = YES;
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    //背景图片
    UIImageView *cusBgImageView = [[UIImageView alloc] init];
    self.bgImageView = cusBgImageView;
    [cusBgImageView release];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    bgImageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgImageView];
    
    //中间显示部分
    UIView *cusContentView = [[UIView alloc] init];
    self.contentView = cusContentView;
    [cusContentView release];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:contentView];
    
    //设置导航栏
    CGFloat naviBarHeight = 0.0;
    if (self.isShowNaviBar) {
        naviBarHeight = DEFAULT_NAVIGATION_BAR_HEIGHT;
        //初始化导航栏
        self.naviBgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg.png"]] autorelease];
        naviBgView.userInteractionEnabled = YES;
        naviBgView.frame = CGRectMake(0, statusBarHeight, viewWidth, DEFAULT_NAVIGATION_BAR_HEIGHT);
        [bgImageView addSubview:naviBgView];
        
        self.naviBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [naviBackBtn setBackgroundImage:[[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:15] forState:UIControlStateNormal];
        naviBackBtn.frame = CGRectMake(10, 7, 41, 31);
        [naviBgView addSubview:naviBackBtn];
        [naviBackBtn addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *backBtnLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-btn.png"]];
        backBtnLogo.frame = CGRectMake(9, 7, 22, 15);
        [naviBackBtn addSubview:backBtnLogo];
        [backBtnLogo release];
        
        naviBackBtn.hidden = YES;
        
        //如果当前NavigationController中的viewController的个数超过1个，显示返回按钮
        if (self.navigationController.viewControllers.count > 1) {
            naviBackBtn.hidden = NO;
        }
        
        UILabel *cusNavTitleLabel = [[UILabel alloc] init];
        self.naviTitleLabel = cusNavTitleLabel;
        [cusNavTitleLabel release];
        
        naviTitleLabel.frame = CGRectMake(0, 0, DEFAULT_NAVIGATION_TITLE_WIDTH, naviBgView.frame.size.height);
        naviTitleLabel.textAlignment = NSTextAlignmentCenter;
        naviTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        naviTitleLabel.textColor = [UIColor whiteColor];
        naviTitleLabel.backgroundColor = [UIColor clearColor];
        [naviBgView addSubview:naviTitleLabel];
        naviTitleLabel.center = CGPointMake(naviBgView.center.x, naviTitleLabel.center.y);
    }
    
    CGFloat tabBarHeight = 0.0;
    if (isShowTabBar) {
        tabBarHeight = DEFAULT_TAB_BAR_HEIGHT;
    }
    contentView.frame = CGRectMake(0, naviBarHeight+statusBarHeight, viewWidth, viewHeight-naviBarHeight-tabBarHeight);
    
    self.pb = [[[PostBeService alloc] init] autorelease];
    if (![[self getViewId] isEqualToString:@"0"] && [Helper getValueByKey:POSTBE_UID]) {
        [pb postBeRequest];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //防止popViewController时,设置错误的controller
    [PosMiniDevice sharedInstance].baseCTRL = self;
    
    [self tabBarAnimation];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)tabBarAnimation{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //以动画形式隐藏或显示下面Tabbar
    if (self.navigationController!=nil) {
        UIView *subView = [self.navigationController.view viewWithTag:CPTABBAR_UIVIEW_TAG];
        
        if(isShowTabBar)
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"Dialog" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.2];
            
            subView.frame = CGRectMake(0, rootController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT,
                                       self.view.frame.size.width, DEFAULT_TAB_BAR_HEIGHT);
            [UIView commitAnimations];
        }
        else
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"Dialog" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.2];
            subView.frame = CGRectMake(0, rootController.view.frame.size.height, self.view.frame.size.width, DEFAULT_TAB_BAR_HEIGHT);
            [UIView commitAnimations];
        }
    }
}

-(void) hideBackButton
{
    naviBackBtn.hidden = YES;
}

-(void)setNavigationTitle:(NSString *)title
{
    if (self.isShowNaviBar)
    {
        naviTitleLabel.text = title;
    }
}

-(void)backToPreviousView:(id)sender{
    //如果当前NavigationController中ViewController超过1个，移除最上面的一个
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)controllerName
{
    return NSStringFromClass([self class]);
}

-(NSString*) getViewId
{
    return @"0";
}

// -------------------------------------------------------------------------------
//	supportedInterfaceOrientations
//  Support only portrait orientation (iOS 6).
// -------------------------------------------------------------------------------
#pragma mark -
#pragma mark Orientation support (ios6) methods
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end































