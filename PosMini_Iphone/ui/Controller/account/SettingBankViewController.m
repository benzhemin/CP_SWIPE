//
//  SettingBankViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SettingBankViewController.h"
#import "AppDelegate.h"
#import "SQLiteOperation.h"

@interface SettingBankViewController ()

@end

@implementation SettingBankViewController

@synthesize defaultBankAccountString;

-(void) dealloc
{
    [defaultBankAccountString release];
    [bindService release];
    
    [dataSource release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        bindService = [[BindCardService alloc] init];
        [bindService onRespondTarget:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"取现设置"];
	
    //显示取现银行信息
    showDataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, contentView.frame.size.width,contentView.frame.size.height*3/5.0) style:UITableViewStyleGrouped];
    showDataTable.backgroundView = nil;
    [showDataTable setBackgroundColor:[UIColor clearColor]];
    showDataTable.delegate = self;
    showDataTable.dataSource = self;
    [contentView addSubview:showDataTable];
    [showDataTable release];
    
    //初始化存储数据Array
    dataSource = [[NSMutableArray alloc]init];
    [dataSource insertObject:@"请选择省份" atIndex:0];
    [dataSource insertObject:@"请选择地区" atIndex:1];
    
    //确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    confirmButton.frame = CGRectMake(20, showDataTable.frame.origin.y+showDataTable.frame.size.height, contentView.frame.size.width-40, 47);
    confirmButton.tag = 1;
    [confirmButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    [contentView addSubview:confirmButton];
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(20, confirmButton.frame.origin.y+confirmButton.frame.size.height+10, contentView.frame.size.width-40, 47);
    cancelButton.tag = 2;
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"重    置" forState:UIControlStateNormal];
    [contentView addSubview:cancelButton];
}

#pragma mark DataPickerDelegate Method
/**
 选中数据返回
 @param selectString 选择返回数据
 */
-(void) setSelectedString:(NSString *)selectString
{
    if (selectIndex==1) {
        if (![selectString isEqualToString:[dataSource objectAtIndex:0]]) {
            [dataSource replaceObjectAtIndex:1 withObject:@"请选择地区"];
        }
    }
    
    //如果选择的是特殊的城市，设置其下面默认选中的城市
    if ([selectString isEqualToString:@"北京"]||[selectString isEqualToString:@"天津"]||[selectString isEqualToString:@"上海"]||[selectString isEqualToString:@"重庆"]||[selectString isEqualToString:@"香港"]||[selectString isEqualToString:@"澳门"]||
        [selectString isEqualToString:@"台湾"]) {
        [dataSource replaceObjectAtIndex:1 withObject:selectString];
    }
    
    [dataSource replaceObjectAtIndex:selectIndex-1 withObject:selectString];
    [showDataTable reloadData];
}

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 4;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回行高
    return 50;
}

//返回每个Table中的每行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1||indexPath.row==2||indexPath.row==3) {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor whiteColor];
            
            //显示标题
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(20,5, 85, cell.frame.size.height-5);
            title.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            title.backgroundColor = [UIColor clearColor];
            title.font = [UIFont boldSystemFontOfSize:16];
            title.tag = 1;
            [cell addSubview:title];
            [title release];
            
            //显示内容
            UILabel *content = [[UILabel alloc]init];
            content.frame = CGRectMake(105, 5, 180, cell.frame.size.height-5);
            content.backgroundColor = [UIColor clearColor];
            content.textAlignment = NSTextAlignmentLeft;
            content.font = [UIFont systemFontOfSize:16];
            content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            content.tag = 2;
            [cell addSubview:content];
            [content release];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        UILabel *content = (UILabel *)[cell viewWithTag:2];
        switch (indexPath.row) {
            case 1:
                title.text = @"开户省份:";
                content.text = [dataSource objectAtIndex:0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                title.text = @"开户地区:";
                content.text = [dataSource objectAtIndex:1];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                title.text = @"银行户名:";
                content.text = [Helper getValueByKey:POSMINI_LOGIN_USERNAME];
                break;
        }
        return cell;
    }
    else
    {
        static NSString *identifier2 = @"identifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.backgroundColor = [UIColor whiteColor];
            
            UILabel *title = [[UILabel alloc]init];
            title.frame = CGRectMake(20,5, 85, cell.frame.size.height-5);
            title.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            title.backgroundColor = [UIColor clearColor];
            title.font = [UIFont boldSystemFontOfSize:16];
            title.tag = 1;
            [cell addSubview:title];
            [title release];
            
            bankAccount = [[UITextField alloc]init];
            //content.keyboardType = UIKeyboardTypeNumberPad;
            bankAccount.returnKeyType = UIReturnKeyDone;
            bankAccount.frame = CGRectMake(105, 15, 180, cell.frame.size.height-15);
            bankAccount.backgroundColor = [UIColor clearColor];
            bankAccount.delegate = self;
            bankAccount.placeholder = @"请输入银行卡号";
            bankAccount.autocapitalizationType = UITextAutocapitalizationTypeNone;
            bankAccount.autocorrectionType = UITextAutocorrectionTypeNo;
            bankAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
            bankAccount.textAlignment = NSTextAlignmentLeft;
            bankAccount.font = [UIFont systemFontOfSize:16];
            bankAccount.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            bankAccount.tag = 2;
            [cell addSubview:bankAccount];
            [bankAccount release];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        switch (indexPath.row) {
            case 0:
                title.text = @"银行卡号:";
                break;
        }
        return cell;
    }
    
}

