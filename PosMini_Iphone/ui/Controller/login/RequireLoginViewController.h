//
//  RequireLoginViewController.h
//  PosMini_Iphone
//
//  Created by ben on 13-7-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginService.h"

@interface RequireLoginViewController : BaseViewController <UITextFieldDelegate>{
    //背景图片
    UIImageView *imgBgView;
    //输入账户
    UITextField *acctTextField;
    //输入密码
    UITextField *pwdTextField;
    //背景滚动ScrollView
    UIScrollView *bgScrollView;
    
    //键盘是否弹起
    Boolean isKeyBoardShow;
    
    LoginService *logService;
}

@property (nonatomic, retain) UIImageView *imgBgView;
@property (nonatomic, retain) UIScrollView *bgScrollView;

@property (nonatomic, retain) UITextField *acctTextField;
@property (nonatomic, retain) UITextField *pwdTextField;

@property (nonatomic, retain) LoginService *logService;

-(void)login:(id)sender;

@end
