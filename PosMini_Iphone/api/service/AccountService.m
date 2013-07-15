//
//  AccountService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

-(void)requestForUserInfo{
    [[PosMini sharedInstance] showUIPromptMessage:@"载入中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/mini/queryUserInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(userInfoRequestDidFinished:)];
    [posReq execute];
    
}

-(void)userInfoRequestDidFinished:(ASIHTTPRequest *)req{
    
    
}

@end
