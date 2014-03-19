//
//  PayService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PayService.h"
#import "LocationService.h"
#import "PosMiniDevice.h"
#import "PayConfirmViewController.h"
#import "ElectronicSignRequisitionsViewController.h"

@implementation PayService

-(id)init{
    self = [super init];
    if (self) {
        reqCount = 0;
    }
    return self;
}

-(void)requestForPayTrans{
    [[PosMini sharedInstance] showUIPromptMessage:@"交易中..." animated:YES];
    
    LocationService *loc = [LocationService sharedInstance];
    
    NSMutableString *latitude = [NSMutableString stringWithFormat:@""];
    NSMutableString *longitude = [NSMutableString stringWithFormat:@""];
    
    /* Mod_S 启明 费凯峰 功能点:经纬度截取12位*/
    if ([loc isCoordinationEmpty] == NO) {
        
        [latitude appendFormat:@"%f", loc.coordination.latitude];
        [longitude appendFormat:@"%f", loc.coordination.longitude];
        
        if (latitude.length>12) {
            latitude=[NSString stringWithFormat:@"%@",[latitude substringToIndex:12]];
        }
        if (longitude.length>12) {
            longitude=[NSString stringWithFormat:@"%@",[longitude substringToIndex:12]];
        }
    }
    /* Mod_E 启明 费凯峰 功能点:经纬度截取12位*/
    
    PosMiniDevice *pos = [PosMiniDevice sharedInstance];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/advanced/doPay"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:PARAM_CUSTOMER_ID];
    [dict setValue:pos.deviceSN forKey:@"MtId"];
    [dict setValue:pos.orderId forKey:@"OrdId"];
    [dict setValue:pos.paySum forKey:@"OrdAmt"];
    [dict setValue:pos.bankCardAndPassData forKey:@"InfoField"];
    [dict setValue:longitude forKey:@"Longitude"];
    [dict setValue:latitude forKey:@"Latitude"];
    [dict setValue:[Helper base64forData:[NSData dataWithData:UIImagePNGRepresentation([PosMiniDevice sharedInstance].signImg)]] forKey:@"ESignature"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                                   pos.md5Key,
                                   [Helper getValueByKey:POSMINI_CUSTOMER_ID],
                                   pos.deviceSN,
                                   pos.orderId,
                                   pos.paySum,
                                   pos.bankCardAndPassData,
                                   longitude,
                                   latitude]] forKey:@"ChkValue"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(payRequestDidFinished:)];
    [posReq execute];
}

#define TRANS_STATE @"TransStat"

