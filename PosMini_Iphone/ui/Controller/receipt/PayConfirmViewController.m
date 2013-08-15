//
//  PayConfirmViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PayConfirmViewController.h"
#import "LocationService.h"
#import "PayService.h"

@interface PayConfirmViewController ()

@end

@implementation PayConfirmViewController

@synthesize recpBgView, ps;

-(void)dealloc{
    [recpBgView release];
    [ps release];
    
    [super dealloc];
}

#define LABEL_TITLE_WIDTH 80

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNavigationTitle:@"交易确认"];
    
    UIImage *btmImg = [UIImage imageNamed:@"btm.png"];
    
    //收据背景
    self.recpBgView = [[[ReceiptBgView alloc] init] autorelease];
    recpBgView.dashLineHeight = 90.0f;
    recpBgView.fullLineHeight = 0.0f;
    recpBgView.frame = CGRectMake(0, 0, 296, 261);
    recpBgView.center = CGPointMake(contentView.center.x, recpBgView.center.y);
    [contentView addSubview:recpBgView];
    
    //底部图片
    UIImageView *btmImgView = [[UIImageView alloc] initWithImage:btmImg];
    btmImgView.frame = CGRectMake((contentView.bounds.size.width-btmImg.size.width)/2,
                                  recpBgView.frame.size.height, btmImg.size.width, btmImg.size.height);
    [contentView addSubview:btmImgView];
    [btmImgView release];
    
    
    //显示收款账户标题
    UILabel *accountLabelTitle = [[UILabel alloc]init];
    accountLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    accountLabelTitle.font = [UIFont systemFontOfSize:16];
    accountLabelTitle.text = [NSString stringWithFormat:@"收款账户:"];
    accountLabelTitle.frame = CGRectMake(20, 10, LABEL_TITLE_WIDTH, 20);
    accountLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:accountLabelTitle];
    [accountLabelTitle release];
    
    //收款账户
    UILabel *accountLabel = [[UILabel alloc]init];
    accountLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    accountLabel.font = [UIFont systemFontOfSize:16];
    accountLabel.text = [NSString stringWithFormat:@"%@ %@",[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT],[Helper getValueByKey:POSMINI_LOGIN_USERNAME]];
    accountLabel.frame = CGRectMake(accountLabelTitle.frame.origin.x+accountLabelTitle.frame.size.width, 10, 190, 20);
    accountLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:accountLabel];
    [accountLabel release];
    
    
    //显示订单号标题
    UILabel *orderLabelTitle = [[UILabel alloc]init];
    orderLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderLabelTitle.font = [UIFont systemFontOfSize:16];
    orderLabelTitle.text = @"订  单 号：";
    orderLabelTitle.frame = CGRectMake(20, 35, LABEL_TITLE_WIDTH, 20);
    orderLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderLabelTitle];
    [orderLabelTitle release];
    
    //显示订单号
    UILabel *orderLabel = [[UILabel alloc]init];
    orderLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderLabel.font = [UIFont systemFontOfSize:16];
    orderLabel.text = [PosMiniDevice sharedInstance].orderId;
    orderLabel.frame = CGRectMake(orderLabelTitle.frame.size.width+orderLabelTitle.frame.origin.x, 35, 190, 20);
    orderLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderLabel];
    [orderLabel release];
    
    //显示订单金额标题
    UILabel *orderSumTitle = [[UILabel alloc]init];
    orderSumTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderSumTitle.font = [UIFont systemFontOfSize:16];
    orderSumTitle.text = @"订单金额：";
    orderSumTitle.frame = CGRectMake(20, 60,LABEL_TITLE_WIDTH, 20);
    orderSumTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderSumTitle];
    [orderSumTitle release];
    
    //显示订单金额
    UILabel *orderSum = [[UILabel alloc]init];
    orderSum.textColor = [UIColor colorWithRed:187/250.0 green:0 blue:0 alpha:1.0];
    orderSum.font = [UIFont boldSystemFontOfSize:16];
    orderSum.text = [NSString stringWithFormat:@"%0.2f",[[PosMiniDevice sharedInstance].paySum floatValue]];
    float labelWidth = [Helper getLabelWidth:orderSum.text setFont:orderSum.font setHeight:20];
    orderSum.frame = CGRectMake(orderSumTitle.frame.origin.x+orderSumTitle.frame.size.width, 60, labelWidth, 20);
    orderSum.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderSum];
    [orderSum release];
    
    UIImageView *signImgView = [[UIImageView alloc] initWithImage:[PosMiniDevice sharedInstance].signImg];
    signImgView.frame = CGRectMake(0, 90, 296, 172);
    [recpBgView addSubview:signImgView];
    [signImgView release];
    
    //确认收款按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(confirmPay:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确  认  支  付" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    confirmButton.frame = CGRectMake(0, 296, 274, 47);
    [contentView addSubview:confirmButton];
    confirmButton.center = CGPointMake(contentView.center.x, confirmButton.center.y);
}

//确定支付
-(void)confirmPay:(id)sender{
    self.ps = [[[PayService alloc] init] autorelease];
    [ps onRespondTarget:self];
    
    LocationService *loc = [LocationService sharedInstance];
    //登录之后已获取到经纬度
    if ([loc isCoordinationEmpty] == YES) {
        if ([loc startToLocateWithAuthentication:YES]) {
            //等待定位成功
            [ps performSelector:@selector(requestForPayTrans) withObject:nil];
        }else{
            return;
        }
    }else{
        [ps requestForPayTrans];
    }
}


//返回之前调整StatusBar
-(void)backToPreviousView:(id)sender{
    //设置状态栏为横屏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    
    [super backToPreviousView:sender];
}


@end













