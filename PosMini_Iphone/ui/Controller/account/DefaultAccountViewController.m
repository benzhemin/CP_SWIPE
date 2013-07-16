//
//  DefaultAccountViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultAccountViewController.h"
#import "Helper.h"

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

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(20,5, 85, cell.frame.size.height-5);
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
    UILabel *title = (UILabel *) [cell viewWithTag:UITABLE_VIEW_CELL_TITLE];
    UILabel *content = (UILabel *) [cell viewWithTag:UITABLE_VIEW_CELL_CONTENT];
    switch (indexPath.row) {
        case 0:
            title.text = @"登录账户:";
            content.text = [NSString stringWithFormat:@"%@(%@)",[Helper getValueByKey:@"userName"],[Helper getValueByKey:@"loginName"]];
            break;
        case 1:
            title.text = @"自动取现:";
            if ([userInfoDict valueForKey:@"CashCardNo"]!=nil) {
                content.text = [userInfoDict valueForKey:@"CashCardNo"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            title.text = @"当日收款:";
            if ([userInfoDict valueForKey:@"TotalOrdAmt"]!=nil) {
                content.text = [NSString stringWithFormat:@"%@元(%@笔)",[userInfoDict valueForKey:@"TotalOrdAmt"],[userInfoDict valueForKey:@"TotalOrdCnt"]];
            }
            break;
        case 3:
            title.text = @"可取现金额:";
            if ([userInfoDict valueForKey:@"AvailCashAmt"]!=nil) {
                content.text =[NSString stringWithFormat:@"%@元",[userInfoDict valueForKey:@"AvailCashAmt"]];
            }
            break;
        case 4:
            title.text = @"待结算金额:";
            if ([userInfoDict valueForKey:@"NeedLiqAmt"]!=nil) {
                content.text = [NSString stringWithFormat:@"%@元",[userInfoDict valueForKey:@"NeedLiqAmt"]];
            }
            break;
        case 5:
            title.text = @"设备编号:";
            if ([userInfoDict valueForKey:@"BindedMtId"]!=nil) {
                content.text = [userInfoDict valueForKey:@"BindedMtId"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if (![[userInfoDict valueForKey:@"CashCardNo"] isEqualToString:BANK_DEFINE]) {
            //提示用户是否重设取现银行
            UIAlertView *noticeAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否重新设置银行账户" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            noticeAlert.tag = 2;
            [noticeAlert show];
            [noticeAlert release];
        }
        else
        {
            //设置取现银行
            SettingBankViewController *_settingBankViewController = [[SettingBankViewController alloc]init];
            _settingBankViewController.defaultBankAccountString = [userInfoDict valueForKey:@"CashCardNo"];
            [self.navigationController pushViewController:_settingBankViewController animated:YES];
            [_settingBankViewController release];
        }
        
    }
    if (indexPath.row==5) {
        if (![[userInfoDict valueForKey:@"BindedMtId"] isEqualToString:BIND_DEFINE]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解绑后该设备将作废，是否确定解绑!" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alertView.tag = 1;
            [alertView show];
            [alertView release];
        }
        
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
