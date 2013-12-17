//
//  RegisterViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RegisterViewController.h"
#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"

@interface RegisterViewController ()
//产生随机8位数作为图片验证码种子
-(NSString *)createRandomString;

@end

@implementation RegisterViewController

@synthesize bgScrollView;

@synthesize isGetMessageCode;
@synthesize isFirstGetMessageCode;

@synthesize phoneNumTextField, imageSafeCodeTextField;
@synthesize imageSafeCodeButton;
@synthesize phoneMessageSafeCodeTextField;
@synthesize sendMessageButton;
@synthesize timerLabel;

@synthesize usernameTextField;
@synthesize userIdentifierTextField;
@synthesize pwdTextField;
@synthesize confirmPwdTextField;
@synthesize registerButton;

@synthesize focusTextField;

@synthesize timer;

-(void)dealloc{
    [bgScrollView release];
    
    [phoneNumTextField release];
    [imageSafeCodeTextField release];
    [imageSafeCodeButton release];
    
    [phoneMessageSafeCodeTextField release];
    [sendMessageButton release];
    
    [timerLabel release];
    
    [usernameTextField release];
    [userIdentifierTextField release];
    [pwdTextField release];
    [confirmPwdTextField release];
    
    [registerButton release];
    
    [focusTextField release];
    
    [timer release];
    
    [safeCodeRandomString release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        regService = [[RegService alloc] init];
        [regService onRespondTarget:self];
        
        safeCodeRandomString = [[NSMutableString alloc]init];
    }
    return self;
}

