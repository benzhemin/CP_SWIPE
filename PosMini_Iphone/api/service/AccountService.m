//
//  AccountService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

@synthesize userInfoDict;

-(void)dealloc{
    [userInfoDict release];
    
    [super dealloc];
}

-(void)requestForUserInfo{
    [[PosMini sharedInstance] showUIPromptMessage:@"载入中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/mini/queryUserInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(userInfoRequestDidFinished:)];
    [posReq execute];
    
}

-(void)userInfoRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNil(body, @"SessionId")) {
        [Helper saveValue:[body valueForKey:@"SessionId"] forKey:POSMINI_LOCAL_SESSION];
    }
    
    self.userInfoDict = [[[NSMutableDictionary alloc] init] autorelease];
    //存储登录信息
    [userInfoDict setValue:[body valueForKey:ACCOUNT_TOTAL_ORDER_COUNT] forKey:ACCOUNT_TOTAL_ORDER_COUNT];
    [userInfoDict setValue:[body valueForKey:ACCOUNT_TOTAL_ORDER_AMOUNT] forKey:ACCOUNT_TOTAL_ORDER_AMOUNT];
    
    //取现银行账户
    if ([[[body valueForKey:ACCOUNT_CASHCARD_NUMBER] description] isEqualToString:@"<null>"]) {
        [userInfoDict setValue:@"未设置" forKey:@"CashCardNo"];
    }else{
        [userInfoDict setValue:[body valueForKey:ACCOUNT_CASHCARD_NUMBER] forKey:ACCOUNT_CASHCARD_NUMBER];
    }
    
    [userInfoDict setValue:[body valueForKey:ACCOUNT_AVAILIABLE_CASH_AMOUNT] forKey:ACCOUNT_AVAILIABLE_CASH_AMOUNT];
    [userInfoDict setValue:[body valueForKey:ACCOUNT_NEED_LIQ_AMOUNT] forKey:ACCOUNT_NEED_LIQ_AMOUNT];
    
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_ACCOUNT_NEED_REFRESH];
    
    [target performSelector:selector];
}

@end











