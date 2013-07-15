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

@implementation LoginService

-(void)loginRequest:(NSString *)acct withSecret:(NSString *)secret{
    [[PosMini sharedInstance] showUIPromptMessage:@"登录中" animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:acct forKey:@"LoginId"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,secret]] forKey:@"LoginPwd"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [posReq execute];
}

-(void)loginRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    id body = req.responseAsJson;
    
    NSLog(@"%@", body);
    
    if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"000")) {
        
    }else{
        
    }
}

@end
