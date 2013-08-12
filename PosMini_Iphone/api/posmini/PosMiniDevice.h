//
//  PosMiniDevice.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PosRequest.h"
#import "Helper.h"
#import "BaseViewController.h"
#import "PosMiniService.h"

typedef enum _AlertViewType{
    AlertView_Clear_BurshCard_Faild = 1,
    
}AlertViewType;

@interface PosMiniDevice : NSObject <PosRequestDelegate, UIAlertViewDelegate>{
    PosRequest *posReq;
    BaseViewController *baseCTRL;
    
    PosMiniService *posService;
    
    NSString *deviceSN;
    
    NSString *orderId;
    NSString *paySum;
    NSString *md5Key;
    
    NSString *bankCardAndPassData;
    
    //用户签名
    NSMutableArray *pointsList;
    
    KeyInfo *keyInfo;
    
    //POS mini设备 是否合法
    BOOL isDeviceLegal;
}

@property (nonatomic, readonly) PosRequest *posReq;
@property (nonatomic, retain) BaseViewController *baseCTRL;

@property (nonatomic, copy) NSString *deviceSN;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *paySum;
@property (nonatomic, copy) NSString *md5Key;

@property (nonatomic, copy) NSString *bankCardAndPassData;

@property (nonatomic, retain) NSMutableArray *pointsList;

@property (nonatomic, retain) KeyInfo *keyInfo;

@property (nonatomic, assign) BOOL isDeviceLegal;

+(PosMiniDevice *)sharedInstance;
+(void)destroySharedInstance;

+(void)initializePosMiniDevice;

-(void)injectKeysWithInfo;

@end
