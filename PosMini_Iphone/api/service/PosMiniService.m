//
//  TradeLimitService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMiniService.h"
#import "BaseViewController.h"
#import "PosMiniDevice.h"
#import "DefaultAccountViewController.h"

@interface AlertDelegateClass : NSObject<UIAlertViewDelegate>{
    NSString *deviceSN;
    PosMiniService *posService;
}
@property (nonatomic, copy) NSString *deviceSN;
@property (nonatomic, assign) PosMiniService *posService;
@end

@implementation AlertDelegateClass
@synthesize deviceSN, posService;

-(void)dealloc{
    [deviceSN release];
    [super dealloc];
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [posService requestForPosBindAction:deviceSN];
    }
}
@end

@implementation PosMiniService

-(void)dealloc{
    [ad release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        ad = [[AlertDelegateClass alloc] init];
        ad.posService = self;
    }
    return self;
}

//请求交易限额
-(void)requestForTradeLimit{
    //取消交易限额请求
    return;
    
    [[PosMini sharedInstance] showUIPromptMessage:@"请求交易限额..." animated:YES];
    
    /*Mod_S 启明 张翔 功能点：接口变更*/
    //NSString* url = [NSString stringWithFormat:@"/mtp/action/query/mini/limitAmt"];
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/mini/v2/limitAmt"];
    /*Mod_E 启明 张翔 功能点：接口变更*/
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    [dict setValue:[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID] forKey:@"MtId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(tradeLimitRequestDidFinished:)];
    [posReq execute];
}

-(void)tradeLimitRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    //单笔交易限额
    if (NotNil(body, @"OneLimitAmt")) {
        [Helper saveValue:[body valueForKey:@"OneLimitAmt"] forKey:POSMINI_ONE_LIMIT_AMOUNT];
    }
    
    //每日交易限额
    if (NotNil(body, @"SumLimitAmt")) {
        [Helper saveValue:[body valueForKey:@"SumLimitAmt"] forKey:POSMINI_SUM_LIMIT_AMOUNT];
    }
    
    //账户信息页面需要刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_ACCOUNT object:nil];
}

//查询pos绑定状态
-(void)requestForPosBindStatus:(NSString *)deviceSN
{
    [[PosMini sharedInstance] showUIPromptMessage:@"设备查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/queryBindStat"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    [dict setValue:deviceSN forKey:@"MtId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    posReq.userInfo = [NSDictionary dictionaryWithObject:deviceSN forKey:POSMINI_DEVICE_ID];
    [posReq onRespondTarget:self selector:@selector(posBindStatusDidFinished:)];
    [posReq execute];
}

-(void)posBindStatusDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNil(body, @"BindStat")) {
        [PosMiniDevice sharedInstance].isDeviceLegal = NO;
        
        NSString *bindStatus = [body valueForKey:@"BindStat"];
        
        if ([bindStatus isEqualToString:@"C"]) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备已解绑!"];
        }
        else if([bindStatus isEqualToString:@"O"])
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"该设备已被他人绑定!"];
        }
        else if([bindStatus isEqualToString:@"I"])
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备尚未灌注密钥!"];
        }
        /*Mod_S 启明 张翔 功能点:解除绑定*/
//        else if([bindStatus isEqualToString:@"K"])
        else if([bindStatus isEqualToString:@"K"] || [bindStatus isEqualToString:@"U"])
        /*Mod_E 启明 张翔 功能点:解除绑定*/
        {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"终端未绑定"];
            
            ad.deviceSN = [req.userInfo valueForKey:POSMINI_DEVICE_ID];
            //提示用户是否绑定设备和账户
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否绑定该设备和用户！" delegate:ad cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alertView show];
            [alertView release];
        }
        else if([bindStatus isEqualToString:@"N"])
        {
            [PosMiniDevice sharedInstance].isDeviceLegal = YES;
            
            //设备跟账户已经绑定
            if (NotNil(req.userInfo, POSMINI_DEVICE_ID)) {
                [Helper saveValue:[req.userInfo valueForKey:POSMINI_DEVICE_ID] forKey:POSMINI_DEVICE_ID];
            }
            
            //设备正常
        }
    }
}

//请求绑定设备
-(void)requestForPosBindAction:(NSString *)deviceSN{
    [[PosMini sharedInstance] showUIPromptMessage:@"绑定中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/bind/bind"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    [dict setValue:deviceSN forKey:@"MtId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    posReq.userInfo = [NSDictionary dictionaryWithObject:deviceSN forKey:POSMINI_DEVICE_ID];
    [posReq onRespondTarget:self selector:@selector(posBindActionDidFinished:)];
    [posReq execute];
}

-(void)posBindActionDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    //设备与账户已绑定
    [Helper saveValue:[req.userInfo valueForKey:POSMINI_DEVICE_ID] forKey:POSMINI_DEVICE_ID];
    //刷新账户页面
    [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
    //绑定成功
    [PosMiniDevice sharedInstance].isDeviceLegal = YES;
    
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备绑定成功!"];
    
    /*Add_S 启明 张翔 功能点：解除绑定*/
    if ([[[PosMiniDevice sharedInstance].baseCTRL controllerName]isEqualToString:@"DefaultAccountViewController"])
    {
        DefaultAccountViewController *accountCTRL = (DefaultAccountViewController *)[PosMiniDevice sharedInstance].baseCTRL;
        [accountCTRL setBindedMtId];
    }
    /*Add_E 启明 张翔 功能点：解除绑定*/
}

//签到接口,获取工作密钥
-(void)requestForPosTradeSignIn:(NSString *)deviceSN{
    [[PosMini sharedInstance] showUIPromptMessage:@"签到中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/signIn"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    [dict setValue:deviceSN forKey:@"MtId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    posReq.userInfo = [NSMutableDictionary dictionaryWithObject:deviceSN forKey:POSMINI_DEVICE_ID];
    [posReq onRespondTarget:self selector:@selector(posTradeSignInDidFinished:)];
    [posReq execute];
}

-(void)posTradeSignInDidFinished:(PosMiniCPRequest *)req{
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    NSLog(@"posTradeSignInDidFinished:%@", body);
    
    PosMiniDevice *pos = [PosMiniDevice sharedInstance];
    
    //灌注Pin密钥和Package密钥之前,再判断刷卡器是否连接,设备是否合法
    if (![[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:NSSTRING_YES]) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请插入设备"];
        return;
    }
    //设备是否合法
    if (pos.isDeviceLegal == NO) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"不是合法设备"];
        return;
    }
    
    pos.orderId = [body valueForKey:@"OrdId"];
    pos.md5Key = [body valueForKey:@"Md5Key"];
    
    KeyInfo *key = [[[KeyInfo alloc] init] autorelease];
    key.pinKey = [NSString stringWithFormat:@"%@%@",[body valueForKey:@"PinKey"],[[body valueForKey:@"PinKvc"]  substringToIndex:8]];
    key.pinKeyType = PIN_KEY;
    key.pinKeyIndex = 2;
    key.packageKey = [NSString stringWithFormat:@"%@%@",[body valueForKey:@"PackKey"],[[body valueForKey:@"PackKvc"] substringToIndex:8]];
    key.packageKeyType = PACKET_KEY;
    key.packageKeyIndex = 3;
    
    pos.keyInfo = key;
    
    [pos injectKeysWithInfo];
}



@end

