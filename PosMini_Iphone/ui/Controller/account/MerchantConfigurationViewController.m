//
//  MerchantConfigurationViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "MerchantConfigurationViewController.h"
#import "SQLiteOperation.h"
#import "AppDelegate.h"


@interface MerchantConfigurationViewController ()

@end

@implementation MerchantConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id)init{
    if (self=[super init]) {
        merchantService=[[MerchantService alloc]init];
        [merchantService onRespondTarget:self];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"商户配置"];
    
    //强制配置时，隐藏返回按钮
    if (![PosMiniDevice sharedInstance].isSetedMerTel)
    {
        self.naviBackBtn.hidden=YES;
    }
    
    
    self.backScrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)]autorelease];
    _backScrollView.contentSize=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+47*2+30);
    [contentView addSubview:_backScrollView];
	
    //显示商户信息
    self.showDataTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 15, contentView.frame.size.width,315) style:UITableViewStyleGrouped]autorelease];
    _showDataTable.backgroundView = nil;
    _showDataTable.scrollEnabled=NO;
    [_showDataTable setBackgroundColor:[UIColor clearColor]];
    _showDataTable.delegate = self;
    _showDataTable.dataSource = self;
    [_backScrollView addSubview:_showDataTable];
    
    //初始化存储数据Array
    dataSource = [[NSMutableArray alloc]init];
    [dataSource insertObject:@"请选择省份" atIndex:0];
    [dataSource insertObject:@"请选择地区" atIndex:1];
    
    //确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    confirmButton.frame = CGRectMake(20, _showDataTable.frame.origin.y+_showDataTable.frame.size.height+15, contentView.frame.size.width-40, 47);
    confirmButton.tag = 1;
    [confirmButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    [_backScrollView addSubview:confirmButton];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(20, confirmButton.frame.origin.y+confirmButton.frame.size.height+10, contentView.frame.size.width-40, 47);
    cancelButton.tag = 2;
    [cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"重    置" forState:UIControlStateNormal];
    [_backScrollView addSubview:cancelButton];
    
    originalViewRect = contentView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_MERCHANT_NEED_REFRESH];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[Helper getValueByKey:POSMINI_MERCHANT_NEED_REFRESH]isEqualToString:NSSTRING_YES])
    {
        [merchantService onRespondTarget:self selector:@selector(merchantRequestDidFinished)];
        [merchantService requestForMerchantInfo];
    }
}

-(void)merchantRequestDidFinished{

    self.merchantInfoDic = merchantService.merchantInfoDict;
    [_showDataTable reloadData];
    
    //强制商户配置的场合,清空所有内容
    if (![PosMiniDevice sharedInstance].isSetedMerTel) {
        [_merchantInfoDic setValue:@"" forKey:Merchant_Short_Name];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Complete_Name];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Province_Id];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Area_Id];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Address];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Telephone];
    }

}
#pragma mark- UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 6;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回行高
    return 50;
}

