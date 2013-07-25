//
//  ReceiptConfirmViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ReceiptConfirmViewController.h"
#import "PosMiniDevice.h"

@interface ReceiptConfirmViewController ()

@end

@implementation ReceiptConfirmViewController

@synthesize recpBgView, confirmBtn;

-(void)dealloc{
    [recpBgView release];
    [confirmBtn release];
    [super dealloc];
}

#define LABEL_TITLE_WIDTH 80
#define RECEIPT_VIEW_HEIGHT 300
#define DASH_LINE_HEIGHT 70
#define FULL_LINE_HEIGHT (70+72)

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"刷卡收款"];
    
    UIImage *btmImg = [UIImage imageNamed:@"btm.png"];
    
    self.recpBgView = [[[ReceiptBgView alloc] init] autorelease];
    recpBgView.dashLineHeight = DASH_LINE_HEIGHT;
    recpBgView.fullLineHeight = FULL_LINE_HEIGHT;
    recpBgView.frame = CGRectMake(0, 0, btmImg.size.width, RECEIPT_VIEW_HEIGHT-btmImg.size.height);
    recpBgView.center = CGPointMake(contentView.center.x, recpBgView.center.y);
    [contentView addSubview:recpBgView];
    
    //显示收款账户标题
    UILabel *accountLabelTitle = [[UILabel alloc] init];
    accountLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    accountLabelTitle.font = [UIFont systemFontOfSize:16];
    accountLabelTitle.text = [NSString stringWithFormat:@"收款账户:"];
    accountLabelTitle.frame = CGRectMake(20, 10, LABEL_TITLE_WIDTH, 20);
    accountLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:accountLabelTitle];
    [accountLabelTitle release];
    
    //收款账户
    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    accountLabel.font = [UIFont systemFontOfSize:16];
    accountLabel.text = [NSString stringWithFormat:@"%@ %@",[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT],
                         [Helper getValueByKey:POSMINI_LOGIN_USERNAME]];
    accountLabel.frame = CGRectMake(accountLabelTitle.frame.origin.x+accountLabelTitle.frame.size.width, 10, 190, 20);
    accountLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:accountLabel];
    [accountLabel release];
    
    //显示订单号标题
    UILabel *orderLabelTitle = [[UILabel alloc]init];
    orderLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderLabelTitle.font = [UIFont systemFontOfSize:16];
    orderLabelTitle.text = @"订  单 号：";
    orderLabelTitle.frame = CGRectMake(20, 40, LABEL_TITLE_WIDTH, 20);
    orderLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderLabelTitle];
    [orderLabelTitle release];
    
    //显示订单号
    UILabel *orderLabel = [[UILabel alloc]init];
    orderLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderLabel.font = [UIFont systemFontOfSize:16];
    orderLabel.text = [PosMiniDevice sharedInstance].orderId;
    orderLabel.frame = CGRectMake(orderLabelTitle.frame.size.width+orderLabelTitle.frame.origin.x, 40, 190, 20);
    orderLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderLabel];
    [orderLabel release];
    
    //订单金额标题
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.textColor = [UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0];
    noticeLabel.font = [UIFont boldSystemFontOfSize:20];
    noticeLabel.text = @"订单金额:";
    noticeLabel.frame = CGRectMake(20, recpBgView.dashLineHeight+10, 100, 25);
    noticeLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:noticeLabel];
    [noticeLabel release];
    
    //订单金额
    UILabel *figureLabel = [[UILabel alloc]init];
    figureLabel.textColor = [UIColor colorWithRed:186/250.0 green:0/250.0 blue:0/250.0 alpha:1.0];
    figureLabel.font = [UIFont boldSystemFontOfSize:24];
    figureLabel.text = [NSString stringWithFormat:@"%0.2f",[[PosMiniDevice sharedInstance].paySum floatValue]];
    figureLabel.adjustsFontSizeToFitWidth = YES;
    figureLabel.frame = CGRectMake(20, noticeLabel.frame.size.height+noticeLabel.frame.origin.y, 210, 30);
    figureLabel.textAlignment = UITextAlignmentRight;
    figureLabel.contentMode = UIViewContentModeCenter;
    [recpBgView addSubview:figureLabel];
    [figureLabel release];
    
    //订单单位
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = [UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0];
    unitLabel.font = [UIFont boldSystemFontOfSize:20];
    unitLabel.text = @"元";
    unitLabel.frame = CGRectMake(240,noticeLabel.frame.size.height+noticeLabel.frame.origin.y, 40, 30);
    unitLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:unitLabel];
    [unitLabel release];
    
    //确认收款按钮
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确 认 后 刷 卡" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [recpBgView addSubview:confirmBtn];
}


-(void)pay:(id)sender{
    
}





@end
