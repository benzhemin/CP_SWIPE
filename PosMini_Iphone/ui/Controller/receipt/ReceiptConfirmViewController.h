//
//  ReceiptConfirmViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ReceiptBgView.h"

@interface ReceiptConfirmViewController : BaseViewController{
    //白色背景
    ReceiptBgView *recpBgView;
    
    UIButton *confirmBtn;
}

@property (nonatomic, retain) ReceiptBgView *recpBgView;
@property (nonatomic, retain) UIButton *confirmBtn;

-(void)pay:(id)sender;

@end
