//
//  SendMessageAndEmailViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SendMessageAndEmailViewController.h"
#import "PosMiniDevice.h"

@interface SendMessageAndEmailViewController ()

@end

@implementation SendMessageAndEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    if (self=[super init]) {
        eSignatureService=[[ESignatureService alloc]init];
        [eSignatureService onRespondTarget:self];
    }
    return self;
}

#define MARGIN_LEFT 15
#define INPUTTEXTFILED_HEIGHT 50
#define LINE_MARGIN 5

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"发送签购单"];
    
    //起始位置y坐标
    float _begY = 15;
    
    UIImageView *phoneImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY,290 ,45)];
    phoneImageView.userInteractionEnabled=YES;
    phoneImageView.image=[UIImage imageNamed:@"send_phone"];
    [contentView addSubview:phoneImageView];
    [phoneImageView release];
    
    self.phoneTextField = [[[UITextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT+35,0, 210, 45)] autorelease];
    [_phoneTextField setTag:1];
    [_phoneTextField setDelegate:self];
    [_phoneTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_phoneTextField setReturnKeyType:UIReturnKeyDone];
    [_phoneTextField setPlaceholder:@"请输入您的手机号码"];
    [_phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
    [_phoneTextField setBackgroundColor:[UIColor clearColor]];
    [_phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [phoneImageView addSubview:_phoneTextField];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    UIImageView *emailImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY,290 ,45)];
    emailImageView.userInteractionEnabled=YES;
    emailImageView.image=[UIImage imageNamed:@"send_email"];
    [contentView addSubview:emailImageView];
    [emailImageView release];
    
    self.emailTextField = [[[UITextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT+35,0, 210, 45)] autorelease];
    [_emailTextField setTag:2];
    [_emailTextField setDelegate:self];
    [_emailTextField setReturnKeyType:UIReturnKeyDone];
    [_emailTextField setPlaceholder:@"请输入您的电子邮箱"];
    [_emailTextField setBackgroundColor:[UIColor clearColor]];
    [_emailTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_emailTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [emailImageView addSubview:_emailTextField];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.exclusiveTouch=YES;
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [sendButton setTitle:@"发   送" forState:UIControlStateNormal];
    sendButton.titleLabel.font=[UIFont boldSystemFontOfSize:22];
    sendButton.frame=CGRectMake(MARGIN_LEFT+8, _begY,274,47);
    sendButton.tag=2;
    [contentView addSubview:sendButton];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
        
    UIButton *ignoreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [ignoreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    ignoreButton.frame=CGRectMake(MARGIN_LEFT+8, _begY,274,47);
    [ignoreButton setBackgroundImage:[UIImage imageNamed:@"ignore"] forState:UIControlStateNormal];
    ignoreButton.exclusiveTouch=YES;
    [ignoreButton setTitle:@"跳   过" forState:UIControlStateNormal];
    ignoreButton.titleLabel.font=[UIFont boldSystemFontOfSize:22];
    ignoreButton.tag=1;
    [contentView addSubview:ignoreButton];
    
    
    //当前view注册屏幕点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}


-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    //隐藏键盘
    [_phoneTextField resignFirstResponder];
}

-(void)buttonClick:(id)sender{
    
    //故障对应#0002607
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *tempBtn=(UIButton *)sender;
    
    if (tempBtn.tag==1) {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if (_phoneTextField.text.length<1 && _emailTextField.text.length<1) {
            [[NSNotificationCenter defaultCenter]postAutoSysPromptNotification:@"请输入手机号码或者电子邮箱!"];
            return;
        }
        
        if (_phoneTextField.text.length>0) {
            if (_phoneTextField.text.length !=11) {
                [[NSNotificationCenter defaultCenter]postAutoSysPromptNotification:@"请输入11位手机号码!"];
                return;
            }
        }

        if (_emailTextField.text.length>0) {
            if (_emailTextField.text.length >40) {
                [[NSNotificationCenter defaultCenter]postAutoSysPromptNotification:@"邮箱长度不能超过40位!"];
                return;
            }
            
            NSString * regex = @"(^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$)";
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:_emailTextField.text];
            if (isMatch==NO) {
                
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输入正确的邮箱!"];
                return;
            }
        }
        
        PosMiniDevice *pos = [PosMiniDevice sharedInstance];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
        [dict setValue:pos.orderId forKey:@"OrdId"];
        [dict setValue:_phoneTextField.text forKey:@"UserMp"];
        [dict setValue:_emailTextField.text forKey:@"UserEmail"];
        
        [eSignatureService requestForSendESignature:dict];
    }

}
-(void)eSignatureRequestDidFinished{

    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"发送成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00013";
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1)
    {
        //判断输入长度是否超过11
        if (![string isEqualToString:@""])
        {
            if (textField.text.length >= 11)
            {
                return NO;
            }
        }

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 内存清理
-(void)dealloc{
    [eSignatureService release];
    [_phoneTextField release];
    [_emailTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
