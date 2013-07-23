//
//  PosMiniDevice.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMiniDevice.h"
#import "NSNotificationCenter+CP.h"

#import "DefaultReceiptViewController.h"
#import "DefaultAccountViewController.h"
#import "DefaultHelpViewController.h"
#import "DefaultOrderViewController.h"

static PosMiniDevice *sInstance = nil;

@implementation PosMiniDevice

@synthesize posReq, baseCTRL;
@synthesize deviceSN;
@synthesize orderId, md5Key;
@synthesize keyInfo;
@synthesize isDeviceLegal;

+(PosMiniDevice *)sharedInstance
{
    if (sInstance == nil)
    {
        sInstance = [[PosMiniDevice alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance
{
    CPSafeRelease(sInstance);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:sInstance];
    [posReq release];
    [baseCTRL release];
    
    [deviceSN release];
    
    [orderId release];
    [md5Key release];
    
    [keyInfo release];
    
    [posService release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        baseCTRL = nil;
        
        //默认不是合法设备
        isDeviceLegal = NO;
        
        posReq = [[PosRequest alloc] init];
        posReq.delegate = self;
        [posReq initializeAudioAndDevice];
        
        posService = [[PosMiniService alloc] init];
    }
    return self;
}

+(void)initializePosMiniDevice
{
    PosMiniDevice *instance = [PosMiniDevice sharedInstance];
    
    
    
    //注册事件，监听刷卡器状态改变
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(deviceStatusChange:)
                                                 name:DeviceStatusNotification
                                               object:nil];
    
    
}

-(void)deviceStatusChange:(NSNotification *)notification{
    
    
    //POS mini默认连接状态为未连接
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_CONNECTION_STATUS];
    
    switch ([[[notification userInfo] objectForKey:DeviceConnectStatus] intValue])
    {
        case NO_DEVICE:   //没有设备接入(设备拔出)

            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备拔出"];
            break;
            
        case KNOWING_DEVICE:  //设备接入正在识别
            
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备正在识别"];
            break;
        
        case UNKNOW_DEVICE:  //设备接入但不能识别为刷卡器
            
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备已经插入，但是不能识别为刷卡器"];
     
            break;
            
        case KNOWED_DEVICE:  //刷卡器已识别
            [Helper saveValue:NSSTRING_YES forKey:POSMINI_CONNECTION_STATUS];
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备正常"];
            [posReq reqDeviceSN];
            break;
        
        case DEVICE_NEED_UPDATE:  //刷卡器已识别,但需要升级
            
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备已识别，但需要升级"];
            break;
        default:
            
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设备异常"];
            break;
    }
}

/**
 * 请求查询读卡器序列号返回
 * 参数：
 * statusCode:返回的状态
 * serialNum:返回的读卡器序列号
 */
- (void)reqDeviceSNBackStatus:(StatusCode)statusCode andSerialNum:(NSString *)serialNum
{
    if (statusCode == SUCCESS) {
        self.deviceSN = serialNum;
        
        if ([[Helper getValueByKey:POSMINI_DEVICE_ID] isEqualToString:POSMINI_DEFAULT_VALUE]) {
            if ([baseCTRL isKindOfClass:[DefaultReceiptViewController class]]) {
                //当前用户未绑定刷卡器,查询用户和刷卡器状态
                [posService requestForPosBindStatus:serialNum];
            }
        }
        else {
            //插入的刷卡器和用户绑定的刷卡器一致
            if ([[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID] isEqualToString:serialNum]) {
                isDeviceLegal = YES;
                
                //对四个tab页面做交易限额查询
                if ([[baseCTRL controllerName] rangeOfString:@"Default"].location != NSNotFound) {
                    [posService requestForTradeLimit];
                }
            }else{
                isDeviceLegal = NO;
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"不是合法设备"];
            }
        }
    }else{
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"查询刷卡器序列号失败!"];
    }
}

/*
 * 功能：请求清空读卡器数据返回
 * 参数：
 * statusCode:请求清空读卡器数据返回的状态
 */
- (void)resetDeviceBackStatus:(StatusCode)statusCode{
    
    if (statusCode == SUCCESS) {
        //请求签到数据,成功后灌入密钥
        if ([baseCTRL isKindOfClass:[DefaultReceiptViewController class]]) {
            [posService requestForPosTradeSignIn:deviceSN];
        }
        
    }else{
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"重置刷卡器失败!"];
    }
}


/*
 *功能：请求注入密钥
 *参数：
 *keyInfo：密钥信息
 */
-(void)injectKeysWithInfo{
    [[PosMini sharedInstance] showUIPromptMessage:@"密钥注入中" animated:YES];
    [posReq injectKeysWithInfo:keyInfo];
}


/*
 *功能：请求注入密钥返回
 * 参数：
 * statusCode:请求注入密钥返回的整体状态
 * status_A:密钥A注入状态
 * status_B:密钥B注入状态
 */
- (void)injectKeysBackStatus:(StatusCode)statusCode keyAStatus:(StatusCode)pinStatus keyBStatus:(StatusCode)packageStatus
{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    if (statusCode==SUCCESS) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"注入成功"];
        //注入成功,跳转到确认订单页面
        if ([baseCTRL isKindOfClass:[DefaultReceiptViewController class]]) {
            
        }
        
    }
    else if(statusCode == TIMEOUT)
    {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"超时,请插拔刷卡器重试!"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"灌注密钥失败!"];
    }
}







@end
