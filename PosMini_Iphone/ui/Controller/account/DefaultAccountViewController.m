//
//  DefaultAccountViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultAccountViewController.h"
#import "SettingBankViewController.h"
#import "Helper.h"

@interface DefaultAccountViewController ()

@end

@implementation DefaultAccountViewController

@synthesize acctInfoTableView, acctService;
@synthesize userInfoDict;

-(void)dealloc{
    [acctInfoTableView release];
    [acctService release];
    
    [userInfoDict release];
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
    
    if ([[Helper getValueByKey:POSMINI_ACCOUNT_NEED_REFRESH] isEqualToString:NSSTRING_YES] || !loginDateIsCurrentDate) {
        self.acctService = [[[AccountService alloc] init] autorelease];
        [acctService onRespondTarget:self selector:@selector(accountRequestDidFinished)];
        [acctService requestForUserInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:NOTIFICATION_REFRESH_ACCOUNT object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)accountRequestDidFinished{
    self.userInfoDict = acctService.userInfoDict;
    [self refreshTableView];
}

-(void)refreshTableView{
    [self.acctInfoTableView reloadData];
}

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//返回Table的每行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(20,5, 105, cell.frame.size.height-5);
        title.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.tag = UITABLE_VIEW_CELL_TITLE;
        [cell addSubview:title];
        [title release];
        
        UILabel *content = [[UILabel alloc]init];
        content.frame = CGRectMake(95, 5, 180, cell.frame.size.height-5);
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentRight;
        content.font = [UIFont systemFontOfSize:16];
        content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        content.tag = UITABLE_VIEW_CELL_CONTENT;
        [cell addSubview:content];
        [content release];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    UILabel *title = (UILabel *)[cell viewWithTag:UITABLE_VIEW_CELL_TITLE];
    UILabel *content = (UILabel *)[cell viewWithTag:UITABLE_VIEW_CELL_CONTENT];
    switch (indexPath.row) {
        case 0:
            title.text = @"登录账户:";
            content.text = [NSString stringWithFormat:@"%@(%@)",[Helper getValueByKey:POSMINI_LOGIN_USERNAME],[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT]];
            break;
        case 1:
            title.text = @"自动取现:";
            if (![[userInfoDict valueForKey:@"CashCardNo"] isEqualToString:@"未设置"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            content.text = [userInfoDict valueForKey:ACCOUNT_CASHCARD_NUMBER];
            
            break;
        case 2:
            title.text = @"当日收款:";
            if ([userInfoDict valueForKey:ACCOUNT_TOTAL_ORDER_AMOUNT]!=nil) {
                content.text = [NSString stringWithFormat:@"%@元(%@笔)",[userInfoDict valueForKey:ACCOUNT_TOTAL_ORDER_AMOUNT],[userInfoDict valueForKey:ACCOUNT_TOTAL_ORDER_COUNT]];
            }
            break;
        /*
        case 3:
            title.text = @"单笔交易限额:";
            if (![[Helper getValueByKey:POSMINI_ONE_LIMIT_AMOUNT] isEqualToString:POSMINI_DEFAULT_VALUE]) {
                content.text =[NSString stringWithFormat:@"%@元",[Helper getValueByKey:POSMINI_ONE_LIMIT_AMOUNT]];
            }else{
                content.text = @"元";
            }
            break;
        case 4:
            title.text = @"每日交易限额:";
            if (![[Helper getValueByKey:POSMINI_SUM_LIMIT_AMOUNT] isEqualToString:POSMINI_DEFAULT_VALUE]) {
                content.text = [NSString stringWithFormat:@"%@元",[Helper getValueByKey:POSMINI_SUM_LIMIT_AMOUNT]];
            }else{
                content.text = @"元";
            }
            break;
        */
        case 3:
            title.text = @"设备编号:";
            content.text = [userInfoDict valueForKey:ACCOUNT_BINDED_MOUNT_ID];
            
            /*
            if (![[userInfoDict valueForKey:@"CashCardNo"] isEqualToString:@"未绑定"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            */
            
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate Method
//选中行事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //开启取现银行
    
    if (indexPath.row==1) {
        //用户未设置取现银行
        if (![[userInfoDict valueForKey:@"CashCardNo"] isEqualToString:@"未设置"]) {
            //提示用户是否重设取现银行
            UIAlertView *noticeAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否重新设置银行账户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            noticeAlert.tag = 2;
            [noticeAlert show];
            [noticeAlert release];
        }
        //用户已设置取现银行
        else
        {
            //设置取现银行
            /*
            SettingBankViewController *_settingBankViewController = [[SettingBankViewController alloc]init];
            _settingBankViewController.defaultBankAccountString = [userInfoDict valueForKey:@"CashCardNo"];
            [self.navigationController pushViewController:_settingBankViewController animated:YES];
            [_settingBankViewController release];
            */
        }
    }
    
    //屏蔽解绑
    return;
    
    if (indexPath.row==3) {
        if (![[userInfoDict valueForKey:@"BindedMtId"] isEqualToString:@"未绑定"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解绑后该设备将作废，是否确定解绑!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 1;
            [alertView show];
            [alertView release];
        }
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2) {
        if (buttonIndex==0) {
            //设置取现银行
            SettingBankViewController *sb = [[SettingBankViewController alloc]init];
            //sb.defaultBankAccountString = [userInfoDict valueForKey:@"CashCardNo"];
            [self.navigationController pushViewController:sb animated:YES];
            [sb release];
        }
        
    }
    
    if (alertView.tag==1) {
        //刷卡器解绑
        /*
        if (buttonIndex==0) {
            //发送请求解除刷卡器绑定
            
            NSHttpBlock *httpInfo = [[NSHttpBlock alloc]init];
            httpInfo.requestUrl= [NSString stringWithFormat:@"%@/mtp/action/bind/release",HOST_URL];
            NSMutableDictionary *postDataDictionary = [[[NSMutableDictionary alloc]init]autorelease];
            [postDataDictionary setValue:[Helper getValueByKey:@"CustId"] forKey:@"CustId"];
            [postDataDictionary setValue:[userInfoDictionary valueForKey:@"BindedMtId"] forKey:@"MtId"];
            httpInfo.requestKeyValue = postDataDictionary;
            httpInfo.httpId = 2;
            httpInfo.requestMethod = @"POST";
            [self sendHttpRequest:httpInfo];
        }
        */
    }
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00001";
}

/**
 设置取现账户
 @param bankCardNum 银行卡号
 */
-(void) setBankNumString:(NSString *)bankCardNum
{
    NSLog(@"银行卡号:%@",bankCardNum);
    //重新设置取现银行账户
    [userInfoDict setValue:bankCardNum forKey:@"CashCardNo"];
    //刷新显示用户信息Table
    [acctInfoTableView reloadData];
}



@end
