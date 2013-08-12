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

#import "ReceiptConfirmViewController.h"
#import "SwipeCardViewController.h"
#import "SignLandscapeViewController.h"



static PosMiniDevice *sInstance = nil;

@implementation PosMiniDevice

@synthesize posReq, baseCTRL;
@synthesize deviceSN;
@synthesize orderId, paySum, md5Key;
@synthesize bankCardAndPassData;
@synthesize keyInfo;
@synthesize isDeviceLegal;

@synthesize pointsList;

//重写self.pointsList = points 方法
-(void)setPointsList:(NSMutableArray *)points{
    [self.pointsList removeAllObjects];
    //deep copy
    for (NSValue *val in points) {
        [pointsList addObject:[NSValue valueWithCGPoint:[val CGPointValue]]];
    }
}

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
    [paySum release];
    [md5Key release];
    
    [bankCardAndPassData release];
    
    [pointsList release];
    
    [keyInfo release];
    
    [posService release];
    
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        baseCTRL = nil;
        
        //默认不是合法设备
        isDeviceLegal = NO;
        pointsList = [[NSMutableArray alloc] init];
        
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

-(void)deviceStatusChange:(NSNotification *)notification
{
    //POS mini默认连接状态为未连接
    [Helper saveValue:NSSTRING_NO forKey:POSMINI_CONNECTION_STATUS];
    
    //当POS mini设备状态变化,设备合法状态一定是NO
    isDeviceLegal = NO;
    
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
        
        //当前用户未绑定刷卡器,查询用户和刷卡器状态
        if ([[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID] isEqualToString:POSMINI_DEFAULT_VALUE]) {
            if ([baseCTRL isKindOfClass:[DefaultReceiptViewController class]]) {
                [posService requestForPosBindStatus:serialNum];
            }
        }
        else {
            //插入的刷卡器和用户绑定的刷卡器一致
            if ([[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID] isEqualToString:serialNum]) {
                isDeviceLegal = YES;
                
                //对四个tab页面做交易限额查询
                //DefaultReceiptViewController, DefaultOrderViewController,
                //DefaultAccountViewController, DefaultHelpViewController
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
    
    //无论返回状态是成功还是失败,都置金额确认按钮enable=YES
    if ([baseCTRL isKindOfClass:DefaultReceiptViewController.class])
    {
        ((DefaultReceiptViewController *)baseCTRL).confirmBtn.enabled = YES;
    }
    
    if (statusCode == SUCCESS)
    {
        //请求签到数据,成功后灌入密钥
        if ([baseCTRL isKindOfClass:DefaultReceiptViewController.class])
        {
            [posService requestForPosTradeSignIn:deviceSN];
            return;
        }
        
        if ([baseCTRL isKindOfClass:ReceiptConfirmViewController.class]) {
            [posReq setTimeOutWithTime:READ_CARD_TIMEOUT];
        }
        
        if ([baseCTRL isKindOfClass:SwipeCardViewController.class]) {
            SwipeCardViewController *swipeCTRL = (SwipeCardViewController *)baseCTRL;
            //付款
            if (swipeCTRL.scType == PAY_SWIPE_TYPE) {
                SignLandscapeViewController *signCTRL = [[SignLandscapeViewController alloc]init];
                signCTRL.isShowTabBar = NO;
                
                [swipeCTRL.navigationController pushViewController:signCTRL animated:YES];
            }
            //退款
            if (swipeCTRL.scType == REFOUND_SWIPE_TYPE) {
                
            }
        }
    }else
    {
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"重置刷卡器失败!"];
    }
}

/*
 * 功能：设置刷卡超时时间返回
 * 参数：
 * statusCode:设置刷卡超时时间返回的状态
 */
- (void)setTimeOutBackStatus:(StatusCode)statusCode
{
    if (statusCode==SUCCESS) {
        //向刷卡器写入订单信息，请求刷卡
        [posReq reqSwipeCardWithID:self.orderId amount:[NSString stringWithFormat:@"%0.2f",[self.paySum floatValue]] info:[NSString stringWithFormat:@"%@|%@|%@",[Helper getValueByKey:@"CustId"],self.orderId,[NSString stringWithFormat:@"%0.2f",[self.paySum floatValue]]] pinIndex:2 packageIndex:3];
    }
    else{
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"设置超时失败"];
    }
}

/*
 * 功能：请求刷卡返回
 * 参数：
 * actionStatus：命令执行状态
 * deviceStatus：设备激活状态
 * showAmtStatus：显示金额状态
 * reqBCStatus：请求刷卡状态
 * pinStatus：PIN密钥索引状态
 * pacStatus：PAC密钥索引状态
 * orderInfoStatus：订单信息状态
 */