-(void)payRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    NSLog(@"PayService %@",body);
    
    /* Add_S 启明 张翔 功能点:增加电子签购单*/
    //存储电子签购单信息
    [[PosMiniDevice sharedInstance]setEsMerName:[body valueForKey:@"MerName"]];
    [[PosMiniDevice sharedInstance]setEsOrdId:[body valueForKey:@"OrdId"]];
    [[PosMiniDevice sharedInstance]setEsCardNo:[body valueForKey:@"CardNo"]];
    [[PosMiniDevice sharedInstance]setEsCurrentDate:[body valueForKey:@"CurrentDate"]];
    [[PosMiniDevice sharedInstance]setEsCurrentTime:[body valueForKey:@"CurrentTime"]];
    [[PosMiniDevice sharedInstance]setEsOrdAmt:[body valueForKey:@"OrdAmt"]];
    if (NotNil(body, @"ProviderCustId")) {
        [[PosMiniDevice sharedInstance]setEsProviderCustId:[body valueForKey:@"ProviderCustId"]];
    }
    /* Add_E 启明 张翔 功能点:增加电子签购单*/
    
    if (NotNil(body, TRANS_STATE)) {
        //交易成功
        if (NotNilAndEqualsTo(body, TRANS_STATE, @"S")) {
            UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            /* Mod_S 启明 费凯峰 功能点:增加电子签购单*/
            //alertViw.tag = 1;
            alertViw.tag=10;
            /* Mod_E 启明 费凯峰 功能点:增加电子签购单*/
            [alertViw show];
            [alertViw release];
        }
        //交易状态为X,单边账状态,交易失败
        else if (NotNilAndEqualsTo(body, TRANS_STATE, @"X")){
            UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败,若银行已扣款第二天会做退款处理。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertViw.tag = 1;
            [alertViw show];
            [alertViw release];
        }
        //交易状态为I,等待继续查询
        else if (NotNilAndEqualsTo(body, TRANS_STATE, @"I")){
            if (reqCount >= 3) {
                UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败,若银行已扣款第二天会做退款处理。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertViw.tag = 1;
                [alertViw show];
                [alertViw release];
            }else{
                [[PosMini sharedInstance] showUIPromptMessage:@"查询中..." animated:YES];
                /*Mod_S 启明 费凯峰 功能点:我的业务*/
                if ([[[PosMiniDevice sharedInstance] differentBusiness] isEqualToString:NORMAL_BUSINESS]) {
                    [self performSelector:@selector(requestForQueryTrans) withObject:nil afterDelay:20];
                }else{
                    [self performSelector:@selector(requestForPersonalQueryTrans) withObject:nil afterDelay:20];
                }
                /*Mod_S 启明 费凯峰 功能点:我的业务*/
                ++reqCount;
            }
        }
        //交易失败
        else if (NotNilAndEqualsTo(body, TRANS_STATE, @"F")){
            UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertViw.tag = 2;
            [alertViw show];
            [alertViw release];
        }
    }else{
        UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败,若银行已扣款第二天会做退款处理。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertViw.tag = 1;
        [alertViw show];
        [alertViw release];
        return;
    }
    
    
    
}

-(void)requestForQueryTrans{
    /*Mod_S 启明 费凯峰 功能点:修改前版本BUG*/
     //NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/doPay"];
     NSString* url = [NSString stringWithFormat:@"/mtp/action/query/queryPayOrder"];
    /*Mod_S 启明 费凯峰 功能点:修改前版本BUG*/
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    /*Mod_S 启明 张翔 功能点:修改前版本BUG*/
//    [dict setValue:[Helper getValueByKey:@"CustId"] forKey:@"CustId"];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    /*Mod_E 启明 张翔 功能点:修改前版本BUG*/
    [dict setValue:[PosMiniDevice sharedInstance].orderId forKey:@"OrdId"];
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(payRequestDidFinished:)];
    [posReq execute];
}


- (void) requestTimeOut:(ASIHTTPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (reqCount >= 3) {
        UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易失败,若银行已扣款第二天会做退款处理。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertViw.tag = 1;
        [alertViw show];
        [alertViw release];
    }else{
        [[PosMini sharedInstance] showUIPromptMessage:@"查询中..." animated:YES];
        /*Mod_S 启明 费凯峰 功能点:我的业务*/
        if ([[[PosMiniDevice sharedInstance] differentBusiness] isEqualToString:NORMAL_BUSINESS]) {
//            [self performSelector:@selector(requestForQueryTrans) withObject:nil afterDelay:20];
            [self performSelector:@selector(requestForQueryTrans) withObject:nil];
        }else{
//            [self performSelector:@selector(requestForConveniencePayTrans) withObject:nil afterDelay:20];
            [self performSelector:@selector(requestForConveniencePayTrans) withObject:nil];
        }
        /*Mod_E 启明 费凯峰 功能点:我的业务*/
        ++reqCount;
    }
}

//处理服务器返回的信息
//当返回状态码在客户端未定义,而返回的应答信息不为空
- (void) processMTPRespDesc:(PosMiniCPRequest *)req{
    UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:req.respDesc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertViw.tag = 2;
    [alertViw show];
    [alertViw release];
}