#define MARGIN_LEFT 15
#define INPUTTEXTFILED_HEIGHT 45
#define LINE_MARGIN 5

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"注册"];
    
    //背景ScrollView
    CGRect bgFrame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    self.bgScrollView = [[[UIScrollView alloc]initWithFrame:bgFrame] autorelease];
    [contentView addSubview:bgScrollView];
    
    //起始位置y坐标
    float _begY = 10;
    //手机号码
    self.phoneNumTextField = [[[RegTextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [phoneNumTextField setTitle:@"手机号码:"];
    [phoneNumTextField setPlaceholder:@"请输入手机号码"];
    [phoneNumTextField setReturnKeyType:UIReturnKeyNext];
    [phoneNumTextField setKeyBoardType:UIKeyboardTypeNumberPad];
    [phoneNumTextField setFieldTag:1];
    [phoneNumTextField setDelegate:self];
    [bgScrollView addSubview:phoneNumTextField];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //图片验证码输入框
    self.imageSafeCodeTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, 110, INPUTTEXTFILED_HEIGHT)] autorelease];
    [imageSafeCodeTextField setDelegate:self];
    [imageSafeCodeTextField setReturnKeyType:UIReturnKeyNext];
    [imageSafeCodeTextField setPlaceholder:@"图片验证码"];
    [imageSafeCodeTextField setFieldTag:2];
    [bgScrollView addSubview:imageSafeCodeTextField];

    //显示图片验证码
    self.imageSafeCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSafeCodeButton.tag = 1;
    [imageSafeCodeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageSafeCodeButton setBackgroundColor:[UIColor whiteColor]];
    [imageSafeCodeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [imageSafeCodeButton setTitleColor:[UIColor colorWithRed:57/255.0 green:84/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    imageSafeCodeButton.frame = CGRectMake(imageSafeCodeTextField.frame.origin.x+imageSafeCodeTextField.frame.size.width+5, _begY, contentView.frame.size.width-2*MARGIN_LEFT-imageSafeCodeTextField.frame.size.width-8, INPUTTEXTFILED_HEIGHT);
    [bgScrollView addSubview:imageSafeCodeButton];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;

    //短信验证码输入框
    self.phoneMessageSafeCodeTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, 110, INPUTTEXTFILED_HEIGHT)] autorelease];
    [phoneMessageSafeCodeTextField setDelegate:self];
    [phoneMessageSafeCodeTextField setFieldTag:3];
    [phoneMessageSafeCodeTextField setReturnKeyType:UIReturnKeyNext];
    [phoneMessageSafeCodeTextField setKeyBoardType:UIKeyboardTypeNumberPad];
    [phoneMessageSafeCodeTextField setPlaceholder:@"短信验证码"];
    [bgScrollView addSubview:phoneMessageSafeCodeTextField];
    
    //发送短信验证码按钮
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessageButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    sendMessageButton.tag = 2;
    sendMessageButton.frame = CGRectMake(phoneMessageSafeCodeTextField.frame.origin.x+phoneMessageSafeCodeTextField.frame.size.width+5, _begY, contentView.frame.size.width-2*MARGIN_LEFT-phoneMessageSafeCodeTextField.frame.size.width-5, INPUTTEXTFILED_HEIGHT);
    [sendMessageButton setBackgroundImage:[[UIImage imageNamed:@"code-bg.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [sendMessageButton setTitle:@" 点击获取短信验证码" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:[UIColor colorWithRed:57/255.0 green:84/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgScrollView addSubview:sendMessageButton];
    
    //显示倒计时
    self.timerLabel = [[[UILabel alloc] init] autorelease];
    timerLabel.hidden = YES;
    timerLabel.font = [UIFont systemFontOfSize:16];
    timerLabel.textColor = [UIColor grayColor];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.frame = CGRectMake(sendMessageButton.frame.size.width-35, 4, 20, 35);
    [sendMessageButton addSubview:timerLabel];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //姓名
    self.usernameTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [usernameTextField setDelegate:self];
    [usernameTextField setReturnKeyType:UIReturnKeyNext];
    [usernameTextField setFieldTag:4];
    [usernameTextField setTitle:@"姓名:"];
    [usernameTextField setPlaceholder:@"请输入姓名"];
    [bgScrollView addSubview:usernameTextField];
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //身份证
    self.userIdentifierTextField = [[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)];
    [userIdentifierTextField setDelegate:self];
    [userIdentifierTextField setReturnKeyType:UIReturnKeyNext];
    //[userIdentifierTextField setKeyBoardType:UIKeyboardTypeNumberPad];
    [userIdentifierTextField setFieldTag:5];
    [userIdentifierTextField setTitle:@"身份证号码:"];
    [userIdentifierTextField setPlaceholder:@"请输入18位身份证号码"];
    [bgScrollView addSubview:userIdentifierTextField];
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //密码
    self.pwdTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [pwdTextField setDelegate:self];
    [pwdTextField setReturnKeyType:UIReturnKeyNext];
    [pwdTextField setFieldTag:6];
    [pwdTextField setSecureTextEntry:YES];
    [pwdTextField setTitle:@"密码:"];
    [pwdTextField setPlaceholder:@"6到12位的数字或字母"];
    [bgScrollView addSubview:pwdTextField];
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //确认密码
    self.confirmPwdTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [confirmPwdTextField setDelegate:self];
    [confirmPwdTextField setSecureTextEntry:YES];
    [confirmPwdTextField setReturnKeyType:UIReturnKeyDone];
    [confirmPwdTextField setFieldTag:7];
    [confirmPwdTextField setTitle:@"密码确认:"];
    [confirmPwdTextField setPlaceholder:@"请再次输入密码"];
    [bgScrollView addSubview:confirmPwdTextField];
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //注册按钮
    _begY+=3;
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame = CGRectMake(MARGIN_LEFT, _begY, contentView.frame.size.width-2*MARGIN_LEFT, 47);
    registerButton.tag = 3;
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [registerButton setTitle:@"注        册" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [bgScrollView addSubview:registerButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //第一次进来,让获取短信验证码按钮和注册按钮不可用
    registerButton.enabled = NO;
    sendMessageButton.enabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}

//短信倒计时timer
-(void)timerEvent:(NSTimer *)msgTimer{
    if (!timerLabel.hidden) {
        sendMessageButton.enabled = NO;
        timerLabel.text =[NSString stringWithFormat:@"%d",timerCount];
        timerCount--;
        
        if (timerCount==0) {
            //让发送短信按钮再次可用
            timerLabel.hidden = YES;
            sendMessageButton.enabled = YES;
            sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
    }
}

/**
 请求获取图片验证码
 */
-(void) getSafeCode
{
    isLoadingSafeCodeImage = YES;
    registerButton.enabled = NO;
    sendMessageButton.enabled = NO;
    
    //等待获取图片验证码图片提示框
    UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadView.center = CGPointMake(12, imageSafeCodeButton.frame.size.height/2);
    [imageSafeCodeButton addSubview:loadView];
    [loadView release];
    [loadView startAnimating];
    
    //清空存储数组
    [safeCodeRandomString deleteCharactersInRange:NSMakeRange(0, safeCodeRandomString.length)];
    //重新存储新随机数
    [safeCodeRandomString appendFormat:@"%@",[self createRandomString]];
    //生成获取随机验证码图片url地址
    NSString *postUrl = [NSString stringWithFormat:@"%@captchacenter/service/saturn_captcha?sessionID=%@",HOST_URL,safeCodeRandomString];
    //请求图片验证码
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:postUrl]]];
    
    if (image==nil) {
        //获取验证码失败
        [imageSafeCodeButton setTitle:@"获取验证码失败" forState:UIControlStateNormal];
        [loadView stopAnimating];
        [loadView removeFromSuperview];
        isLoadingSafeCodeImage = NO;
    }
    else
    {
        //获取图片验证码成功
        [imageSafeCodeButton setTitle:nil forState:UIControlStateNormal];
        [imageSafeCodeButton setImage:image forState:UIControlStateNormal];
        [imageSafeCodeButton setImage:image forState:UIControlStateHighlighted];
        
        [loadView stopAnimating];
        [loadView removeFromSuperview];
        isLoadingSafeCodeImage = NO;
        registerButton.enabled = YES;
        sendMessageButton.enabled = YES;
    }
    
}

/**
 处理按钮点击事件
 @param sender 系统参数
 */
-(void) btnClick:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    
    //隐藏键盘
    if (self.focusTextField!=nil) {
        [self.focusTextField resignFirstResponder];
    }
    
    if (tempButton.tag==1) {
        //处理获取图片验证码
        [self getSafeCode];
    }
    else if(tempButton.tag==2){
        //处理发送短信验证码
        if([Helper StringIsNullOrEmpty:[phoneNumTextField getInputText]])
        {
            //手机号码输入为空
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入手机号码!"];
        }
        else if([Helper StringIsNullOrEmpty:[imageSafeCodeTextField getInputText]])
        {
            //图片验证码输入为空
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入图片验证码!"];
        }
        else
        {
            //图片验证码不为空
            if([phoneNumTextField getInputText].length!=11)
            {
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入11位手机号码!"];
            }
            else if([imageSafeCodeTextField getInputText].length!=4)
            {
                //图片验证码必须为4位
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入4位图片验证码!"];
            }
            else{
                //发送获取短信验证码请求
                /*
                NSHttpBlock *httpInfo = [[NSHttpBlock alloc]init];
                httpInfo.requestUrl= [NSString stringWithFormat:@"%@/mtp/registerSendSms",HOST_URL];
                NSMutableDictionary *postDataDictionary = [[[NSMutableDictionary alloc]init]autorelease];
                [postDataDictionary setValue:[phoneNumTextField getInputText] forKey:@"UserMp"];
                [postDataDictionary setValue:[imageSafeCodeTextField getInputText] forKey:@"Captcha"];
                [postDataDictionary setValue:safeCodeRandomString forKey:@"CaptchaSessionId"];
                httpInfo.requestKeyValue = postDataDictionary;
                httpInfo.httpId = 1;
                httpInfo.requestMethod = @"POST";
                [self sendHttpRequest:httpInfo];
                */
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                
                [dict setValue:[phoneNumTextField getInputText] forKey:@"UserMp"];
                [dict setValue:[imageSafeCodeTextField getInputText] forKey:@"Captcha"];
                [dict setValue:safeCodeRandomString forKey:@"CaptchaSessionId"];
                
                [regService requestForSendSMS:dict];
            }
        }
    }
    else
    {
        //处理用户注册
        
        if (!isGetMessageCode) {
            if (isFirstGetMessageCode) {
                //如果是第一次提示用户获取短信验证码
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请先获取短信验证码!"];
            }
            else
            {
                //如果是提示用户再次获取短信验证码
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请重新获取短信验证码!"];
            }
            return;
        }
        
        //验证手机号码输入框不能为空
        if ([Helper StringIsNullOrEmpty:[phoneNumTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入手机号码!"];
            return;
        }
        
        //验证图片验证码必须输入
        if([imageSafeCodeTextField getInputText].length != 4){
            //图片验证码必须为4位
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入4位图片验证码!"];
            return;
        }
        
        //验证短信输入框不能为空
        if ([Helper StringIsNullOrEmpty:[phoneMessageSafeCodeTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输短信验证码!"];
            return;
        }
        //验证姓名输入框不能为空
        if ([Helper StringIsNullOrEmpty:[usernameTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入姓名!"];
            return;
        }
        //验证身份证号码输入框不能为空
        if ([Helper StringIsNullOrEmpty:[userIdentifierTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入身份证号码!"];
            return;
        }
        
        //输入密码框不能为空
        if ([Helper StringIsNullOrEmpty:[pwdTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入密码!"];
            return;
        }
        
        //重复密码输入框不能为空
        if ([Helper StringIsNullOrEmpty:[confirmPwdTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入确认密码!"];
            return;
        }
        
        //判断输入的密码是否包含非数字或字符
        if ([Helper containInvalidChar:[pwdTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"密码包含非法字符"];
            return;
        }
        
        //验证手机号码长度是否为11位
        if([phoneNumTextField getInputText].length!=11)
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入11位手机号码!"];
            return;
        }
        //验证短信验证码是否为6位
        if([phoneMessageSafeCodeTextField getInputText].length!=6)
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入6位短信验证码"];
            return;
        }
        
        //验证身份证号码是否为18位
        if([userIdentifierTextField getInputText].length!=18)
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入18位身份证号码!"];
            return;
        }
        
        //密码长度在6到12位之间
        if([pwdTextField getInputText].length<6||[pwdTextField getInputText].length>12)
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"密码为6到12位的数字或字母!"];
            return;
        }
        //确认密码长度在６到１２位之间
        if([confirmPwdTextField getInputText].length<6||[confirmPwdTextField getInputText].length>12)
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"确认密码为6到12位的数字或字母!"];
            return;
        }
        //判断两次输入密码是否一致
        if(![[pwdTextField getInputText] isEqualToString:[confirmPwdTextField getInputText]])
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"两次密码输入不一致!"];
            return;
        }
        
        /*
        [self showWaitNotice:@"注册中..."];
        
        //处理注册事件
        NSHttpBlock *httpInfo = [[NSHttpBlock alloc]init];
        httpInfo.requestUrl= [NSString stringWithFormat:@"%@/mtp/register",HOST_URL];
        NSMutableDictionary *postDataDictionary = [[[NSMutableDictionary alloc]init]autorelease];
        [postDataDictionary setValue:[phoneNumTextField getInputText] forKey:@"LoginId"];
        [postDataDictionary setValue:[usernameTextField getInputText] forKey:@"UserName"];
        [postDataDictionary setValue:[userIdentifierTextField getInputText] forKey:@"CertId"];
        [postDataDictionary setValue:[phoneMessageSafeCodeTextField getInputText] forKey:@"SmsCode"];
        [postDataDictionary setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,[pwdTextField getInputText]]] forKey:@"LoginPwd"];
        httpInfo.requestKeyValue = postDataDictionary;
        httpInfo.httpId = 2;
        httpInfo.requestMethod = @"POST";
        [self sendHttpRequest:httpInfo];
        */
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [dict setValue:[phoneNumTextField getInputText] forKey:@"LoginId"];
        [dict setValue:[usernameTextField getInputText] forKey:@"UserName"];
        [dict setValue:[userIdentifierTextField getInputText] forKey:@"CertId"];
        [dict setValue:[phoneMessageSafeCodeTextField getInputText] forKey:@"SmsCode"];
        [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,[pwdTextField getInputText]]] forKey:@"LoginPwd"];
        
        [regService requestForRegisterUsr:dict];
    }
}

-(void)smsRequestDidFinished{
    isGetMessageCode = YES;
    isFirstGetMessageCode = NO;
    
    timerCount = 60;
    timerLabel.text = [NSString stringWithFormat:@"%d", timerCount];
    sendMessageButton.enabled = NO;
    timerLabel.hidden = NO;
    sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

-(void)regRequestDidFinished:(PosMiniCPRequest *)req{
    [Helper saveValue:[phoneNumTextField getInputText] forKey:POSMINI_LOGIN_ACCOUNT];
    [SFHFKeychainUtils storeUsername:[phoneNumTextField getInputText]
                         andPassword:[pwdTextField getInputText]
                      forServiceName:KEYCHAIN_SFHF_SERVICE
                      updateExisting:YES error:nil];
    [Helper saveValue:[usernameTextField getInputText] forKey:POSMINI_LOGIN_USERNAME];
    [Helper saveValue:[req.responseAsJson valueForKey:@"CustId"] forKey:POSMINI_CUSTOMER_ID];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) loginSuccess];
}

#pragma mark UITextFieldDelegate Method

//TextField开始获取焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.focusTextField = textField;
    
    if (IS_IPHONE5 == NO) {
        //如果不是iphone5
        switch (textField.tag) {
            case 3:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+10);
                bgScrollView.contentOffset = CGPointMake(0, 20);
                break;
            case 4:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+10);
                bgScrollView.contentOffset = CGPointMake(0, 50);
                break;
            case 5:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+60);
                bgScrollView.contentOffset = CGPointMake(0, 100);
                break;
            case 6:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+110);
                bgScrollView.contentOffset = CGPointMake(0, 150);
                break;
            case 7:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+160);
                bgScrollView.contentOffset = CGPointMake(0, 200);
                break;
        }
        
    }
    else
    {
        //如果是iphone5
        switch (textField.tag) {
            case 5:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+10);
                bgScrollView.contentOffset = CGPointMake(0, 10);
                break;
            case 6:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+50);
                bgScrollView.contentOffset = CGPointMake(0, 50);
                break;
            case 7:
                bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, bgScrollView.frame.size.height+100);
                bgScrollView.contentOffset = CGPointMake(0, 100);
                break;
        }
    }
    return YES;
}

//TextField失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field tag---%d",textField.tag);
    self.focusTextField = nil;
}
//点击Return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag ==7) {
        [textField resignFirstResponder];
    }
    else
    {
        //如果点击的是Next键，让下一个文本输入框获取焦点
        RegTextField *nextTextField = (RegTextField *)[bgScrollView viewWithTag:textField.tag+1];
        [nextTextField setBecomeFirstResponder];
    }
    return YES;
}

/**
 监听键盘隐藏事件
 @param sender 系统参数
 */
-(void)keyboardWillHide:(id)sender
{
    bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width, contentView.frame.size.height);
    bgScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark Private Method
//产生随机8位数作为图片验证码种子
-(NSString *)createRandomString
{
    NSArray *changeArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    NSLog(@"%d",changeArray.count);
    NSMutableString *randomString = [[[NSMutableString alloc]init]autorelease];
    for (int i=0; i<8; i++) {
        [randomString appendFormat:@"%@",[changeArray objectAtIndex:arc4random()%36]];
    }
    return randomString;
}



@end

