- (void)reqSwipeCardBackActionS:(StatusCode)aStatus deviceS:(StatusCode)dStatus showAmtS:(StatusCode)sStatus reqBCS:(StatusCode)rStatus pinS:(StatusCode)pStatus packageS:(StatusCode)pacStatus orderInfoS:(StatusCode)oStatus
{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    if (aStatus == SUCCESS && dStatus == SUCCESS && sStatus == SUCCESS && rStatus == SUCCESS && pStatus == SUCCESS && pacStatus == SUCCESS && oStatus == SUCCESS) {
        
        //写入订单信息成功，跳转到刷卡动画页面
        SwipeCardViewController *sc = [[SwipeCardViewController alloc] init];
        sc.isShowTabBar = NO;
        sc.scType = PAY_SWIPE_TYPE;
        [baseCTRL.navigationController pushViewController:sc animated:YES];
        [sc release];
        
        
    }else {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"写入订单信息失败，请重试!"];
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
    
    if (statusCode==SUCCESS) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"密钥注入成功"];
        //注入成功,跳转到确认订单页面
        if ([baseCTRL isKindOfClass:[DefaultReceiptViewController class]]) {
            ReceiptConfirmViewController *receiptCTRL = [[ReceiptConfirmViewController alloc] init];
            receiptCTRL.isShowTabBar = NO;
            [baseCTRL.navigationController pushViewController:receiptCTRL animated:YES];
            [receiptCTRL release];
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
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
}

/**
 * 请求查询读卡器状态信息返回
 * 参数：
 * deviceStatus:返回查询到的状态
 * batteryIndicator:返回的电量指示
 */
- (void)reqDeviceStatusBackStatus:(DeviceStatus)deviceStatus andBatIndicator:(BatteryIndicator)batteryIndicator
{
    NSLog(@"device state :%d",deviceStatus);
    
    UIAlertView *alertView;
    
    //电池电量低
    if (batteryIndicator == BATTERY_LOW) {
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"电池电量低!"];
        return;
    }
    
    if (deviceStatus == TRADE_FINISH) {
        //交易完成
        //请求刷卡器中加密的账号密码信息
        [[PosMini sharedInstance] showUIPromptMessage:@"获取卡信息中.." animated:YES];
        [self.posReq requestBrushCardData];
    }else {
        switch (deviceStatus) {
            case WAIT_BRUSH_CARD:
            {
                //查询状态
                [self.posReq reqDeviceStatus];
                break;
            }
            case BRUSH_CARD_FAILED:
            {
                //刷卡失败,提示用户
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"刷卡失败!"];
                
                //清除磁头
                [self.posReq clearBurshCardFaildNote];
                break;
            }
            case BRUSH_CARD_SUCCESS:
            {
                //刷卡成功
                [self.posReq reqDeviceStatus];
                break;
            }
            case CODE_SUMIT_FINISH:
            {
                //密码输入完成
                [self.posReq reqDeviceStatus];
                break;
            }
            case ACTION_TIME_OUT:
            {
                alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"刷卡超时!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                return;
            }
            case USER_UNDO:
                //用户取消
                alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作取消!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                return ;
            default:
                break;
        }
    }
}

/*
 *功能：请求交易结束后的磁道加密数据返回
 * 参数：
 * statusCode:请求交易结束后的磁道加密数据返回的状态
 * encryptString:返回的加密数据
 “订单信息号|卡号|二磁道|三磁道|PIN码密文”，用传输密钥进行加密后输出。分割符为“|”。
 PIN密文为8字节；直接PIN DES加密，PIN不够八字节，补0x20。
 数据不足8字节，补零0x20
 */
- (void)requestBrushCardDataBackStatus:(StatusCode)statusCode encrypt:(NSString *)encryptString
{
    //移除等待进度框
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    if (statusCode==SUCCESS) {
        NSLog(@"%@",encryptString);
        
        //计时器失效
        if ([baseCTRL isKindOfClass:SwipeCardViewController.class]) {
            [(SwipeCardViewController *)baseCTRL invalidateTimer];
        }
        
        //请求清空刷卡器里面数据
        [self.posReq resetDevice];
        //清空数组
        self.bankCardAndPassData = encryptString;
    }
    else{
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请求获取卡信息失败!"];
    }
}

/*
 *功能：请求清空刷卡失败标记，重置磁头返回
 * 参数：
 * statusCode:请求清空刷卡失败标记，重置磁头返回的状态
 */
- (void)clearBurshCardFaildNoteBackStatus:(StatusCode)statusCode
{
    if (statusCode==SUCCESS) {
        //重新查询状态
        [self.posReq reqDeviceStatus];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"清除刷卡器数据失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = AlertView_Clear_BurshCard_Faild;
        [alertView show];
        [alertView release];
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //返回输入收款页面
    if (alertView.tag == AlertView_Clear_BurshCard_Faild) {
        [baseCTRL.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


@end
