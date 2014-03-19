//
//  UnbindDeviceViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "UnbindDeviceViewController.h"
#import "Helper.h"
#import "DefaultAccountViewController.h"

@interface UnbindDeviceViewController ()

@end

@implementation UnbindDeviceViewController

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
        unbindService=[[UnbindService alloc]init];
        [unbindService onRespondTarget:self];
    }
    return self;
}

#define MARGIN_LEFT 15
#define INPUTTEXTFILED_HEIGHT 45
#define LINE_MARGIN 5

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"解除绑定"];
    
    isFirstGetMessageCode=YES;
    
    //起始位置y坐标
    float _begY = 10;
    //手机号码
    self.phoneNumTextField = [[[RegTextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [_phoneNumTextField setTitle:@"手机号码:"];
    [_phoneNumTextField setPlaceholder:[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT]];
    [_phoneNumTextField setUserInteractionEnabled:NO];
    [contentView addSubview:_phoneNumTextField];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    
    self.bindedMtIdTextField = [[[RegTextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT,_begY, contentView.frame.size.width-2*MARGIN_LEFT, INPUTTEXTFILED_HEIGHT)] autorelease];
    [_bindedMtIdTextField setTitle:@"设备编号:"];
    [_bindedMtIdTextField setPlaceholder:[_userInfoDic valueForKey:@"BindedMtId"]];
    [_bindedMtIdTextField setUserInteractionEnabled:NO];
    [contentView addSubview:_bindedMtIdTextField];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    
    //短信验证码输入框
    self.phoneMessageSafeCodeTextField = [[[RegTextField alloc]initWithFrame:CGRectMake(MARGIN_LEFT,_begY, 110, INPUTTEXTFILED_HEIGHT)] autorelease];
    [_phoneMessageSafeCodeTextField setDelegate:self];
    [_phoneMessageSafeCodeTextField setFieldTag:3];
    [_phoneMessageSafeCodeTextField setReturnKeyType:UIReturnKeyDone];
    [_phoneMessageSafeCodeTextField setKeyBoardType:UIKeyboardTypeDefault];
    [_phoneMessageSafeCodeTextField setPlaceholder:@"短信验证码"];
    [contentView addSubview:_phoneMessageSafeCodeTextField];
    
    //发送短信验证码按钮
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendMessageButton.tag = 1;
    _sendMessageButton.frame = CGRectMake(_phoneMessageSafeCodeTextField.frame.origin.x+_phoneMessageSafeCodeTextField.frame.size.width+5, _begY, contentView.frame.size.width-2*MARGIN_LEFT-_phoneMessageSafeCodeTextField.frame.size.width-5, INPUTTEXTFILED_HEIGHT);
    [_sendMessageButton setBackgroundImage:[[UIImage imageNamed:@"code-bg.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    //故障对应#0002735
    [_sendMessageButton setTitle:@" 点击获取短信验证码" forState:UIControlStateNormal];
    [_sendMessageButton setTitleColor:[UIColor colorWithRed:57/255.0 green:84/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
    _sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:_sendMessageButton];
    
    //显示倒计时
    self.timerLabel = [[[UILabel alloc] init] autorelease];
    _timerLabel.hidden = YES;
    _timerLabel.font = [UIFont systemFontOfSize:16];
    _timerLabel.textColor = [UIColor grayColor];
    _timerLabel.backgroundColor = [UIColor clearColor];
    _timerLabel.frame = CGRectMake(_sendMessageButton.frame.size.width-35, 4, 20, 35);
    [_sendMessageButton addSubview:_timerLabel];
    
    _begY+=INPUTTEXTFILED_HEIGHT;
    _begY+=LINE_MARGIN;
    
    //确定解绑
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    confirmButton.frame = CGRectMake(20, _begY+10, contentView.frame.size.width-40, 47);
    confirmButton.tag = 2;
    [confirmButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确认解绑" forState:UIControlStateNormal];
    [contentView addSubview:confirmButton];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];

}
//短信倒计时timer
-(void)timerEvent:(NSTimer *)msgTimer{
    if (!_timerLabel.hidden) {
        _sendMessageButton.enabled = NO;
        _timerLabel.text =[NSString stringWithFormat:@"%d",timerCount];
        timerCount--;
        
        if (timerCount==0) {
            //让发送短信按钮再次可用
            _timerLabel.hidden = YES;
            _sendMessageButton.enabled = YES;
            _sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
    }
}

-(void) btnClick:(id)sender
{
    //故障对应#0002609
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *tempButton = (UIButton *)sender;
    
    if(tempButton.tag==1){
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [dict setValue:[_userInfoDic valueForKey:@"BindedMtId"] forKey:@"MtId"];
        [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
        [dict setValue:[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT] forKey:@"UserMp"];
        
        [unbindService requestForSendSMS:dict];
    }
    if (tempButton.tag==2) {
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
        
        //验证短信输入框不能为空
        if ([Helper StringIsNullOrEmpty:[_phoneMessageSafeCodeTextField getInputText]]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请输短信验证码!"];
            return;
        }
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要解绑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=1;
        [alertView show];
        [alertView release];

    }
}
-(void)smsRequestDidFinished{
    isGetMessageCode = YES;
    isFirstGetMessageCode=NO;
    timerCount = 60;
    _timerLabel.text = [NSString stringWithFormat:@"%d", timerCount];
    _sendMessageButton.enabled = NO;
    _timerLabel.hidden = NO;
    _sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

-(void)unbindRequestDidFinished:(PosMiniCPRequest *)req{
    UIAlertView *noticeView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解绑成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    noticeView.tag=2;
    [noticeView show];
    [noticeView release];
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //确认解绑提示框
    if (alertView.tag==1)
    {
        //故障对应#0002736
        if (buttonIndex == 1)
        {
            NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
            
            [dict setValue:[Helper getValueByKey:POSMINI_LOGIN_ACCOUNT] forKey:@"UserMp"];
            [dict setValue:[_phoneMessageSafeCodeTextField getInputText] forKey:@"SmsCode"];
            [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
            [dict setValue:[_userInfoDic valueForKey:@"BindedMtId"] forKey:@"MtId"];
            
            [unbindService requestForUnbind:dict];
        }

    }
    //解绑成功提示框
    if (alertView.tag==2) {
        //解除绑定后，重新设置帐户信息页面的设备编号
        [(DefaultAccountViewController *)[self.navigationController.viewControllers objectAtIndex:0]setBindedMtId];
        [Helper saveValue:POSMINI_DEFAULT_VALUE forKey:POSMINI_MTP_BINDED_DEVICE_ID];
        
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00011";
}

#pragma mark - 内存管理
-(void)dealloc{
   
    [_timer release];
    [unbindService release];
    [_userInfoDic release];
    [_timerLabel release];
    [_phoneNumTextField release];
    [_phoneMessageSafeCodeTextField release];
    [_bindedMtIdTextField release];
    [_sendMessageButton release];
    
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
