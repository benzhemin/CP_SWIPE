//
//  DefaultBusinessViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultBusinessViewController.h"
#import "DefaultReceiptViewController.h"
#import "ConvenienceBusinessViewController.h"
#import "ElectronicSignRequisitionsViewController.h"


@interface DefaultBusinessViewController ()

@end

@implementation DefaultBusinessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)init{
    if (self=[super init]) {
        authorityService=[[AuthorityService alloc]init];
        
        [authorityService onRespondTarget:self];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.logoImage=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"business-top_logo"]]autorelease];
    _logoImage.frame=CGRectMake(20, 50, 549/2, 61/2);
    [contentView addSubview:_logoImage];
    
    self.businessNameLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 110, 320, 30)]autorelease];
    _businessNameLabel.text=[Helper getValueByKey:POSMINI_LOGIN_USERNAME];
    _businessNameLabel.textColor=[UIColor darkGrayColor];
    _businessNameLabel.textAlignment=NSTextAlignmentCenter;
    _businessNameLabel.font=[UIFont systemFontOfSize:20];
    _businessNameLabel.backgroundColor=[UIColor clearColor];
    [contentView addSubview:_businessNameLabel];
    
    self.phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_phoneButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _phoneButton.tag=1;
    _phoneButton.exclusiveTouch=YES;
    [_phoneButton setImage:[UIImage imageNamed:@"business-recharge"] forState:UIControlStateNormal];
    _phoneButton.frame= CGRectMake(23,150, 64, 64);
    [contentView addSubview:_phoneButton];
    
    self.phoneLabel=[[[UILabel alloc]initWithFrame:CGRectMake(25, 215, 60, 30)]autorelease];
    _phoneLabel.text=@"手机充值";
    _phoneLabel.font=[UIFont systemFontOfSize:14];
    _phoneLabel.textAlignment=NSTextAlignmentCenter;
    _phoneLabel.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    _phoneLabel.backgroundColor=[UIColor clearColor];
    [contentView addSubview:_phoneLabel];
    
    self.movieButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_movieButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _movieButton.tag=2;
    _movieButton.exclusiveTouch=YES;
    [_movieButton setImage:[UIImage imageNamed:@"business-ticket"] forState:UIControlStateNormal];
    self.movieButton.frame= CGRectMake(93,150, 64, 64);
    [contentView addSubview:_movieButton];
    
    self.movieLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 215, 60, 30)]autorelease];
    _movieLabel.text=@"电影票";
    _movieLabel.textAlignment=NSTextAlignmentCenter;
    _movieLabel.font=[UIFont systemFontOfSize:14];
    _movieLabel.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    _movieLabel.backgroundColor=[UIColor clearColor];
    [contentView addSubview:_movieLabel];
    
    self.trafficButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_trafficButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _trafficButton.tag=3;
    _trafficButton.exclusiveTouch=YES;
    [_trafficButton setImage:[UIImage imageNamed:@"business-traffic"] forState:UIControlStateNormal];
    _trafficButton.frame= CGRectMake(163,150, 64, 64);
    [contentView addSubview:_trafficButton];
    
    self.trafficLabel=[[[UILabel alloc]initWithFrame:CGRectMake(165, 215, 60, 30)]autorelease];
    _trafficLabel.text=@"交通违章";
    _trafficLabel.textAlignment=NSTextAlignmentCenter;
    _trafficLabel.font=[UIFont systemFontOfSize:14];
    _trafficLabel.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    self.trafficLabel.backgroundColor=[UIColor clearColor];
    [contentView addSubview:_trafficLabel];
    
    self.moneyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_moneyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _moneyButton.tag=10;
    _moneyButton.exclusiveTouch=YES;
    [_moneyButton setImage:[UIImage imageNamed:@"business-pos"] forState:UIControlStateNormal];
    _moneyButton.frame= CGRectMake(233,150, 64, 64);
    [contentView addSubview:_moneyButton];
    
    self.moneyLabel=[[[UILabel alloc]initWithFrame:CGRectMake(235, 215, 60, 30)]autorelease];
    _moneyLabel.text=@"我要收款";
    _moneyLabel.textAlignment=NSTextAlignmentCenter;
    _moneyLabel.font=[UIFont systemFontOfSize:14];
    _moneyLabel.textColor=[UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
    _moneyLabel.backgroundColor=[UIColor clearColor];
    [contentView addSubview:_moneyLabel];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    
    [authorityService requestForAuthority:dict];
}

#pragma mark -
-(void)authorityRequestDidFinished{
    self.businessOpenStatusDict=authorityService.businessOpenStatusDict;
}
#pragma mark -
/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00013";
}

#pragma mark - buttonClick
-(void)buttonClick:(id)sender{
    UIButton *tempButton = (UIButton *)sender;
    
    if (tempButton.tag==10) {
        
        if ([[_businessOpenStatusDict valueForKey:@"RecvBusi"] isEqualToString:@"C"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"暂未开通此业务!"];
        }else{
            //记录下选择的收款类型
            [[PosMiniDevice sharedInstance] setDifferentBusiness:NORMAL_BUSINESS];
            
            DefaultReceiptViewController *dr=[[DefaultReceiptViewController alloc]init];
            [self.navigationController pushViewController:dr animated:YES];
            [dr release];
        }
    }else{
        if ([[_businessOpenStatusDict valueForKey:@"PersonalBusi"] isEqualToString:@"C"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"暂未开通此业务!"];
        }else{
            //选择的是便民业务
            [[PosMiniDevice sharedInstance] setDifferentBusiness:CONVENIENCE_BUSINESS];
            
            ConvenienceBusinessViewController *cb=[[ConvenienceBusinessViewController alloc]init];
            if (tempButton.tag==1) {
                
                [[PosMiniDevice sharedInstance] setBusinessType:CONVENIENCE_BUSINESS_PHONE];
                cb.receivedURL=@"http://dawnsky2012.xicp.net:7080/chongzhi/orderlist.jsp";
                
            }else if (tempButton.tag==2){
                
                [[PosMiniDevice sharedInstance] setBusinessType:CONVENIENCE_BUSINESS_MOVIE];
                cb.receivedURL=@"http://dawnsky2012.xicp.net:7080/dianying";
                
            }else{
                
                [[PosMiniDevice sharedInstance] setBusinessType:CONVENIENCE_BUSINESS_TRAFFIC];
                cb.receivedURL=@"http://dawnsky2012.xicp.net:7080/fakuan/zonghangJTFK/index.jsp";
                
            }
            cb.isShowTabBar=NO;
            cb.isShowNaviBar=NO;
            
            [self.navigationController pushViewController:cb animated:YES];
            [cb release];
            
        }
        
    }
}

#pragma mark - 内存清理
-(void)dealloc{
    [_businessOpenStatusDict release];
    [authorityService release];
    [_logoImage release];
    [_businessNameLabel release];
    [_phoneButton release];
    [_phoneLabel release];
    [_movieButton release];
    [_movieLabel release];
    [_trafficButton release];
    [_trafficLabel release];
    [_moneyButton release];
    [_moneyLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
