//
//  RegService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-16.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RegService.h"
#import "RegisterViewController.h"

@implementation RegService

-(void)requestForSendSMS:(NSMutableDictionary *)dict{
    NSString* url = [NSString stringWithFormat:@"/mtp/registerSendSms"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    posReq.reqtype = REQ_SMS;
    [posReq onRespondTarget:self selector:@selector(smsRequestDidFinished:)];
    [posReq execute];
}

-(void)smsRequestDidFinished:(PosMiniCPRequest *)req{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信发送成功，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    if (target && [target isKindOfClass:[RegisterViewController class]]) {
        RegisterViewController *rg = (RegisterViewController *)target;
        [rg smsRequestDidFinished];
    }
}

//处理失败状态未定义的状态码
- (void) processMTPRespDesc:(PosMiniCPRequest *)req{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:req.respDesc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    if (target && [target respondsToSelector:@selector(getSafeCode)]) {
        [target performSelector:@selector(getSafeCode)];
    }
    if (req.reqtype == REQ_SMS) {
        
    }
    else if (req.reqtype == REQ_REG) {
        if (target && [target isKindOfClass:[RegisterViewController class]]) {
            RegisterViewController *rg = (RegisterViewController *)target;
            rg.isGetMessageCode = NO;
            [rg.imageSafeCodeTextField setInputText:@""];
            [rg.phoneMessageSafeCodeTextField setInputText:@""];
        }
    }
}

-(void)requestForRegisterUsr:(NSMutableDictionary *)dict{
    NSString* url = [NSString stringWithFormat:@"/mtp/registe"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    posReq.reqtype = REQ_REG;
    [posReq onRespondTarget:self selector:@selector(regRequestDidFinished:)];
    [posReq execute];
}

-(void)regRequestDidFinished:(PosMiniCPRequest *)req{
    if (target && [target respondsToSelector:@selector(regRequestDidFinished:)]) {
        [target performSelector:@selector(regRequestDidFinished:) withObject:self];
    }
}

@end









