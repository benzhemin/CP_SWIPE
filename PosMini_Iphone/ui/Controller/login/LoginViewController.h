//
//  LoginViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginService.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate,UIGestureRecognizerDelegate>{
    //背景图片
    UIImageView *imageBg;
    //输入账户框
    UITextField *accountTextField;
    //输入密码框
    UITextField *pwdTextField;
    //背景滚动ScrollView
    UIScrollView *bgScrollView;
    
    //键盘是否弹起
    Boolean isKeyBoardShow;
    
    //记住帐号
    UIButton *remAcctCheckBtn;
    //记住帐号提示信息
    UIButton *remAcctDescBtn;
    //记住帐号选中
    BOOL remAcctSelected;
    
    //记住密码
    UIButton *remSecretCheckBtn;
    //记住密码提示信息
    UIButton *remSecretDescBtn;
    //记住密码选中
    BOOL remSecretSelected;
    
    //登录按钮
    UIButton *loginButton;
    //注册按钮
    UIButton *registerButton;
    
    LoginService *logService;
}

@property (nonatomic, retain) UIImageView *imageBg;
@property (nonatomic, retain) UITextField *accountTextField;
@property (nonatomic, retain) UITextField *pwdTextField;
@property (nonatomic, retain) UIScrollView *bgScrollView;

@property (nonatomic, retain) UIButton *remAcctCheckBtn;
@property (nonatomic, retain) UIButton *remAcctDescBtn;

@property (nonatomic, retain) UIButton *remSecretCheckBtn;
@property (nonatomic, retain) UIButton *remSecretDescBtn;

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *registerButton;

@property (nonatomic, retain) LoginService *logService;

//处理点击事件
-(void) tapGesture:(UITapGestureRecognizer *)tapGesture;
//登录按钮
-(void) login:(id)sender;
//处理跳转到许可协议
-(void) readLicenseClick:(id)sender;



@end
