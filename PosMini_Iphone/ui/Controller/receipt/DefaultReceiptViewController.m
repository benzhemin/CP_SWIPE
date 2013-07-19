//
//  DefaultReceiptViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultReceiptViewController.h"
#include "textctrl.h"

@interface DefaultReceiptViewController ()

@end

@implementation DefaultReceiptViewController

@synthesize recpBgView, inputField;

-(void)dealloc{
    [recpBgView release];
    [inputField release];
    
    [super dealloc];
}

#define DASH_LINE_HEIGHT 50
#define FULL_LINE_HEIGHT (50+72)

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNavigationTitle:@"刷卡收款"];
    
    UIImage *btmImg = [UIImage imageNamed:@"btm.png"];
    
    //收据背景
    self.recpBgView = [[[ReceiptBgView alloc] init] autorelease];
    recpBgView.dashLineHeight = DASH_LINE_HEIGHT;
    recpBgView.fullLineHeight = FULL_LINE_HEIGHT;
    recpBgView.frame = CGRectMake(0, 0, btmImg.size.width, self.contentView.bounds.size.height*3/4.0);
    recpBgView.center = CGPointMake(contentView.center.x, recpBgView.center.y);
    [contentView addSubview:recpBgView];
    
    //底部图片
    UIImageView *btmImgView = [[UIImageView alloc] initWithImage:btmImg];
    btmImgView.frame = CGRectMake((contentView.bounds.size.width-btmImg.size.width)/2,
                                  recpBgView.frame.size.height, btmImg.size.width, btmImg.size.height);
    [contentView addSubview:btmImgView];
    [btmImgView release];
    
    //显示收款账户信息
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.textColor = [UIColor colorWithRed:115/250.0 green:115/250.0 blue:115/250.0 alpha:1.0];
    noticeLabel.font = [UIFont systemFontOfSize:16];
    noticeLabel.text = [NSString stringWithFormat:@"收款账户:%@ (%@)",[Helper getValueByKey:POSMINI_LOGIN_USERNAME],[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT]];
    noticeLabel.frame = CGRectMake(24, 11, 270, 30);
    noticeLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:noticeLabel];
    [noticeLabel release];
    
    //收款金额输入框
    inputField = [[UITextField alloc]init];
    inputField.font = [UIFont boldSystemFontOfSize:20];
    inputField.placeholder = @"请输入收款金额";
    inputField.delegate = self;
    inputField.keyboardType = UIKeyboardTypeNumberPad;
    inputField.returnKeyType = UIReturnKeyDone;
    inputField.frame = CGRectMake(24, 73, 200, 40);
    [recpBgView addSubview:inputField];
    [inputField release];
    
    //显示单位
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = [UIColor colorWithRed:179/250.0 green:179/250.0 blue:179/250.0 alpha:1.0];
    unitLabel.font = [UIFont boldSystemFontOfSize:20];
    unitLabel.text = @"元";
    unitLabel.frame = CGRectMake(240, 66, 40, 40);
    unitLabel.textAlignment = UITextAlignmentLeft;
    [recpBgView addSubview:unitLabel];
    [unitLabel release];
    
    //确认收款按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake((contentView.bounds.size.width-btmImg.size.width)/2, 150, 274, 47);
    
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"金 额 确 认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [recpBgView addSubview:confirmBtn];
    
    //当前view注册屏幕点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [inputField becomeFirstResponder];
}

#define TEXT_LEN 20

#pragma mark UITextFieldDelegate Method
//输入收款金额文字框输入改变时，自动修改输入金额数据格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //第一次进来设置text为0.00
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
    }
    
    //C trick, use c pointers make things simpler.
    char text[TEXT_LEN];
    bzero(text, TEXT_LEN);
    strcpy(text, [textField.text UTF8String]);
    //输入删除
    if ([string isEqualToString:@""]) {
        delete_amount(text);
    }
    else {
        //如果输入收款超过999999.99，使输入无效
        if (textField.text.length>=9) {
            return NO;
        }
        insert_amount(text, *[string UTF8String]);
    }
    NSString *textStr = [NSString stringWithUTF8String:text];
    textField.text = [textStr isEqualToString:@"0.00"] ? @"" : textStr;
    
    return NO;
}






/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00002";
}

/**
 处理屏幕点击事件
 @param sender 系统参数
 */
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    //隐藏键盘
    [inputField resignFirstResponder];
}
@end
