//
//  ElectronicSignRequisitionsViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ElectronicSignRequisitionsViewController.h"
#import "SendMessageAndEmailViewController.h"


@interface ElectronicSignRequisitionsViewController ()

@end

@implementation ElectronicSignRequisitionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"签购单"];
    
    self.naviBackBtn.hidden=YES;
    self.eSignImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, contentView.frame.size.height)]autorelease];
    if (!IS_IPHONE5) {
        _eSignImageView.image=[UIImage imageNamed:@"e_receipt_bg"];
    }else{
        _eSignImageView.image=[UIImage imageNamed:@"e_receipt_bg-568"];
    }
    _eSignImageView.userInteractionEnabled=YES;
    [contentView addSubview:_eSignImageView];
    
    
    UILabel *merName=[[UILabel alloc]initWithFrame:CGRectMake(25, 72, 270, 15)];
    merName.backgroundColor=[UIColor clearColor];
    merName.font=[UIFont systemFontOfSize:14];
    merName.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    merName.text=[PosMiniDevice sharedInstance].esMerName;
    merName.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:merName];
    [merName release];
    
    UILabel *orderNo=[[UILabel alloc]initWithFrame:CGRectMake(90, 98, 200, 15)];
    orderNo.backgroundColor=[UIColor clearColor];
    orderNo.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    orderNo.font=[UIFont systemFontOfSize:13];
    orderNo.text = [PosMiniDevice sharedInstance].esOrdId;
    orderNo.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:orderNo];
    [orderNo release];
    
    UILabel *merchantNo=[[UILabel alloc]initWithFrame:CGRectMake(90, 124, 200, 15)];
    merchantNo.backgroundColor=[UIColor clearColor];
    if ([[[PosMiniDevice sharedInstance] differentBusiness] isEqualToString:NORMAL_BUSINESS]) {
        merchantNo.text=[Helper getValueByKey:POSMINI_CUSTOMER_ID];
    }else{
        merchantNo.text=[PosMiniDevice sharedInstance].esProviderCustId;;
    }
   
    merchantNo.font=[UIFont systemFontOfSize:13];
    merchantNo.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    merchantNo.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:merchantNo];
    [merchantNo release];
    
    UILabel *terminalId=[[UILabel alloc]initWithFrame:CGRectMake(90, 152, 200, 15)];
    terminalId.backgroundColor=[UIColor clearColor];
    terminalId.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    terminalId.font=[UIFont systemFontOfSize:13];
    terminalId.text=[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID];
    terminalId.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:terminalId];
    [terminalId release];
    
    UILabel *cardId=[[UILabel alloc]initWithFrame:CGRectMake(90, 181, 200, 15)];
    cardId.backgroundColor=[UIColor clearColor];
    cardId.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    cardId.font=[UIFont systemFontOfSize:13];
    cardId.text=[PosMiniDevice sharedInstance].esCardNo;
    cardId.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:cardId];
    [cardId release];
    
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(90, 207, 200, 15)];
    date.backgroundColor=[UIColor clearColor];
    date.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    date.font=[UIFont systemFontOfSize:13];
    NSString *tmpTime=[NSString stringWithFormat:@"%@%@",[PosMiniDevice sharedInstance].esCurrentDate,[PosMiniDevice sharedInstance].esCurrentTime];
    date.text=[self getDataWithDataString:tmpTime];
    date.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:date];
    [date release];
    
    UILabel *amount=[[UILabel alloc]initWithFrame:CGRectMake(90, 233, 200, 15)];
    amount.backgroundColor=[UIColor clearColor];
    amount.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    amount.font=[UIFont systemFontOfSize:13];
    amount.text=[NSString stringWithFormat:@"%0.2f 元",[[PosMiniDevice sharedInstance].esOrdAmt floatValue]];
    amount.textAlignment=NSTextAlignmentRight;
    [_eSignImageView addSubview:amount];
    [amount release];
    
    //签名
    UIImageView *signImgView = [[UIImageView alloc] initWithImage:[PosMiniDevice sharedInstance].signImg];
    //故障对应#0002733
    signImgView.frame = CGRectMake(25, 280, 220, 60);
    [_eSignImageView addSubview:signImgView];
    [signImgView release];
    
    
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.exclusiveTouch=YES;
    _cancelButton.frame=CGRectMake(27, contentView.frame.size.height-68, 252/2 , 93/2);
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"e_receipt_blue_btn"] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"不发送签购单" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.tag=1;
    [self.eSignImageView addSubview:_cancelButton];
    
    
    self.sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.exclusiveTouch=YES;
    _sendButton.frame=CGRectMake(167, contentView.frame.size.height-68, 252/2 , 93/2);
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"e_receipt_red_btn"] forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送签购单" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.tag=2;
    [self.eSignImageView addSubview:_sendButton];
    
}
-(void)buttonClick:(id)sender{
    UIButton *tempBtn=(UIButton *)sender;
    
    if (tempBtn.tag==1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        SendMessageAndEmailViewController *sendVC=[[SendMessageAndEmailViewController alloc]init];
        sendVC.isShowTabBar=NO;
        [self.navigationController pushViewController:sendVC animated:YES];
        [sendVC release];
    }
}

/**
 获取有省略号的银行卡号
 @param bankNum 原始银行卡号
 @returns 经过处理的银行卡号
 */
-(NSString *) getBankNumWithOmit:(NSString *)bankNum
{
    return [NSString stringWithFormat:@"%@ **** **** %@",[bankNum substringToIndex:6],[bankNum substringWithRange:NSMakeRange(bankNum.length-4, 4)]];
}

/**
 获取有省略号的银行卡号
 @param dataString 原始日期字符串
 @returns 经过处理的日期字符串
 */
-(NSString *) getDataWithDataString:(NSString *)dataString
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:dataString];

    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [outputFormatter stringFromDate:inputDate];
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00018";
}
#pragma mark - 内存清理
-(void)dealloc{
    [_sendButton release];
    [_cancelButton release];
    [_eSignImageView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
