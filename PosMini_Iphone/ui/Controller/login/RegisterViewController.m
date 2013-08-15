//
//  RegisterViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
//产生随机8位数作为图片验证码种子
-(NSString *)createRandomString;

@end

@implementation RegisterViewController

@synthesize bgScrollView;

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
    
    [super dealloc];
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
    [sendMessageButton setTitle:@"点击获取短信验证码" forState:UIControlStateNormal];
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
}

-(NSString *)createRandomString{
    
}

@end

























