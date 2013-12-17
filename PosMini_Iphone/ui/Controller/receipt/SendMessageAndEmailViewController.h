//
//  SendMessageAndEmailViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ESignatureService.h"

@interface SendMessageAndEmailViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    ESignatureService *eSignatureService;
}
/**
 *  电话输入框
 */
@property(nonatomic,retain)UITextField *phoneTextField;
/**
 *  电子邮件输入框
 */
@property(nonatomic,retain)UITextField *emailTextField;
@end
