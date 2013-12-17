//
//  PayService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

typedef enum{
    REQ_PAY = 1,
    REQ_QUERY,
} REQ_PAY_TYPE;

@interface PayService : BasicService <UIAlertViewDelegate>{
    int reqCount;
}

//请求支付接口
-(void)requestForPayTrans;

//请求查询支付状态接口
-(void)requestForQueryTrans;
/*Add_S 启明 费凯峰 功能点:我的业务*/
-(void)requestForConveniencePayTrans;
/*Add_E 启明 费凯峰 功能点:我的业务*/
@end