//返回每个Table中的每行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2||indexPath.row==3) {
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
            case 2:
                title.text = @"省份:";
                if ([_merchantInfoDic valueForKey:@"UsrProv"] != nil &&
                    ![[_merchantInfoDic valueForKey:@"UsrProv"]isKindOfClass:[NSNull class]] &&
                    ![[_merchantInfoDic valueForKey:@"UsrProv"] isEqualToString:@""]) {
                    [dataSource replaceObjectAtIndex:0
                                          withObject:[self getProvNameById:[_merchantInfoDic valueForKey:@"UsrProv"]]];
                }
                else
                {
                    [dataSource insertObject:@"请选择省份" atIndex:0];
                }
                content.text = [dataSource objectAtIndex:0];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                title.text = @"地区:";
                if ([_merchantInfoDic valueForKey:@"UsrArea"] != nil &&
                    ![[_merchantInfoDic valueForKey:@"UsrArea"]isKindOfClass:[NSNull class]] &&
                    ![[_merchantInfoDic valueForKey:@"UsrArea"]isEqualToString:@""]) {
                    [dataSource replaceObjectAtIndex:1
                                          withObject:[self getAreaNameById:[_merchantInfoDic valueForKey:@"UsrArea"]]];

                }
                else
                {
                    [dataSource insertObject:@"请选择地区" atIndex:1];
                }
                content.text = [dataSource objectAtIndex:1];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
        return cell;
    }
    else if (indexPath.row==5)
    {
        static NSString *identifier1 = @"identifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1]autorelease];
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
        
            //显示区号
            UITextField *areaCode = [[UITextField alloc]init];
            areaCode = [[UITextField alloc]init];
            areaCode.returnKeyType = UIReturnKeyDone;
            areaCode.frame = CGRectMake(105, 15, 65, cell.frame.size.height-15);
            areaCode.backgroundColor = [UIColor clearColor];
            areaCode.delegate = self;
            areaCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
            areaCode.autocorrectionType = UITextAutocorrectionTypeNo;
            areaCode.clearButtonMode = UITextFieldViewModeWhileEditing;
            areaCode.textAlignment = NSTextAlignmentLeft;
            areaCode.font = [UIFont systemFontOfSize:16];
            areaCode.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            areaCode.tag = 2+indexPath.row;
            [cell addSubview:areaCode];
            [areaCode release];
            
            //显示分隔符
            UILabel *lineLable = [[UILabel alloc]init];
            lineLable.frame = CGRectMake(170, 5, 10, cell.frame.size.height-5);
            lineLable.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            lineLable.backgroundColor = [UIColor clearColor];
            lineLable.font = [UIFont boldSystemFontOfSize:16];
            lineLable.text = @"-";
            [cell addSubview:lineLable];
            [lineLable release];
            
            //显示座机号
            UITextField *telephone = [[UITextField alloc]init];
            telephone.returnKeyType = UIReturnKeyDone;
            telephone.frame = CGRectMake(180, 15, 105, cell.frame.size.height-15);
            telephone.backgroundColor = [UIColor clearColor];
            telephone.delegate = self;
            telephone.autocapitalizationType = UITextAutocapitalizationTypeNone;
            telephone.autocorrectionType = UITextAutocorrectionTypeNo;
            telephone.clearButtonMode = UITextFieldViewModeWhileEditing;
            telephone.textAlignment = NSTextAlignmentLeft;
            telephone.font = [UIFont systemFontOfSize:16];
            telephone.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            telephone.tag = 3+indexPath.row;
            [cell addSubview:telephone];
            [telephone release];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        UITextField *areaCode=(UITextField *)[cell viewWithTag:2+indexPath.row];
        UITextField *telephone=(UITextField *)[cell viewWithTag:3+indexPath.row];
        
        title.text = @"商户电话:";
        merchantAreaCode = areaCode;
        merchantTelephone = telephone;
        if ([_merchantInfoDic valueForKey:@"MerTel"] != nil &&
            ![[_merchantInfoDic valueForKey:@"MerTel"] isKindOfClass:[NSNull class]] &&
            ![[_merchantInfoDic valueForKey:@"MerTel"] isEqualToString:@""])
        {
            NSRange range = [[_merchantInfoDic valueForKey:@"MerTel"] rangeOfString:@"-"];
            
            if (range.location != NSNotFound) {
                if (![[[_merchantInfoDic valueForKey:@"MerTel"] substringToIndex:1] isEqualToString:@"0"]) {
                    merchantAreaCode.text =[NSString stringWithFormat:@"0%@",[[_merchantInfoDic valueForKey:@"MerTel"] substringToIndex:range.location]];
                }
                else
                {
                    merchantAreaCode.text =[[_merchantInfoDic valueForKey:@"MerTel"]substringToIndex:range.location];
                }
                
                merchantTelephone.text = [[_merchantInfoDic valueForKey:@"MerTel"] substringFromIndex:range.location + 1];
            }else{
                merchantTelephone.text = [_merchantInfoDic valueForKey:@"MerTel"];
            }
        }
        else
        {
            merchantAreaCode.placeholder = @"区号";
            merchantTelephone.placeholder = @"座机号";
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
            UITextField *content = [[UITextField alloc]init];
            content.returnKeyType = UIReturnKeyDone;
            content.frame = CGRectMake(105, 15, 180, cell.frame.size.height-15);
            content.backgroundColor = [UIColor clearColor];
            content.delegate = self;
            content.autocapitalizationType = UITextAutocapitalizationTypeNone;
            content.autocorrectionType = UITextAutocorrectionTypeNo;
            content.clearButtonMode = UITextFieldViewModeWhileEditing;
            content.textAlignment = NSTextAlignmentLeft;
            content.font = [UIFont systemFontOfSize:16];
            content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            content.tag = 2+indexPath.row;
            
            [cell addSubview:content];
            [content release];
            
            
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        UITextField *content=(UITextField *)[cell viewWithTag:2+indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                title.text = @"商户全称:";
                merchantCompleteName=content;
                if ([_merchantInfoDic valueForKey:@"UsrName"] != nil &&
                    ![[_merchantInfoDic valueForKey:@"UsrName"]isKindOfClass:[NSNull class]] &&
                    ![[_merchantInfoDic valueForKey:@"UsrName"]isEqualToString:@""])
                {
                    merchantCompleteName.text=[_merchantInfoDic valueForKey:@"UsrName"];
                }else{
                    merchantCompleteName.placeholder=@"请输入商户全称";
                }
                
                break;
            case 1:
                title.text=@"商户简称:";
                merchantShortName=content;
                if ([_merchantInfoDic valueForKey:@"ShortName"] != nil &&
                    ![[_merchantInfoDic valueForKey:@"ShortName"]isKindOfClass:[NSNull class]] &&
                    ![[_merchantInfoDic valueForKey:@"ShortName"]isEqualToString:@""])
                {
                    merchantShortName.text=[_merchantInfoDic valueForKey:@"ShortName"];
                }else{
                    merchantShortName.placeholder=@"请输入商户简称";
                }
                break;
            case 4:
                title.text=@"商户地址:";
                merchantAddress=content;
                if ([_merchantInfoDic valueForKey:@"MerAddr"] != nil &&
                    ![[_merchantInfoDic valueForKey:@"MerAddr"]isKindOfClass:[NSNull class]] &&
                    ![[_merchantInfoDic valueForKey:@"MerAddr"]isEqualToString:@""])
                {
                    merchantAddress.text=[_merchantInfoDic valueForKey:@"MerAddr"];
                }else{
                    merchantAddress.placeholder=@"请输入商户地址";
                }
                
                break;
        }
        return cell;
    }
    
}
#pragma mark- UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2||indexPath.row==3) {
        
        //隐藏下面TabBar
        //选中开户省份要隐藏tabbar
        if (indexPath.row == 2) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate) hiddenTabBar];
        }
        
        selectIndex = indexPath.row;
        DataPickerViewController *_dataPickerViewController = [[DataPickerViewController alloc]init];
        _dataPickerViewController.isShowTabBar = NO;
        _dataPickerViewController.delegate = self;
        switch (indexPath.row) {
            case 2:
                _dataPickerViewController.dataType = ProvinceType;
                break;
            case 3:
                
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
        
        [Helper saveValue:NSSTRING_NO forKey:POSMINI_MERCHANT_NEED_REFRESH];
    }
}


