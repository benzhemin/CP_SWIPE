//
//  RequireLoginViewController.m
//  PosMini_Iphone
//
//  Created by ben on 13-7-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RequireLoginViewController.h"

@implementation RequireLoginViewController

@synthesize imgBgView, bgScrollView;
@synthesize acctTextField, pwdTextField;
@synthesize logService;

-(void)dealloc{
    [imgBgView release];
    [bgScrollView release];
    
    [acctTextField release];
    [pwdTextField release];
    
    [logService release];
    
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat contentWidth = contentView.frame.size.width;
    CGFloat contentHeight = contentView.frame.size.height;
    
    
    self.bgScrollView = [[[UIScrollView alloc] init] autorelease];
    bgScrollView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    [contentView addSubview:bgScrollView];
    
    self.imgBgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)] autorelease];
    imgBgView.userInteractionEnabled = YES;
    imgBgView.image = IS_IPHONE5 ? [UIImage imageNamed:@"Default-568h.png"]:[UIImage imageNamed:@"Default.png"];
    [bgScrollView addSubview:imgBgView];
 
    //输入框背景
    UIImageView *inputTextBgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, contentView.frame.size.height/2-50, 300, 91)];
    inputTextBgView.image = [[UIImage imageNamed:@"login-inout-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:40];
    inputTextBgView.userInteractionEnabled = YES;
    [imgBgView addSubview:inputTextBgView];
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
    self.acctTextField = [[[UITextField alloc]initWithFrame:CGRectMake(80, 17, 200, 30)] autorelease];
    acctTextField.text = [Helper getValueByKey:POSMINI_LOGIN_ACCOUNT];
    acctTextField.enabled = NO;
    acctTextField.tag = 1;
    acctTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    acctTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    acctTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    acctTextField.delegate = self;
    [inputTextBgView addSubview:acctTextField];
    acctTextField.returnKeyType = UIReturnKeyNext;
    
    //提示输入密码Title
    UILabel *pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 55, 70, 20)];
    pwdLabel.font = [UIFont boldSystemFontOfSize:16];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    pwdLabel.text =@"密码";
    [inputTextBgView addSubview:pwdLabel];
    [pwdLabel release];
    
    //输入密码框
    self.pwdTextField = [[[UITextField alloc]initWithFrame:CGRectMake(80, 55, 200, 30)] autorelease];
    pwdTextField.placeholder= @"请输入密码";
    pwdTextField.tag = 2;
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    [inputTextBgView addSubview:pwdTextField];
    pwdTextField.returnKeyType = UIReturnKeyDone;
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"login-btn-bg.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:25] forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [loginButton setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(10, inputTextBgView.frame.size.height+inputTextBgView.frame.origin.y+15, 300, 56);
    [loginButton setTitle:@"登     录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [imgBgView addSubview:loginButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_SHOW_USER_LOGIN];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        //点击下一项，让输入密码框获得焦点
        [pwdTextField becomeFirstResponder];
    }
    else
    {
        //密码输入完成，隐藏键盘
        bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
        [acctTextField resignFirstResponder];
        [pwdTextField resignFirstResponder];
        isKeyBoardShow = NO;
    }
    return YES;
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

-(void) login:(id)sender
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请打开定位服务" message:@"" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    //判断用户是否输入密码
    if ([Helper StringIsNullOrEmpty:pwdTextField.text]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"请输入密码", NOTIFICATION_MESSAGE, nil];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_SYS_AUTO_PROMPT
                                                                        object:nil userInfo:dict];
        return;
    }
    
    self.logService = [[[LoginService alloc] init] autorelease];
    [logService onRespondTarget:self selector:@selector(loginDidFinished)];
    [logService loginRequest:acctTextField.text withSecret:pwdTextField.text];
}

-(void)loginDidFinished{
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_SHOW_USER_LOGIN];
    [self dismissModalViewControllerAnimated:YES];
}

@end
