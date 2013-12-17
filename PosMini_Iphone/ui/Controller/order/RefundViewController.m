//
//  RefoundViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RefundViewController.h"
#import "PosMiniDevice.h"

@interface RefundViewController ()

@end

@implementation RefundViewController

@synthesize recpBgView, confirmBtn;
@synthesize orderId, paySum, tradeTime;

-(void)dealloc{
    [recpBgView release];
    
    [orderId release];
    [paySum release];
    [tradeTime release];
    
    [confirmBtn release];
    
    [posService release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        posService = [[PosMiniService alloc] init];
    }
    return self;
}

#define LABEL_TITLE_WIDTH 80
#define DASH_LINE_HEIGHT 140
#define FULL_LINE_HEIGHT (140+72)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"退款"];
    
    UIImage *btmImg = [UIImage imageNamed:@"btm.png"];
    
    //收据背景
    self.recpBgView = [[[ReceiptBgView alloc] init] autorelease];
    recpBgView.dashLineHeight = DASH_LINE_HEIGHT;
    recpBgView.fullLineHeight = FULL_LINE_HEIGHT;
    recpBgView.frame = CGRectMake(0, 0, btmImg.size.width, 325);
    recpBgView.center = CGPointMake(contentView.center.x, recpBgView.center.y);
    [contentView addSubview:recpBgView];
    
    //底部图片
    UIImageView *btmImgView = [[UIImageView alloc] initWithImage:btmImg];
    btmImgView.frame = CGRectMake((contentView.bounds.size.width-btmImg.size.width)/2,
                                  recpBgView.frame.size.height, btmImg.size.width, btmImg.size.height);
    [contentView addSubview:btmImgView];
    [btmImgView release];
    
    //显示交易时间标题
    UILabel *tradeTimeLabelTitle = [[UILabel alloc]init];
    tradeTimeLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    tradeTimeLabelTitle.font = [UIFont systemFontOfSize:16];
    tradeTimeLabelTitle.text = [NSString stringWithFormat:@"交易时间:"];
    tradeTimeLabelTitle.frame = CGRectMake(20, 10, LABEL_TITLE_WIDTH, 20);
    tradeTimeLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:tradeTimeLabelTitle];
    [tradeTimeLabelTitle release];
    
    //交易时间
    UILabel *tradeTimeLabel = [[UILabel alloc]init];
    tradeTimeLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    tradeTimeLabel.font = [UIFont systemFontOfSize:16];
    tradeTimeLabel.text = [NSString stringWithFormat:@"%@时%@分%@秒",
                           [self.tradeTime substringWithRange:NSMakeRange(0, 2)],
                           [self.tradeTime substringWithRange:NSMakeRange(2, 2)],
                           [self.tradeTime substringWithRange:NSMakeRange(4, 2)]];
    tradeTimeLabel.frame = CGRectMake(tradeTimeLabelTitle.frame.origin.x+tradeTimeLabelTitle.frame.size.width, 10, 190, 20);
    tradeTimeLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:tradeTimeLabel];
    [tradeTimeLabel release];
    
    
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
    orderLabel.text = self.orderId;
    orderLabel.frame = CGRectMake(orderLabelTitle.frame.size.width+orderLabelTitle.frame.origin.x, 40, 190, 20);
    orderLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderLabel];
    [orderLabel release];
    
    //交易金额标题
    UILabel *tradeLabelTitle = [[UILabel alloc]init];
    tradeLabelTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    tradeLabelTitle.font = [UIFont systemFontOfSize:16];
    tradeLabelTitle.text = [NSString stringWithFormat:@"交易金额:"];
    tradeLabelTitle.frame = CGRectMake(20, 70, LABEL_TITLE_WIDTH, 20);
    tradeLabelTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:tradeLabelTitle];
    [tradeLabelTitle release];
    
    //显示交易金额
    UILabel *tradeamountLabel = [[UILabel alloc]init];
    tradeamountLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    tradeamountLabel.font = [UIFont systemFontOfSize:16];
    /*Mod_S 启明 张翔 功能点:追加金额单位*/
//    tradeamountLabel.text = self.paySum;
    tradeamountLabel.text = [NSString stringWithFormat:@"%@元",self.paySum];
    /*Mod_D 启明 张翔 功能点:追加金额单位*/
    tradeamountLabel.frame = CGRectMake(tradeTimeLabelTitle.frame.origin.x+tradeTimeLabelTitle.frame.size.width, 70, 190, 20);
    tradeamountLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:tradeamountLabel];
    [tradeamountLabel release];
    
    //订单状态标题
    UILabel *orderStatusTitle = [[UILabel alloc]init];
    orderStatusTitle.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderStatusTitle.font = [UIFont systemFontOfSize:16];
    orderStatusTitle.text = [NSString stringWithFormat:@"订单状态:"];
    orderStatusTitle.frame = CGRectMake(20, 100, LABEL_TITLE_WIDTH, 20);
    orderStatusTitle.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderStatusTitle];
    [orderStatusTitle release];
    
    //显示订单状态
    UILabel *orderStatus = [[UILabel alloc]init];
    orderStatus.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    orderStatus.font = [UIFont systemFontOfSize:16];
    orderStatus.text = @"已支付";
    orderStatus.frame = CGRectMake(tradeTimeLabelTitle.frame.origin.x+tradeTimeLabelTitle.frame.size.width, 100, 190, 20);
    orderStatus.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:orderStatus];
    [orderStatus release];
    
    
    //退款金额标题
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.textColor = [UIColor colorWithRed:51/250.0 green:51/250.0 blue:51/250.0 alpha:1.0];
    noticeLabel.font = [UIFont boldSystemFontOfSize:20];
    noticeLabel.text = @"退款金额:";
    noticeLabel.frame = CGRectMake(20, DASH_LINE_HEIGHT+10, 100, 25);
    noticeLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:noticeLabel];
    [noticeLabel release];
    
    //退款金额
    UILabel *figureLabel = [[UILabel alloc]init];
    figureLabel.textColor = [UIColor colorWithRed:186/250.0 green:0/250.0 blue:0/250.0 alpha:1.0];
    figureLabel.font = [UIFont boldSystemFontOfSize:24];
    figureLabel.text = self.paySum;
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
    
    //确认退款按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake((recpBgView.frame.size.width-274)/2, 240, 274, 47);
    [confirmBtn addTarget:self action:@selector(confirmRefund:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确     认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [recpBgView addSubview:confirmBtn];
}

-(void)confirmRefund:(id)sender{
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:NSSTRING_YES]) {
        if ([PosMiniDevice sharedInstance].isDeviceLegal == YES) {
            [posService requestForPosTradeSignIn:[PosMiniDevice sharedInstance].deviceSN];
        }else{
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"不是合法设备"];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请插入设备"];
    }
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00010";
}

@end
