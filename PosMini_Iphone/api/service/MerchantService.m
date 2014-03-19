//
//  MerchantService.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "MerchantService.h"
#import "PosMiniDevice.h"


@implementation MerchantService
-(void)dealloc{
    [super dealloc];
    
    [_merchantInfoDict release];
}
-(void)requestForSetMerchantInfo:(NSMutableDictionary *)dict{
    [[PosMini sharedInstance] showUIPromptMessage:@"保存中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/mer/modifyMerInfo"];

    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(savedMerchantInfoRequestDidFinished:)];
    [posReq execute];
}

-(void)savedMerchantInfoRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (target && [target respondsToSelector:@selector(savedMerchantInfoRequestDidFinished)]) {
        [target performSelector:@selector(savedMerchantInfoRequestDidFinished)];
    }
}


-(void)requestForMerchantInfo{
    [[PosMini sharedInstance] showUIPromptMessage:@"载入中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/mer/queryMerInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(merchantInfoRequestDidFinished:)];
    [posReq execute];

}
-(void)merchantInfoRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    NSLog(@"MerchantService:%@", body);
    
    self.merchantInfoDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //商户信息
    if (NotNil(body, Merchant_Short_Name)) {
        //存储商户信息
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Short_Name] forKey:Merchant_Short_Name];
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Complete_Name] forKey:Merchant_Complete_Name];
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Province_Id] forKey:Merchant_Province_Id];
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Area_Id] forKey:Merchant_Area_Id];
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Address] forKey:Merchant_Address];
        [_merchantInfoDict setValue:[body valueForKey:Merchant_Telephone] forKey:Merchant_Telephone];
        
        //商户简称保存为全局变量
        [[PosMiniDevice sharedInstance] setSimpeName:[body valueForKey:Merchant_Short_Name]];
        
        if ([_merchantInfoDict valueForKey:Merchant_Telephone] == nil ||
            [[_merchantInfoDict valueForKey:Merchant_Telephone] isKindOfClass:[NSNull class] ] ||
            [[_merchantInfoDict valueForKey:Merchant_Telephone] isEqualToString:@""]) {
            [PosMiniDevice sharedInstance].isSetedMerTel = NO;
        }
        else
        {
            [PosMiniDevice sharedInstance].isSetedMerTel = YES;
        }
    }else{
        [_merchantInfoDict setValue:@"未设置" forKey:@"ShortName"];
    }

    
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:NSSTRING_YES]) {
        [[PosMiniDevice sharedInstance].posReq reqDeviceSN];
    }
    
    [target performSelector:selector];
}


@end
