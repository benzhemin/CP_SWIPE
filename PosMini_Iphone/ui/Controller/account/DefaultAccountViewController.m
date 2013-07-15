//
//  DefaultAccountViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultAccountViewController.h"

@interface DefaultAccountViewController ()

@end

@implementation DefaultAccountViewController

@synthesize acctInfoTableView;

-(void)dealloc{
    [acctInfoTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"账户信息"];
    
    //设置显示账户信息Table
    self.acctInfoTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 15, contentView.frame.size.width,contentView.frame.size.height-15) style:UITableViewStyleGrouped] autorelease];
    acctInfoTableView.backgroundView = nil;
    acctInfoTableView.backgroundColor = [UIColor clearColor];
    acctInfoTableView.delegate = self;
    acctInfoTableView.dataSource = self;
    [contentView addSubview:acctInfoTableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //记录当前登录成功日期
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    BOOL loginDateIsCurrentDate = NO;
    if([[formatter stringFromDate:[NSDate date]] isEqualToString:[Helper getValueByKey:POSMINI_LOGIN_DATE]])
    {
        //当前日期是否等于登录成功日期，如果不是，强制刷新当前页面信息
        loginDateIsCurrentDate = YES;
    }
}

-(void)refreshTableView{
    
}

/**
 设置取现账户
 @param bankCardNum 银行卡号
 */
-(void) setBankNumString:(NSString *)bankCardNum
{
    
}



@end
