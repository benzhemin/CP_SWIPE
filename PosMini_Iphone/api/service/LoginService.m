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

@implementation LoginService

-(void)loginRequest:(NSString *)acct withSecret:(NSString *)secret{
    NSString* url = [NSString stringWithFormat:@"/mtp/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:acct forKey:@"LoginId"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@",MD5_SEED,secret]] forKey:@"LoginPwd"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [posReq execute];
}

-(void)loginRequestDidFinished:(PosMiniCPRequest *)req{
    id body = req.responseAsJson;
    
    if (NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"1")) {

    }
}

@end
