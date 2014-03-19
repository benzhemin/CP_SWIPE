//
//  RefoundViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-14.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ReceiptBgView.h"
#import "PosMiniService.h"

@interface RefundViewController : BaseViewController{
    ReceiptBgView *recpBgView;
    
    //订单编号
    NSString *orderId;
    //交易总额
    NSString *paySum;
    //交易时间
    NSString *tradeTime;
    
    UIButton *confirmBtn;
    
    PosMiniService *posService;
}

@property (nonatomic, retain) ReceiptBgView *recpBgView;

@property (nonatomic, retain) UIButton *confirmBtn;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *paySum;
@property (nonatomic, copy) NSString *tradeTime;


-(void)confirmRefund:(id)sender;

@end
