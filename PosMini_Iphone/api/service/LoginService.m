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
    
    NSString* url = [NSString stringWithFormat:@"/mtp/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:acct forKey:@"LoginId"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,secret]] forKey:@"LoginPwd"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq.userInfo setObject:acct forKey:POSMINI_LOGIN_ACCOUNT];
    [posReq.userInfo setObject:secret forKey:POSMINI_LOGIN_PASSWORD];
    [posReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [posReq execute];
}

-(void)loginRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    NSLog(@"%@", body);
    
    if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"000")) {
        [Helper saveValue:[req.userInfo objectForKey:POSMINI_LOGIN_ACCOUNT] forKey:POSMINI_LOGIN_ACCOUNT];
        [SFHFKeychainUtils storeUsername:[req.userInfo objectForKey:POSMINI_LOGIN_ACCOUNT]
                             andPassword:[req.userInfo objectForKey:POSMINI_LOGIN_PASSWORD]
                          forServiceName:KEYCHAIN_SFHF_SERVICE
                          updateExisting:YES error:nil];
        [Helper saveValue:[body objectForKey:@"UserName"] forKey:POSMINI_LOGIN_USERNAME];
        [Helper saveValue:[body valueForKey:@"CustId"] forKey:POSMINI_CUSTOMER_ID];
        
        if (NotNil(body, @"SessionId")) {
            [Helper saveValue:[body valueForKey:@"SessionId"] forKey:POSMINI_LOCAL_SESSION];
        }
        
        
    }else{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[body objectForKey:@"RespDesc"], NOTIFICATION_MESSAGE, nil];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_SYS_AUTO_PROMPT object:nil userInfo:dict];
    }
}

@end







