//
//  TradeLimitService.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@class BaseViewController, AlertDelegateClass;

@interface PosMiniService : BasicService <UIAlertViewDelegate>{
    AlertDelegateClass *ad;
}


-(void)requestForPosBindStatus:(NSString *)deviceSN;

-(void)requestForPosBindAction:(NSString *)deviceSN;

//签到接口,获取工作密钥
-(void)requestForPosTradeSignIn:(NSString *)deviceSN;

-(void)requestForTradeLimit;


@end
