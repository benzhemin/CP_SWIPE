//
//  LoginService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginService.h"
#import "PosMiniCPRequest.h"
#import "Helper.h"
#import "PosMini.h"
#import "NSNotificationCenter+CP.h"
#import "SFHFKeychainUtils.h"

@implementation LoginService

-(void)loginRequest:(NSString *)acct withSecret:(NSString *)secret{
    [[PosMini sharedInstance] showUIPromptMessage:@"登录中" animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/mini/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:acct forKey:@"LoginId"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,secret]] forKey:@"LoginPwd"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    
    NSMutableDictionary *ui = [[[NSMutableDictionary alloc] init] autorelease];
    [ui setObject:acct forKey:POSMINI_LOGIN_ACCOUNT];
    [ui setObject:secret forKey:POSMINI_LOGIN_PASSWORD];
    posReq.userInfo = ui;
    
    [posReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [posReq execute];
}

-(void)loginRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    [Helper saveValue:[req.userInfo objectForKey:POSMINI_LOGIN_ACCOUNT] forKey:POSMINI_LOGIN_ACCOUNT];
    [SFHFKeychainUtils storeUsername:[req.userInfo objectForKey:POSMINI_LOGIN_ACCOUNT]
                         andPassword:[req.userInfo objectForKey:POSMINI_LOGIN_PASSWORD]
                      forServiceName:KEYCHAIN_SFHF_SERVICE
                      updateExisting:YES error:nil];
    [Helper saveValue:[body objectForKey:@"UserName"] forKey:POSMINI_LOGIN_USERNAME];
    [Helper saveValue:[body valueForKey:@"CustId"] forKey:POSMINI_CUSTOMER_ID];
    
    //记录当前登录成功日期
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    [Helper saveValue:[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] forKey:POSMINI_LOGIN_DATE];
    
    [target performSelector:selector];
}

@end







