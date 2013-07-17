//
//  OrderService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "OrderService.h"

@implementation OrderService

-(void)requestForOrderRecord:(NSDictionary *)param{
    [[PosMini sharedInstance] showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/mtp/action/query/mini/queryPayOrders"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Helper getValueByKey:POSMINI_CUSTOMER_ID] forKey:PARAM_CUSTOMER_ID];
    [dict setValue:[param objectForKey:PARAM_ORDER_TRANS_STATUS] forKey:PARAM_ORDER_TRANS_STATUS];
    [dict setValue:[param objectForKey:PARAM_ORDER_BEGIN_DATE] forKey:PARAM_ORDER_BEGIN_DATE];
    [dict setValue:[param objectForKey:PARAM_ORDER_END_DATE] forKey:PARAM_ORDER_END_DATE];
    [dict setValue:[param objectForKey:PARAM_ORDER_PAGE_NUMBER] forKey:PARAM_ORDER_PAGE_NUMBER];
    [dict setValue:PARAM_ORDER_PAGE_SIZE_VALUE forKey:PARAM_ORDER_PAGE_SIZE];
    
    PosMiniCPRequest *posReq = [PosMiniCPRequest postRequestWithPath:url andBody:dict];
    [posReq onRespondTarget:self selector:@selector(orderRequestDidFinished:)];
    [posReq execute];
}

-(void)orderRequestDidFinished:(PosMiniCPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    //系统下次进来，不需要在进行强制刷新
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_ORDER_NEED_REFRESH];
    
    if ([target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:body];
    }
}

@end
