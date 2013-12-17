//
//  UnbindDeviceViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "RegTextField.h"
#import "UnbindService.h"

@interface UnbindDeviceViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UnbindService *unbindService;
    //是否已经获取短信验证码
    Boolean isGetMessageCode;
    //是否是第一次获取短信验证码
    Boolean isFirstGetMessageCode;
    //Timer计数器
    int timerCount;
    
}
/**
 *  用户信息
 */
@property (nonatomic,retain) NSDictionary *userInfoDic;
/**
 *  手机号码
 */
@property (nonatomic,retain) RegTextField *phoneNumTextField;
/**
 *  手机验证码
 */
@property (nonatomic,retain) RegTextField *phoneMessageSafeCodeTextField;
/**
 *  设备编号
 */
@property (nonatomic,retain) RegTextField *bindedMtIdTextField;
/**
 *  发送按钮
 */
@property (nonatomic,retain) UIButton *sendMessageButton;
/**
 *  倒计时标签
 */
@property (nonatomic,retain) UILabel *timerLabel;
/**
 *  计时器
 */
@property (nonatomic, retain) NSTimer *timer;


-(void)smsRequestDidFinished;
-(void)unbindRequestDidFinished:(PosMiniCPRequest *)req;
@end
