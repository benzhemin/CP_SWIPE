//
//  SignLandscapeViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SignLandscapeViewController.h"
#import "PayConfirmViewController.h"

@interface SignLandscapeViewController ()

@end

@implementation SignLandscapeViewController

@synthesize signView, confirmBtn;
@synthesize clearBtn, showHint, clearLabel;
@synthesize hintMsgLabel;

-(void)dealloc{
    [signView release];
    [confirmBtn release];
    [clearBtn release];
    [clearLabel release];
    [super dealloc];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"电子签名"];
    
    //设置状态栏为横屏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    
    //添加签名UIView
    self.signView = [[[SignView alloc] init] autorelease];
    [contentView addSubview:signView];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:15]forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [naviBgView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmSign:) forControlEvents:UIControlEventTouchUpInside];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"del-btn.png"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearSign:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:clearBtn];
    [contentView bringSubviewToFront:clearBtn];
    
    //提示删除签名Label
    self.clearLabel = [[[UILabel alloc] init] autorelease];
    clearLabel.text=@"删除签名";
    clearLabel.userInteractionEnabled = YES;
    clearLabel.backgroundColor = [UIColor clearColor];
    clearLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:clearLabel];
    [clearLabel release];
    [contentView bringSubviewToFront:clearLabel];
    
    //注册触摸手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClearGesture:)];
    [clearLabel addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    //提示view的状态
    self.showHint = NO;
    //添加提示UIView
    self.hintMsgLabel = [[[UILabel alloc] init] autorelease];
    hintMsgLabel.frame = CGRectMake(0, 0, 80, 30);
    hintMsgLabel.text = @"请签名!";
    hintMsgLabel.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    hintMsgLabel.textColor = [UIColor whiteColor];
    hintMsgLabel.textAlignment = NSTextAlignmentCenter;
    hintMsgLabel.font = [UIFont systemFontOfSize:14];
    hintMsgLabel.layer.cornerRadius = 10.0;
    [self.signView addSubview:hintMsgLabel];
    [signView bringSubviewToFront:hintMsgLabel];
    hintMsgLabel.alpha = 0.0f;
    
    //获取状态栏大小
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBounds = CGRectMake(0, 0, statusBarFrame.size.height, statusBarFrame.origin.x);
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    bounds = CGRectMake(0.f, 0.f, bounds.size.height, bounds.size.width);
    
    CGPoint center = CGPointMake(statusBounds.size.height / 2.0, statusBounds.size.width / 2.0);
    
    //设置view的中心为整个window的中心
    self.view.center = center;
    //旋转90度
    CGAffineTransform transform = self.view.transform;
    transform = CGAffineTransformRotate(transform, (M_PI / 2.0));
    self.view.transform = transform;
    
    //设置View层次大小
    self.bgImageView.frame = bounds;
    self.naviBgView.frame = CGRectMake(0, DEFAULT_STATUS_BAR_HEIGHT, bounds.size.width, DEFAULT_NAVIGATION_BAR_HEIGHT);
    self.naviTitleLabel.center = CGPointMake(naviBgView.center.x, naviTitleLabel.center.y);
    self.contentView.frame = CGRectMake(0,
                                        DEFAULT_STATUS_BAR_HEIGHT+44,
                                        bounds.size.width,
                                        bounds.size.height-DEFAULT_STATUS_BAR_HEIGHT-DEFAULT_NAVIGATION_BAR_HEIGHT);
    self.signView.frame = contentView.bounds;
    self.confirmBtn.frame = CGRectMake(bounds.size.width-72, 7, 65, 31);
    self.clearBtn.frame = CGRectMake(signView.bounds.size.width/2-50, signView.bounds.size.height-40, 22, 35);
    self.clearLabel.frame = CGRectMake(signView.bounds.size.width/2-20, signView.bounds.size.height-40, 100, 35);
    self.hintMsgLabel.center = CGPointMake(signView.center.x, signView.center.y+70);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([PosMiniDevice sharedInstance].pointsList.count > 0) {
        [self.signView drawSignFromArray:[PosMiniDevice sharedInstance].pointsList];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/**
 处理用户触摸事件
 @param tap 系统参数
 */
-(void) tapClearGesture:(UITapGestureRecognizer *)tap
{
    [signView clear];
}

/**
 清除签名
 */
-(void)clearSign:(id)sender{
    [signView clear];
}

-(void)displayHintMessage{
    self.hintMsgLabel.alpha = 1.0;
    //[self performSelector:@selector(hideHintMessage) withObject:nil afterDelay:2.0];
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [hintMsgLabel.layer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(hideHintMessage) withObject:hintMsgLabel afterDelay:1.5];
}

-(void)hideHintMessage{
    hintMsgLabel.alpha = 0.0;
}

-(void)confirmSign:(id)sender{
    if ([self.signView pointsList].count < 10) {
        [self displayHintMessage];
        return;
    }
    
    //设置全局签名为当前签名
    //原来的需求:支付失败,弹出提示框,对应两个按钮:重新支付,取消,用户点击重新支付后保留用户签名.
    //目前支付失败只弹出确定,然后重新做交易流程
    //[PosMiniDevice sharedInstance].pointsList = self.signView.pointsList;
    
    
    //保留用户签名
    [PosMiniDevice sharedInstance].signImg = [Helper imageWithView:signView];
    //恢复statusBar
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    //确认支付
    PayConfirmViewController *pc = [[PayConfirmViewController alloc] init];
    pc.isShowTabBar = NO;
    [self.navigationController pushViewController:pc animated:YES];
    [pc release];
}

//返回之前调整StatusBar
-(void)backToPreviousView:(id)sender{
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否取消交易？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag=1;
    [alertView show];
    [alertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //是否取消支付
    if (alertView.tag==1)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00004";
}


@end