#pragma mark- UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 6 || textField.tag == 7 || textField.tag == 8)
    {
        editingTextFieldTag = textField.tag;
        isNeedMoveView = YES;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //区号
    if (textField.tag==7)
    {
        //判断输入的是否为数字
        if (![self validateNumber:string])
        {
            return NO;
        }
        
        //判断输入长度是否超过4
        if (![string isEqualToString:@""])
        {
            if (textField.text.length>=4)
            {
                return NO;
            }
        }
    }
    
    //座机号
    if (textField.tag==8) {
        //判断输入的是否为数字
        if (![self validateNumber:string])
        {
            return NO;
        }
        
        //判断输入长度是否超过8
        if (![string isEqualToString:@""])
        {
            if (textField.text.length>=8)
            {
                return NO;
            }
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    editingTextFieldTag = 0;
    isNeedMoveView = NO;
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark- 按钮事件处理
//处理按钮事件
-(void)btnClick:(id)sender
{
    //故障对应#0002607
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *tempButton = (UIButton *)sender;
    if (tempButton.tag==1) {
        //设置商户信息
        if ([Helper StringIsNullOrEmpty:merchantCompleteName.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入商户全称!"];
            return;
        }
        
        //故障对应#0002565
        if (merchantCompleteName.text.length>16) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"商户全称最长不超过16个字符!"];
            return;
        }
        
        if ([Helper StringIsNullOrEmpty:merchantShortName.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入商户简称!"];
            return;
        }
        if (merchantShortName.text.length>6) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"商户简称最长不超过6个字符!"];
            return;
        }
        
        if ([Helper StringIsNullOrEmpty:merchantAddress.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入商户地址!"];
            return;
        }
        if (merchantAddress.text.length>13) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"商户地址最长不超过13个字符!"];
            return;
        }
        
        if ([Helper StringIsNullOrEmpty:merchantAreaCode.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入区号"];
            return;
        }
        
        if (merchantAreaCode.text.length>4) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"区号最长不超过4个字符"];
            return;
        }
        
        if (![[merchantAreaCode.text substringToIndex:1]isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"区号请以0开头"];
            return;
        }
        
        if ([Helper StringIsNullOrEmpty:merchantTelephone.text]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入座机号码"];
            return;
        }
        
        if (merchantTelephone.text.length>8) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"座机号最长不超过8个字符"];
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
        
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
        [dict setValue:[self getProvIdByName:[dataSource objectAtIndex:0]] forKey:@"UsrProv"];
        [dict setValue:[self getAreaIdByName:[dataSource objectAtIndex:1]] forKey:@"UsrArea"];
        [dict setValue:merchantCompleteName.text forKey:@"UsrName"];
        [dict setValue:merchantShortName.text forKey:@"ShortName"];
        [dict setValue:merchantAddress.text forKey:@"MerAddr"];
        NSString * tmpTelephone;
        if (merchantAreaCode.text.length == 4)
        {
            tmpTelephone = [NSString stringWithFormat:@"%@-%@",[merchantAreaCode.text substringFromIndex:1],merchantTelephone.text];
        }
        else
        {
            tmpTelephone = [NSString stringWithFormat:@"%@-%@",merchantAreaCode.text,merchantTelephone.text];
        }
        [dict setValue:tmpTelephone forKey:@"MerTel"];
        
        [merchantService requestForSetMerchantInfo:dict];
        
        
    }
    
    if (tempButton.tag==2) {
        //重置
        //商户全称
        merchantCompleteName.text=@"";
        //商户简称
        merchantShortName.text=@"";
        //商户地址
        merchantAddress.text=@"";
        //区号
        merchantAreaCode.text=@"";
        //座机号
        merchantTelephone.text=@"";
        
        [_merchantInfoDic setValue:@"" forKey:Merchant_Short_Name];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Complete_Name];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Province_Id];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Area_Id];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Address];
        [_merchantInfoDic setValue:@"" forKey:Merchant_Telephone];
        [dataSource replaceObjectAtIndex:0 withObject:@"请选择省份"];
        [dataSource replaceObjectAtIndex:1 withObject:@"请选择地区"];
        
        [_showDataTable reloadData];
    }
}
#pragma mark -
-(void)savedMerchantInfoRequestDidFinished{
    
    UIAlertView *noticeView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商户信息设置成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    noticeView.tag=1;
    [noticeView show];
    [noticeView release];
    
    [PosMiniDevice sharedInstance].isSetedMerTel = YES;
    [Helper saveValue:merchantCompleteName.text forKey:POSMINI_LOGIN_USERNAME];
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        //设置商户配置成功后，重新设置帐户信息页面的商户信息
        [(DefaultAccountViewController *)[self.navigationController.viewControllers objectAtIndex:0] setMerchantString:merchantShortName.text];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark- DataPickerDelegate Method
/**
 选中数据返回
 @param selectString 选择返回数据
 */
-(void) setSelectedString:(NSString *)selectString
{
    if (selectIndex==2) {
        if (![selectString isEqualToString:[dataSource objectAtIndex:0]]) {
            [_merchantInfoDic setValue:[self getProvIdByName:selectString] forKey:@"UsrProv"];
            [_merchantInfoDic setValue:@"" forKey:@"UsrArea"];
            
            //如果选择的是特殊的城市，设置其下面默认选中的城市
            if ([selectString isEqualToString:@"北京"]||[selectString isEqualToString:@"天津"]||[selectString isEqualToString:@"上海"]||[selectString isEqualToString:@"重庆"]||[selectString isEqualToString:@"香港"]||[selectString isEqualToString:@"澳门"]||
                [selectString isEqualToString:@"台湾"]) {
                    [_merchantInfoDic setValue:[self getAreaIdByName:selectString] forKey:@"UsrArea"];
            }
        }
    }
    else if (selectIndex == 3)
    {
        [_merchantInfoDic setValue:[self getAreaIdByName:selectString] forKey:@"UsrArea"];
    }
    
    [_showDataTable reloadData];
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
 通过省份Id查询名称
 @param provID 省份Id
 @returns 省份名称
 */
-(NSString *)getProvNameById:(NSString *)provID
{
    SQLiteOperation *operation = [[[SQLiteOperation alloc]init]autorelease];
    NSMutableArray *array = [operation selectData:[NSString stringWithFormat:@"SELECT ProvinceName FROM areas where ProvinceId='%@' limit 1",provID] resultColumns:1];
    return [[array objectAtIndex:0]objectAtIndex:0];
}

/**
 通过地区名称查询Id
 @param areaName 地区名称
 @returns 地区Id
 */
-(NSString *)getAreaIdByName:(NSString *)areaName
{
    SQLiteOperation *operation = [[[SQLiteOperation alloc]init]autorelease];
    NSMutableArray *array = [operation selectData:[NSString stringWithFormat:@"SELECT AreaId from areas where AreaName='%@'",areaName] resultColumns:1];
    return [[array objectAtIndex:0]objectAtIndex:0];
}

/**
 通过地区Id查询名称
 @param areaId 地区Id
 @returns 地区名称
 */
-(NSString *)getAreaNameById:(NSString *)areaId
{
    SQLiteOperation *operation = [[[SQLiteOperation alloc]init]autorelease];
    NSMutableArray *array = [operation selectData:[NSString stringWithFormat:@"SELECT AreaName from areas where AreaId='%@'",areaId] resultColumns:1];
    return [[array objectAtIndex:0]objectAtIndex:0];
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
/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00014";
}

#pragma mark- 键盘事件
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    CGSize kbSize=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSLog(@"keyboard changed, keyboard width = %f, height = %f",
          kbSize.width,kbSize.height);
    //还原页面移动
    contentView.frame = originalViewRect;
    
    //设置动画
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.30f];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    CGSize kbSize=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSLog(@"keyboard changed, keyboard width = %f, height = %f",
          kbSize.width,kbSize.height);
    
    if (isNeedMoveView)
    {
        float offset;
        
        switch (editingTextFieldTag) {
            case 6://商户地址
            {
                UITableViewCell * cell = [_showDataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                offset = (contentView.frame.origin.y + _showDataTable.frame.origin.y + cell.frame.origin.y + cell.frame.size.height) -
                (self.view.frame.origin.y + self.view.frame.size.height - kbSize.height);
                break;
            }
            case 7://商户电话（区号）
            case 8://商户电话（座机号）
            {
                UITableViewCell * cell = [_showDataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                offset = (contentView.frame.origin.y + _showDataTable.frame.origin.y + cell.frame.origin.y + cell.frame.size.height) -
                (self.view.frame.origin.y + self.view.frame.size.height - kbSize.height);
                break;
            }
            default:
                offset = 0;
                break;
        }
        
        NSLog(@"offset:%f",offset);
        if (offset > 0)
        {
            CGRect newFrame = contentView.frame;
            newFrame.origin.y = newFrame.origin.y - offset;
            contentView.frame = newFrame;
            
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
            [UIView setAnimationDuration:0.30f];
            [UIView commitAnimations];
        }
    }
}

#pragma mark- 内存管理
-(void)dealloc{
    [_backScrollView release];
    [_showDataTable release];
    [_merchantInfoDic release];
    [dataSource release];
    [merchantService release];
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