/* Add_S 启明 费凯峰 功能点:我的业务*/
-(void)requestForConveniencePayTrans{
    [[PosMini sharedInstance] showUIPromptMessage:@"交易中..." animated:YES];
    
    LocationService *loc = [LocationService sharedInstance];
    
    NSMutableString *latitude = [NSMutableString stringWithFormat:@""];
    NSMutableString *longitude = [NSMutableString stringWithFormat:@""];
    
    if ([loc isCoordinationEmpty] == NO) {
        
        [latitude appendFormat:@"%f", loc.coordination.latitude];
        [longitude appendFormat:@"%f", loc.coordination.longitude];
        
        if (latitude.length>12) {
            latitude=[NSString stringWithFormat:@"%@",[latitude substringToIndex:12]];
        }
        if (longitude.length>12) {
            longitude=[NSString stringWithFormat:@"%@",[longitude substringToIndex:12]];
        }
    }
    
    PosMiniDevice *pos = [PosMiniDevice sharedInstance];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/doPersonalPay"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:PARAM_CUSTOMER_ID];
    [dict setValue:[[PosMiniDevice sharedInstance] businessType] forKey:@"TransType"];
    [dict setValue:[[PosMiniDevice sharedInstance] providerOrdId]  forKey:@"ProviderOrdId"];
    [dict setValue:pos.deviceSN forKey:@"MtId"];
    [dict setValue:pos.orderId forKey:@"OrdId"];
    [dict setValue:pos.paySum forKey:@"OrdAmt"];
    [dict setValue:pos.bankCardAndPassData forKey:@"InfoField"];
    [dict setValue:longitude forKey:@"Longitude"];
    [dict setValue:latitude forKey:@"Latitude"];
    [dict setValue:[Helper base64forData:[NSData dataWithData:UIImagePNGRepresentation([PosMiniDevice sharedInstance].signImg)]] forKey:@"ESignature"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",
                                   pos.md5Key,
                                   [Helper getValueByKey:POSMINI_CUSTOMER_ID],
                                   pos.deviceSN,
                                   pos.orderId,
                                   pos.paySum,
                                   [[PosMiniDevice sharedInstance] businessType],
                                   [[PosMiniDevice sharedInstance] providerOrdId],
                                   pos.bankCardAndPassData,
                                   longitude,
                                   latitude]] forKey:@"ChkValue"];
    
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(payRequestDidFinished:)];
    [posReq execute];
}

-(void)requestForPersonalQueryTrans{
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/queryPersonalPayOrder"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:@"CustId"];
    [dict setValue:[PosMiniDevice sharedInstance].orderId forKey:@"OrdId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(payRequestDidFinished:)];
    [posReq execute];
}
/* Add_E 启明 费凯峰 功能点:我的业务*/

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* Mod_S 启明 费凯峰 功能点:增加电子签购单*/
    //交易成功
    if (alertView.tag==10) {
        //交易成功，下次进入系统中，强制刷新账户信息
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
        //交易成功，如果下次进入订单详细页面，并且订单查看日期选择的是当天，强制刷新
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ORDER_NEED_REFRESH];
        if ([target isKindOfClass:[PayConfirmViewController class]]) {
            ElectronicSignRequisitionsViewController *es=[[[ElectronicSignRequisitionsViewController alloc]init]autorelease];
            es.isShowTabBar=NO;
            [((PayConfirmViewController *)target).navigationController pushViewController:es animated:YES ];
        }
    }else{
       if ([target isKindOfClass:[PayConfirmViewController class]]) {
            [((PayConfirmViewController *)target).navigationController popToRootViewControllerAnimated:YES];
        }
    }
    /*
    if ([target isKindOfClass:[PayConfirmViewController class]]) {
        [((PayConfirmViewController *)target).navigationController popToRootViewControllerAnimated:YES];
    }
     */
    /* Mod_E 启明 费凯峰 功能点:增加电子签购单*/
}



@end

