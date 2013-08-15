//
//  RefundService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "RefundService.h"
#import "PosMiniDevice.h"
#import "SwipeCardViewController.h"

@implementation RefundService

-(id)init{
    self = [super init];
    if (self) {
        reqCount = 0;
    }
    return self;
}

-(void)requestForRefundTrans{
    [[PosMini sharedInstance] showUIPromptMessage:@"退款中..." animated:YES];
    
    PosMiniDevice *pos = [PosMiniDevice sharedInstance];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/trade/doCancel"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:PARAM_CUSTOMER_ID];
    [dict setValue:pos.deviceSN forKey:@"MtId"];
    [dict setValue:pos.orderId forKey:@"OrdId"];
    [dict setValue:pos.refundOrderId forKey:@"PayOrdId"];
    [dict setValue:pos.bankCardAndPassData forKey:@"InfoField"];
    [dict setValue:[Helper md5_16:[NSString stringWithFormat:@"%@%@%@%@%@%@",
                                                 pos.md5Key,
                                                 [Helper getValueByKey:POSMINI_CUSTOMER_ID],
                                                 pos.deviceSN,
                                                 pos.orderId,
                                                 pos.refundOrderId,
                                                 pos.bankCardAndPassData
                                                 ]] forKey:@"ChkValue"];
    NSLog(@"%@", dict);

    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(refundRequestDidFinished:)];
    [posReq execute];
}

-(void)refundRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    //返回状态码为000代表退款成功
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退款成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = 1;//区分退款
    [alertView show];
    [alertView release];
}

-(void)queryForRefundState{
    PosMiniDevice *pos = [PosMiniDevice sharedInstance];
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/queryRefundOrder"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:PARAM_CUSTOMER_ID];
    [dict setValue:pos.orderId forKey:@"RefOrdId"];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(refundRequestDidFinished:)];
    [posReq execute];
}

//处理退款失败显示弹窗
//退款失败没有对应的状态码,当服务端返回状态码不为000作退款失败处理
- (void) processMTPRespDesc:(NSString *)msg{
    //退款失败
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退款失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) requestTimeOut:(ASIHTTPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (reqCount >= 3) {
        UIAlertView *alertViw = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常请稍后再查或拨打客服电话人工查询!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertViw.tag = 1;
        [alertViw show];
        [alertViw release];
    }else{
        [[PosMini sharedInstance] showUIPromptMessage:@"查询中..." animated:YES];
        [self queryForRefundState];
        ++reqCount;
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        //退款成功强制刷新账户信息
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ACCOUNT_NEED_REFRESH];
        //退款成功订单查看日期选择的是当天，强制刷新
        [Helper saveValue:NSSTRING_YES forKey:POSMINI_ORDER_NEED_REFRESH];
    }
    
    //计时器失效
    if (target && [target isKindOfClass:SwipeCardViewController.class]) {
        [(SwipeCardViewController *)target invalidateTimer];
    }
    
    //返回输入收款页面
    if ([target isKindOfClass:[SwipeCardViewController class]]) {
        [((SwipeCardViewController *)target).navigationController popToRootViewControllerAnimated:YES];
    }
}

@end











