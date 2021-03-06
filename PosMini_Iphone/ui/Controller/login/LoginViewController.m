//
//  LoginViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginViewController.h"
#import "Helper.h"
#import "SFHFKeychainUtils.h"
#import "NSNotificationCenter+CP.h"
#import "AppDelegate.h"
#import "LicenseViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

@synthesize imageBg, accountTextField, pwdTextField, bgScrollView;
@synthesize remAcctCheckBtn, remAcctDescBtn, remSecretCheckBtn, remSecretDescBtn;
@synthesize loginButton, registerButton;
@synthesize logService;

-(void)dealloc{
    [imageBg release];
    [accountTextField release];
    [pwdTextField release];
    [bgScrollView release];
    
    [remAcctCheckBtn release];
    [remAcctDescBtn release];
    [remSecretCheckBtn release];
    [remSecretDescBtn release];
    
    [loginButton release];
    [registerButton release];
    
    [logService release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat contentWidth = contentView.frame.size.width;
    CGFloat contentHeight = contentView.frame.size.height;
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
    [contentView addSubview:bgScrollView];
    [bgScrollView release];
    
    //背景图片
    self.imageBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,contentWidth, contentHeight)];
    imageBg.userInteractionEnabled = YES;
    imageBg.image = IS_IPHONE5 ? [UIImage imageNamed:@"Default-568h.png"]:[UIImage imageNamed:@"Default.png"];
    [bgScrollView addSubview:imageBg];
    [imageBg release];
    
    //注册手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [imageBg addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    //输入框背景
    UIImageView *inputTextBgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, contentView.frame.size.height/2-50, 300, 91)];
    inputTextBgView.image = [[UIImage imageNamed:@"login-inout-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:40];
    inputTextBgView.userInteractionEnabled = YES;
    [imageBg addSubview:inputTextBgView];
    [inputTextBgView release];
    
    //显示账户Label
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 18, 70, 20)];
    accountLabel.font = [UIFont boldSystemFontOfSize:18];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    accountLabel.text =@"账号";
    [inputTextBgView addSubview:accountLabel];
    [accountLabel release];
    
    //输入登录账户
    self.accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 17, 200, 30)];
    accountTextField.placeholder= @"请输入您注册的手机号";
    accountTextField.tag = 1;
    accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextField.delegate = self;
    [inputTextBgView addSubview:accountTextField];
    accountTextField.returnKeyType = UIReturnKeyNext;
    [accountTextField release];
    
    //提示输入密码Title
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 55, 70, 20)];
    pwdLabel.font = [UIFont boldSystemFontOfSize:16];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    pwdLabel.text =@"密码";
    [inputTextBgView addSubview:pwdLabel];
    [pwdLabel release];
    
    //输入密码框
    self.pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 55, 200, 30)];
    pwdTextField.placeholder= @"请输入密码";
    pwdTextField.tag = 2;
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    [inputTextBgView addSubview:pwdTextField];
    pwdTextField.returnKeyType = UIReturnKeyDone;
    [pwdTextField release];
    
    
    //记住我按钮
    self.remAcctCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remAcctCheckBtn.frame = CGRectMake(15, inputTextBgView.frame.size.height+inputTextBgView.frame.origin.y+17, 23, 23);
    [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
    
    self.remSecretCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remSecretCheckBtn.frame = CGRectMake(160, inputTextBgView.frame.size.height+inputTextBgView.frame.origin.y+17, 23, 23);
    [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
    
    NSString *acctState = [Helper getValueByKey:ACCOUNT_CHECK_BOX];
    NSString *secretState = [Helper getValueByKey:SECRET_CHECK_BOX];
    
    //用户没有登陆，默认记住帐户，记住密码
    if (acctState == nil || secretState == nil)
    {
        [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
        [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
        remAcctSelected = YES;
        remSecretSelected = YES;
    }else
    {
        //不记住帐户，密码也要为未选中状态
        if (acctState!=nil && [acctState isEqualToString:NSSTRING_NO])
        {
            [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
            [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
            remAcctSelected = NO;
            remSecretSelected = NO;
        }
        //记住帐户
        else if (acctState!=nil && [acctState isEqualToString:NSSTRING_YES]){
            [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
            remAcctSelected = YES;
            accountTextField.text = [Helper getValueByKey:POSMINI_LOGIN_ACCOUNT];
        }
        
        if (secretState!=nil && [secretState isEqualToString:NSSTRING_NO]) {
            [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
            remSecretSelected = NO;
        }
        else if (secretState!=nil && [secretState isEqualToString:NSSTRING_YES]){
            [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
            remSecretSelected = YES;
            NSString *userName = [Helper getValueByKey:POSMINI_LOGIN_ACCOUNT];
            NSString *passWord = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:KEYCHAIN_SFHF_SERVICE error:nil];
            pwdTextField.text = passWord;
        }
    }
    
    [remAcctCheckBtn addTarget:self action:@selector(rememberAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    [remSecretCheckBtn addTarget:self action:@selector(rememberSecretClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBg addSubview:remAcctCheckBtn];
    [imageBg addSubview:remSecretCheckBtn];
    
    //提示记住登录信息Label
    self.remAcctDescBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remAcctDescBtn.frame = CGRectMake(30, inputTextBgView.frame.size.height+inputTextBgView.frame.origin.y+15, 100, 30);
    [remAcctDescBtn setTitle:@"记住账号" forState:UIControlStateNormal];
    [remAcctDescBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [remAcctDescBtn addTarget:self action:@selector(rememberAccountClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBg addSubview:remAcctDescBtn];
    
    //提示记住登录信息Label
    self.remSecretDescBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remSecretDescBtn.frame = CGRectMake(15+160, inputTextBgView.frame.size.height+inputTextBgView.frame.origin.y+15, 100, 30);
    [remSecretDescBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [remSecretDescBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [remSecretDescBtn addTarget:self action:@selector(rememberSecretClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBg addSubview:remSecretDescBtn];
    
    //登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"login-btn-bg.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:25] forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [loginButton setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(10, remAcctCheckBtn.frame.size.height+remAcctCheckBtn.frame.origin.y+15, 300, 56);
    [loginButton setTitle:@"登     录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [imageBg addSubview:loginButton];
    
    //注册按钮
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setBackgroundImage:[[UIImage imageNamed:@"login-btn-bg.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:25] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [registerButton setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(10, loginButton.frame.size.height+loginButton.frame.origin.y+10, 300, 56);
    [registerButton setTitle:@"注     册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBg addSubview:registerButton];
    
}

-(void)viewDidAppear:(BOOL)animated{
    /* Add_S 启明 张翔 功能点:升级后或安装后第一次启动显示用户协议*/
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *lastRunVersion = [Helper getValueByKey:LASTRUN_VERSION];
    //安装后第一次启动
    if (lastRunVersion == nil)
    {
        [Helper saveValue:NSSTRING_NO forKey:POSMINI_HAVE_READ_LICENSE];
    }
    //升级后第一次启动
    else if (![lastRunVersion isEqualToString:currentVersion])
    {
        if ([currentVersion isEqualToString:@"2.1.0"])
        {
            [Helper saveValue:NSSTRING_NO forKey:POSMINI_HAVE_READ_LICENSE];
        }
    }
    [Helper saveValue:currentVersion forKey:LASTRUN_VERSION];
    /* Add_E 启明 张翔 功能点:升级后或安装后第一次启动显示用户协议*/
    
    
    NSString *readLicense = [Helper getValueByKey:POSMINI_HAVE_READ_LICENSE];
    if (readLicense!=nil && [readLicense isEqualToString:@"YES"]) {
        return;
    }else{
        LicenseViewController *lc = [[LicenseViewController alloc] init];
        [self presentModalViewController:lc animated:YES];
        [lc release];
    }

}

//处理触摸屏幕事件，隐藏键盘
-(void) tapGesture:(UITapGestureRecognizer *)tapGesture
{
    //隐藏键盘，让背景ScrollView恢复大小
    [accountTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
}

//点击注册按钮事件
-(void) registerBtnClick:(id)sender{
    RegisterViewController *rc = [[RegisterViewController alloc]init];
    rc.isShowTabBar =NO;
    [self.navigationController pushViewController:rc animated:YES];
    [rc release];
}

#pragma mark UIGestureRecognizerDelegate Method
//处理UIButton点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //记住我点击事件
    if ([touch.view isDescendantOfView:remAcctDescBtn]||[touch.view isDescendantOfView:remAcctCheckBtn]) {
        return NO; // ignore the touch
    }
    
    //登录点击事件
    if ([touch.view isDescendantOfView:loginButton]) {
        return NO; // ignore the touch
    }
    
    //注册点击事件
    if ([touch.view isDescendantOfView:registerButton]) {
        return NO; // ignore the touch
    }
    
    return YES; // handle the touch
}

-(void) login:(id)sender
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请打开定位服务" message:@"" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    //判断用户名是否为空
    if ([Helper StringIsNullOrEmpty:accountTextField.text]) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入账户名!"];
        return;
    }
    
    /*Add_S 启明 张翔 功能点:手机判断*/
    if ([accountTextField.text length]!= 11)
    {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入11位手机号!"];
        return;
    }
    
    NSString * regex = @"^1[0-9]\\d{9}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:accountTextField.text];
    if (isMatch==NO) {
        
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入正确的手机号!"];
        return;
    }
    /*Add_E 启明 张翔 功能点:手机判断*/
    
    //判断输入密码是否为空
    if ([Helper StringIsNullOrEmpty:pwdTextField.text]) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入密码!"];
        return;
    }
    
    [[LocationService sharedInstance] startToLocateWithAuthentication:NO];
    self.logService = [[[LoginService alloc] init] autorelease];
    [logService onRespondTarget:self selector:@selector(loginDidFinished)];
    [logService loginRequest:accountTextField.text withSecret:pwdTextField.text];
    
}

//登录成功
-(void)loginDidFinished{
    //是否记住登录信息
    if (remAcctSelected) {
        [Helper saveValue:NSSTRING_YES forKey:ACCOUNT_CHECK_BOX];
        if (remSecretSelected) {
            [Helper saveValue:NSSTRING_YES forKey:SECRET_CHECK_BOX];
        }else{
            [Helper saveValue:NSSTRING_NO forKey:SECRET_CHECK_BOX];
        }
    }
    else
    {
        [Helper saveValue:NSSTRING_NO forKey:ACCOUNT_CHECK_BOX];
        [Helper saveValue:NSSTRING_NO forKey:SECRET_CHECK_BOX];
    }
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate loginSuccess];
}

//处理跳转到许可协议
-(void) readLicenseClick:(id)sender
{
    //跳转到许可协议页面
    /*
    LicenseViewController *lc = [[LicenseViewController alloc]init];
    lc.isShowTabBar = NO;
    [self.navigationController pushViewController:lc animated:YES];
    [lc release];
     */
}

/**
 处理点击记住账号Label
 @param sender 系统参数
 */
-(void)rememberAccountClick:(id)sender
{
    //处理点击记账号按钮事件
    remAcctSelected = !remAcctSelected;
    if(remAcctSelected)
    {
        [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
    }
    //不记住账号,要取消记住密码
    else
    {
        remSecretSelected = NO;
        [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
        [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
    }
}

/**
 处理点击记住密码Label
 @param sender 系统参数
 */
-(void)rememberSecretClick:(id)sender
{
    //处理点击记住密码按钮事件
    remSecretSelected = !remSecretSelected;
    //记住密码要记住账号
    if(remSecretSelected)
    {
        remAcctSelected = YES;
        [remAcctCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
        [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-btn.png"] forState:UIControlStateNormal];
    }
    else
    {
        [remSecretCheckBtn setImage:[UIImage imageNamed:@"check-bg.png"] forState:UIControlStateNormal];
    }
}

#pragma mark UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //输入框获取焦点，让背景ScrollView可以滑动
    bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+50);
    bgScrollView.contentOffset = CGPointMake(0, 50);
    isKeyBoardShow = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType ==UIReturnKeyNext) {
        //点击下一项，让输入密码框获得焦点
        [pwdTextField becomeFirstResponder];
    }
    else
    {
        //密码输入完成，隐藏键盘
        bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
        [accountTextField resignFirstResponder];
        [pwdTextField resignFirstResponder];
        isKeyBoardShow = NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1)
    {
        //判断输入的是否为数字
        if (![self validateNumber:string])
        {
            return NO;
        }
        
        //判断输入长度是否超过11
        if (![string isEqualToString:@""])
        {
            if (textField.text.length>=11)
            {
                return NO;
            }
        }
    }
    
    return YES;
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























