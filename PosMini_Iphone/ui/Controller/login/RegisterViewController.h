//
//  RegisterViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "RegTextField.h"
#import "RegService.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>{
    //背景ScrollView
    UIScrollView *bgScrollView;
    
    //手机号码
    RegTextField *phoneNumTextField;
    //图片验证码
    RegTextField *imageSafeCodeTextField;
    //短信验证码
    RegTextField *phoneMessageSafeCodeTextField;
    //姓名
    RegTextField *usernameTextField;
    //身份证号
    RegTextField *userIdentifierTextField;
    //密码
    RegTextField *pwdTextField;
    //确认密码
    RegTextField *confirmPwdTextField;
    
    //图片验证码
    UIButton *imageSafeCodeButton;
    //发送短信按钮
    UIButton *sendMessageButton;
    //注册按钮
    UIButton *registerButton;
    
    //获取焦点文本输入框
    UITextField *focusTextField;
    
    //是否正在获取图片验证码
    Boolean isLoadingSafeCodeImage;
    
    //存储随机图片验证码种子
    NSMutableString *safeCodeRandomString;
    //是否已经获取短信验证码
    Boolean isGetMessageCode;
    //是否是第一次获取短信验证码
    Boolean isFirstGetMessageCode;
    //显示倒计时
    UILabel *timerLabel;
    //Timer计数器
    int timerCount;
    
    NSTimer *timer;
    
    RegService *regService;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;

@property (nonatomic, assign) Boolean isGetMessageCode;
@property (nonatomic, assign) Boolean isFirstGetMessageCode;

@property (nonatomic, retain) RegTextField *phoneNumTextField;
@property (nonatomic, retain) RegTextField *imageSafeCodeTextField;
@property (nonatomic, retain) UIButton *imageSafeCodeButton;
@property (nonatomic, retain) RegTextField *phoneMessageSafeCodeTextField;
@property (nonatomic, retain) UIButton *sendMessageButton;
@property (nonatomic, retain) UILabel *timerLabel;

@property (nonatomic, retain) RegTextField *usernameTextField;
@property (nonatomic, retain) RegTextField *userIdentifierTextField;
@property (nonatomic, retain) RegTextField *pwdTextField;
@property (nonatomic, retain) RegTextField *confirmPwdTextField;
@property (nonatomic, retain) UIButton *registerButton;

@property (nonatomic, retain) UITextField *focusTextField;

@property (nonatomic, retain) NSTimer *timer;

-(void)smsRequestDidFinished;
-(void)regRequestDidFinished:(PosMiniCPRequest *)req;

-(void) getSafeCode;

@end















