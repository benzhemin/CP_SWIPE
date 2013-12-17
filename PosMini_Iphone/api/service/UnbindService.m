//
//  UnbindService.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "UnbindService.h"
#import "UnbindDeviceViewController.h"

@implementation UnbindService

-(void)requestForSendSMS:(NSMutableDictionary *)dict{
    [[PosMini sharedInstance] showUIPromptMessage:@"验证码获取中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/bind/releaseSendSms"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(smsRequestDidFinished:)];
    [posReq execute];
    
}

-(void)smsRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信发送成功,请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    if (target && [target isKindOfClass:[UnbindDeviceViewController class]]) {
        UnbindDeviceViewController *ud = (UnbindDeviceViewController *)target;
        [ud smsRequestDidFinished];
    }
}

-(void)requestForUnbind:(NSMutableDictionary *)dict{
    [[PosMini sharedInstance] showUIPromptMessage:@"解绑中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/bind/v2/release"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(unbindRequestDidFinished:)];
    [posReq execute];
    
}

-(void)unbindRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (target && [target respondsToSelector:@selector(unbindRequestDidFinished:)]) {
        [target performSelector:@selector(unbindRequestDidFinished:) withObject:req];
    }
}
@end