#pragma mark UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1||indexPath.row==2) {
        
        //隐藏下面TabBar
        //选中开户省份要隐藏tabbar
        if (indexPath.row == 1) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate) hiddenTabBar];
        }
        
        selectIndex = indexPath.row;
        DataPickerViewController *_dataPickerViewController = [[DataPickerViewController alloc]init];
        _dataPickerViewController.isShowTabBar = NO;
        _dataPickerViewController.delegate = self;
        switch (indexPath.row) {
            case 1:
                _dataPickerViewController.dataType = ProvinceType;
                break;
            case 2:
                
                if ([[dataSource objectAtIndex:0] isEqualToString:@"请选择省份"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择省份" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                    return ;
                }
                else
                {
                    _dataPickerViewController.keyWord = [dataSource objectAtIndex:0];
                    _dataPickerViewController.dataType = AreaType;
                }
                break;
        }
        
        //弹出数据选择ViewController
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:_dataPickerViewController];
        [_dataPickerViewController release];
        [self presentModalViewController:navigationController animated:YES];
        [navigationController release];
    }
}

#pragma mark UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断输入的是否为数字
    return [self validateNumber:string];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//处理按钮事件
-(void)btnClick:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    if (tempButton.tag==1) {
        //绑定银行卡
        if ([Helper StringIsNullOrEmpty:bankAccount.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入银行卡号!"];
            return;
        }
        
        if (bankAccount.text.length<8||bankAccount.text.length>20) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"银行卡号为8到20位!"];
            return;
        }
        
        if ([[dataSource objectAtIndex:0] isEqualToString:@"请选择省份"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请选择省份!"];
            return;
        }
        
        if ([[dataSource objectAtIndex:1] isEqualToString:@"请选择地区"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请选择地区!"];
            return;
        }
        
        //发送绑定取现账户请求
        /*
        [self showWaitNotice:@"账户绑定中..."];
        NSHttpBlock *httpInfo = [[NSHttpBlock alloc]init];
        httpInfo.requestUrl= [NSString stringWithFormat:@"%@/mtp/action/management/autoCashCardSetting",HOST_URL];
        NSMutableDictionary *postDataDictionary = [[[NSMutableDictionary alloc]init]autorelease];
        [postDataDictionary setValue:[Helper getValueByKey:@"CustId"] forKey:@"CustId"];
        [postDataDictionary setValue:[self getProvIdByName:[dataSource objectAtIndex:0]] forKey:@"ProvId"];
        [postDataDictionary setValue:[self getAreaIdByName:[dataSource objectAtIndex:1]] forKey:@"AreaId"];
        [postDataDictionary setValue:bankAccount.text forKey:@"CardId"];
        [postDataDictionary setValue:[Helper getValueByKey:@"userName"] forKey:@"CardName"];
        httpInfo.requestKeyValue = postDataDictionary;
        httpInfo.requestMethod = @"POST";
        [self sendHttpRequest:httpInfo];
        */
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
        [dict setValue:[self getProvIdByName:[dataSource objectAtIndex:0]] forKey:@"ProvId"];
        [dict setValue:[self getAreaIdByName:[dataSource objectAtIndex:1]] forKey:@"AreaId"];
        [dict setValue:bankAccount.text forKey:@"CardId"];
        [dict setValue:[Helper getValueByKey:POSMINI_LOGIN_USERNAME] forKey:@"CardName"];
        [bindService requestForBindCard:dict];
    }
    
    if (tempButton.tag==2) {
        //重置
        bankAccount.text = @"";
        [dataSource replaceObjectAtIndex:0 withObject:@"请选择省份"];
        [dataSource replaceObjectAtIndex:1 withObject:@"请选择地区"];
        [showDataTable reloadData];
    }
}

-(void)bindRequestDidFinished{
    //存储登录信息
    UIAlertView *noticeView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取现银行设置成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [noticeView show];
    [noticeView release];
}

/**
 通过省份名称查询Id
 @param provName 省份名称
 @returns 省份Id
 */
-(NSString *)getProvIdByName:(NSString *)provName
{
    SQLiteOperation *operation = [[[SQLiteOperation alloc]init]autorelease];
    NSMutableArray *array = [operation selectData:[NSString stringWithFormat:@"SELECT ProvinceId FROM areas where ProvinceName='%@' limit 1",provName] resultColumns:1];
    return [[array objectAtIndex:0]objectAtIndex:0];
}

/**
 通过地区名称查询Id
 @param areaName 地区名称
 @returns 省份Id
 */
-(NSString *)getAreaIdByName:(NSString *)areaName
{
    SQLiteOperation *operation = [[[SQLiteOperation alloc]init]autorelease];
    NSMutableArray *array = [operation selectData:[NSString stringWithFormat:@"SELECT AreaId from areas where AreaName='%@'",areaName] resultColumns:1];
    return [[array objectAtIndex:0]objectAtIndex:0];
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //设置取现银行成功后，重新设置用户信息页面的取现银行卡号
    [(DefaultAccountViewController *)[self.navigationController.viewControllers objectAtIndex:0] setBankNumString:[self getBankNumWithOmit:[bankAccount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00008";
}

/**
 获取有省略号的银行卡号
 @param bankNum 原始银行卡号
 @returns 经过处理的银行卡号
 */
-(NSString *) getBankNumWithOmit:(NSString *)bankNum
{
    return [NSString stringWithFormat:@"%@ **** **** %@",[bankNum substringToIndex:4],[bankNum substringWithRange:NSMakeRange(bankNum.length-4, 4)]];
}

/**
 判断输入的是否为数字
 @param number 输入字符
 @returns 是否为数字
 */
- (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
