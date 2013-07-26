//
//  SwipeCardViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SwipeCardViewController.h"

@interface SwipeCardViewController ()

@end

@implementation SwipeCardViewController

@synthesize bankCardView;
@synthesize remainTime;
@synthesize scType, timer, isTimerValid;

-(void)dealloc{
    [timer release];
    [bankCardView release];
    [remainTime release];
    [super dealloc];
}


#define MARGIN_TOP 250

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (scType == PAY_SWIPE_TYPE) {
        [self setNavigationTitle:@"刷卡收款"];
    }else{
        [self setNavigationTitle:@"刷卡退款"];
    }
    
    UIBackgroundTaskIdentifier bgTask = 0;
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeEvent:) userInfo:nil repeats:YES];
    isTimerValid = NO;
    timeCount = READ_CARD_TIMEOUT;
    
    self.bankCardView = [[[UIImageView alloc] initWithFrame:CGRectMake(-150, MARGIN_TOP-30-117-90,174, 113)] autorelease];
    bankCardView.image = [UIImage imageNamed:@"tutorial-card.png"];
    [contentView addSubview:bankCardView];
    
    //显示刷卡器图片
    UIImageView *imageCadrdReaderView = [[UIImageView alloc]initWithFrame:CGRectMake(93, MARGIN_TOP-40-117, 134, 117)];
    imageCadrdReaderView.image = [UIImage imageNamed:@"tutorial-phone.png"];
    [contentView addSubview:imageCadrdReaderView];
    [imageCadrdReaderView release];
    
    //提示文字标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, MARGIN_TOP-20, 150, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"刷卡小助手";
    titleLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:titleLabel];
    [titleLabel release];
    
    //显示剩余时间
    self.remainTime = [[[UILabel alloc]initWithFrame:CGRectMake(160, MARGIN_TOP-20, 150, 20)] autorelease];
    remainTime.font = [UIFont boldSystemFontOfSize:18];
    remainTime.textAlignment = NSTextAlignmentRight;
    remainTime.text = [NSString stringWithFormat:@"剩余:%d秒",READ_CARD_TIMEOUT];
    remainTime.textColor = [UIColor blackColor];
    remainTime.backgroundColor = [UIColor clearColor];
    [contentView addSubview:remainTime];
    
    //滚动文字
    UIScrollView *guideTextScrollView = [[UIScrollView alloc] init];
    guideTextScrollView.frame = CGRectMake(0, MARGIN_TOP,contentView.frame.size.width,contentView.frame.size.height-MARGIN_TOP-15);
    [contentView addSubview:guideTextScrollView];
    
    //引导文字
    UILabel *guideText = [[UILabel alloc] init];
    guideText.font = [UIFont systemFontOfSize:14];
    guideText.textColor = [UIColor blackColor];
    guideText.lineBreakMode = UILineBreakModeCharacterWrap;
    guideText.numberOfLines = 0;
    guideText.backgroundColor = [UIColor clearColor];
    guideText.text = @"1. 刷卡时请把银行卡有磁条一边面对自己，磁条部分向下放置，平稳匀速滑过磁头，向左滑动或向右滑动均可。\r\n2. 可以拔出设备刷卡和输密码，待操作完成后，需将设备重新插入耳机口。\r\n3. 如银行卡未设置密码，刷卡完成后请直接按确认键。\r\n4. 若刷卡无反应或提示刷卡失败，请稍作等待重新刷卡即可。\r\n5. 若多次刷卡仍无反应，请重新拔插设备或退出程序重试。";
    float height = [Helper getLabelHeight:guideText.text setfont:guideText.font setwidth:contentView.frame.size.width-20];
    guideText.frame = CGRectMake(10, 5, contentView.frame.size.width-20, height);
    
    guideTextScrollView.contentSize = CGSizeMake(guideTextScrollView.frame.size.width, height+20);
    
    [guideTextScrollView addSubview:guideText];
    [guideText release];
    [guideTextScrollView release];

    [self hideBackButton];
    
    //播放动画
    [self playAnimation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //进来时候如果刷卡器是连接的
    if([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:NSSTRING_YES]&&
       [PosMiniDevice sharedInstance].isDeviceLegal == YES)
    {
        //查询刷卡器状态
        [[PosMiniDevice sharedInstance].posReq reqDeviceStatus];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(posApplicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(posApplicationWillEnterForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 播放动画提示用户刷卡
 */
-(void)playAnimation

{
    //恢复初始位置
    bankCardView.frame = CGRectMake(-150, MARGIN_TOP-30-117-90,174, 113);
    
    //播放动画提示用户刷卡
    [UIView beginAnimations:nil context:nil];
    //setAnimationCurve来定义动画加速或减速方式
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:2.5]; //动画时长
    [UIView setAnimationRepeatCount:INT64_MAX];
    bankCardView.frame = CGRectMake(310, bankCardView.frame.origin.y, bankCardView.frame.size.width, bankCardView.frame.size.height);
    [UIView commitAnimations];
}

//计时Timer失效
-(void)invalidateTimer{
    if (timer!=nil) {
        isTimerValid = NO;
        [timer invalidate];
        self.timer = nil;
    }
}

/**
 timer事件
 @param sender 系统参数
 */
-(void) timeEvent:(id)sender
{
    timeCount--;
    
    remainTime.text =[NSString stringWithFormat:@"剩余:%d秒",timeCount];
    //如果跳转到其他页面，使Time失效
    if (isTimerValid && timer!=nil) {
        //计时Timer失效
        [self invalidateTimer];
        
        return;
    }
    if (timeCount==0) {
        //如果刷卡时间超时，提示用户
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"刷卡超时!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        //计时Timer失效
        [self invalidateTimer];
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //退款成功
    if (alertView.tag==2) {
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ORDER_NEED_REFRESH];
    }
    
    [self invalidateTimer];
    
    //返回输入收款页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//进入后台
-(void)posApplicationDidEnterBackground:(NSNotification *)notify{
    /*
    if (timer!=nil) {
        //暂停Timer
        [timer setFireDate:[NSDate distantFuture]];
    }
    */
}

//回到前台
-(void)posApplicationWillEnterForeground:(NSNotification *)notify{
    //timer 不做暂停
    /*
    if (timer!=nil) {
        //暂停Timer
        [timer setFireDate:[NSDate date]];
    }
    */
    [self playAnimation];
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    if (self.scType == REFOUND_SWIPE_TYPE) {
        return @"pos00009";
    }
    return @"0";
}


@end
