//
//  DefaultReceiptViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ReceiptBgView.h"

@interface DefaultReceiptViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    //白色背景
    ReceiptBgView *recpBgView;
    //输入金额框
    UITextField *inputField;
    //金额确认按钮
    UIButton *confirmBtn;
    
    float payAmount;
}

@property (nonatomic, retain) ReceiptBgView *recpBgView;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UIButton *confirmBtn;

/**
 点击确认收款金额页面
 @param sender 系统参数
 */
-(void)confirm:(id)sender;

/**
 处理屏幕点击事件
 @param sender 系统参数
 */
-(void)tapGesture:(UITapGestureRecognizer *)sender;

@end
