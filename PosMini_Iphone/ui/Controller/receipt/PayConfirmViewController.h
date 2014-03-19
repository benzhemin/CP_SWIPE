//
//  PayConfirmViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-8-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "ReceiptBgView.h"

@class PayService;

@interface PayConfirmViewController : BaseViewController{
    ReceiptBgView *recpBgView;
    PayService *ps;
}

@property (nonatomic, retain) ReceiptBgView *recpBgView;
@property (nonatomic, retain) PayService *ps;

@end
