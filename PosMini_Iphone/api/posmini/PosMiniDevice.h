//
//  PosMiniDevice.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PosRequest.h"
#import "Helper.h"
#import "BaseViewController.h"
#import "PosMiniService.h"

@class RefundService;

typedef enum _AlertViewType{
    AlertView_Clear_BurshCard_Faild = 1,
    
}AlertViewType;

@interface PosMiniDevice : NSObject <PosRequestDelegate, UIAlertViewDelegate>{
    PosRequest *posReq;
    BaseViewController *baseCTRL;
    
    PosMiniService *posService;
    RefundService *rfService;
    
    NSString *deviceSN;
    
    NSString *orderId;
    NSString *refundOrderId;
    
    NSString *paySum;
    NSString *md5Key;
    
    NSString *bankCardAndPassData;
    //签名图片
    UIImage *signImg;
    
    //用户签名
    NSMutableArray *pointsList;
    
    KeyInfo *keyInfo;
    
    //POS mini设备 是否合法
    BOOL isDeviceLegal;
}

/*Add_S 启明 费凯峰 功能点:全局变量*/
/**
 *  商户简称
 */
@property(nonatomic,copy)NSString *simpeName;
/**
 *  便民业务和普通收款
 */
@property(nonatomic,copy)NSString *differentBusiness;
/**
 *  便民业务类型
 */
@property(nonatomic,copy)NSString *businessType;
/**
 *  第三方服务商订单号
 */
@property(nonatomic,copy)NSString *providerOrdId;
/**
 *  订单明细的业务类型
 */
@property(nonatomic,copy)NSString *queryPayOrderBusinessType;
/**
 *  订单明细的开始时间
 */
@property(nonatomic,copy)NSDate *queryPayOrderBeginDate;
/**
 *  订单明细的结束时间
 */
@property(nonatomic,copy)NSDate *queryPayOrderEndDate;


/**
 *  是否设置商户电话
 */
@property (nonatomic, assign) BOOL isSetedMerTel;

/*Add_S 启明 费凯峰 功能点:全局变量*/

/*Add_S 启明 张翔 功能点:增加电子签购单*/
@property (nonatomic, copy) NSString *esMerName;
@property (nonatomic, copy) NSString *esOrdId;
@property (nonatomic, copy) NSString *esCardNo;
@property (nonatomic, copy) NSString *esCurrentDate;
@property (nonatomic, copy) NSString *esCurrentTime;
@property (nonatomic, copy) NSString *esOrdAmt;
@property (nonatomic, copy) NSString *esProviderCustId;
/*Add_E 启明 张翔 功能点:增加电子签购单*/

@property (nonatomic, readonly) PosRequest *posReq;
@property (nonatomic, retain) BaseViewController *baseCTRL;

@property (nonatomic, copy) NSString *deviceSN;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *refundOrderId;

@property (nonatomic, copy) NSString *paySum;
@property (nonatomic, copy) NSString *md5Key;

@property (nonatomic, copy) NSString *bankCardAndPassData;
@property (nonatomic, retain) UIImage *signImg;

@property (nonatomic, retain) NSMutableArray *pointsList;

@property (nonatomic, retain) KeyInfo *keyInfo;

@property (nonatomic, assign) BOOL isDeviceLegal;

+(PosMiniDevice *)sharedInstance;
+(void)destroySharedInstance;

+(void)initializePosMiniDevice;

-(void)injectKeysWithInfo;

@end
