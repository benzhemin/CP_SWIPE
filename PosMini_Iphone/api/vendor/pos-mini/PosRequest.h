//
//  PosRequest.h
//  Pos刷卡器
//
//  Created by newPosTech on 12-11-3.
//
//

#import <Foundation/Foundation.h>

#define DeviceStatusNotification @"DeviceStatusChange"

#define DeviceConnectStatus @"DeviceConnectStatus"
#define NoDevice @"0"            //没有设备接入（设备拔出）
#define KnowingDevice @"1"  //设备接入正在识别
#define UnknowDevice @"2"    //设备接入但不能识别为刷卡器
#define KnowedDevice @"3"    //刷卡器已识别
#define DeviceNeedUpdate @"4"    //刷卡器已识别，但需要升级

#pragma mark ================================================
#pragma mark ConnectStatus(刷卡器状态)

typedef enum {
    NO_DEVICE = 0,          //没有设备接入（设备拔出）
    KNOWING_DEVICE,         //设备接入正在识别
    UNKNOW_DEVICE,          //设备接入但不能识别为刷卡器
    KNOWED_DEVICE,           //刷卡器已识别
    DEVICE_NEED_UPDATE      //刷卡器已识别，但需要升级
}ConnectStatus;

#pragma mark ================================================
#pragma mark StatusCode

typedef enum {
    SUCCESS = 0,    //成功
    FAIED,          //失败
    TIMEOUT,        //超时
    OVER_MAX,        //超上限
    BELOW_MIN,       //超下限
    SECRET_KEY_LOSE,  //密钥丢失
    UNDO,             //取消
    ACK,              //ACK
    ILLEGAL,          //非法请求
    WAIT,             //等待，用户未刷卡或者未输完密码  （下载专用）
    FLASH_ERASURE_FAILED,   //FLASH擦除失败（下载专用）
    FLASH_ADDRESS_ERROR,    //FLASH地址错误（下载专用）
    OVER_LIMIT,         //越界，流程错误；未发起更新Kernel请求，直接更新kernel就会出现流程错误。（下载专用）
    SERIAL_NUM_ERROR,   //序列号错误（注入序列号专用）
    ERROR,              //错误
    DEVICE_UNABLED,     //设备未激活
    ERROR_OVER_LIMIT,   //错误次数过多（用于刷卡失败次数过多）
}StatusCode;

#pragma mark ================================================
#pragma mark DeviceStatus

typedef enum {
    TRADE_FINISH = 0,       //交易完成
    SHOW_AMT_SUCCESS,       //订单金额显示成功
    SHOW_AMT_FAILED,         //订单金额显示失败
    WAIT_BRUSH_CARD,        //等待刷卡
    BRUSH_CARD_SUCCESS,     //刷卡成功，等待输入密码
    BRUSH_CARD_FAILED,      //刷卡失败，需要调用“清除刷卡失败标记”接口
    BRUSH_CARD_ERROR_MORE,  //刷卡错误次数过多
    CODE_SUMIT_FINISH,      //密码输入完成
    FACTORY_KEY_LOSE,       //出厂密钥丢失
    DATA_CLEAR,             //数据清除
    USER_UNDO,              //用户取消
    DEVICE_IDLE,            //设备空闲
    ACTION_TIME_OUT         //操作超时
}DeviceStatus;

#pragma mark ================================================
#pragma mark BatteryIndicator
//电量指示
typedef enum {
    BATTERY_REGULAR = 0,    //电量正常
    BATTERY_LOW             //电量低
}BatteryIndicator;

#pragma mark ================================================
#pragma mark BrushCardFaild
//刷卡失败状态指示
typedef enum {
    BRUSH_CARD_REGULAR = 0, //刷卡无异常
    BRUSH_CARD_FAILD        //刷卡失败
}BrushCardFaild;

#pragma mark ================================================
#pragma mark KeyType
//密钥类型
typedef enum {
    FACTORY_KEY = 1,        //出厂密钥
    MAIN_KEY = 1,           //主密钥
    PIN_KEY = 2,            //PIN key
    PACKET_KEY = 3,         //数据包密钥
    TRACK_KEY = 3           //磁道密钥
}KeyType;

#pragma mark ================================================
#pragma mark KeyStatus
//标志密钥是否存在
typedef enum {
    KEY_INEXISTENCE = 0,    //密钥不存在
    KEY_EXIST               //密钥存在
}KeyStatus;


#pragma mark ================================================
#pragma mark KeyInfo

@interface KeyInfo : NSObject {
    NSString *pinKey;           //PIN 密钥密文
    KeyType pinKeyType;         //PIN 密钥类型
    int pinKeyIndex;            //存放PIN 密钥索引
    NSString *packageKey;       //package 密钥密文
    KeyType packageKeyType;     //package密钥类型
    int packageKeyIndex;        //存放package密钥索引
}

@property (nonatomic, retain) NSString *pinKey;
@property (nonatomic, assign) KeyType pinKeyType;
@property (nonatomic, assign) int pinKeyIndex;
@property (nonatomic, retain) NSString *packageKey;
@property (nonatomic, assign) KeyType packageKeyType;
@property (nonatomic, assign) int packageKeyIndex;

@end


@protocol PosRequestDelegate;
@interface PosRequest : NSObject {
    int askCommand;              //保存的请求命令
    int kernelLocation;
    NSMutableData *saveData;
    id<PosRequestDelegate> delegate;
}

@property (nonatomic, assign) id<PosRequestDelegate> delegate;

- (void)clearAllCommand;

/*
 * 功能：初始化手机音频和刷卡器设备
 */
- (void)initializeAudioAndDevice;

/**
 * 请求查询读卡器序列号
 */
- (void)reqDeviceSN;

/**
 * 请求查询读卡器状态信息
 */
- (void)reqDeviceStatus;

/*
 *功能：请求读卡器版本信息
 */
- (void)reqQueryVersion;

/*
 *功能：请求清空读卡器数据
 */
- (void)resetDevice;

/*
 *功能：请求清空刷卡失败标记，重置磁头
 */
- (void)clearBurshCardFaildNote;

/*
 *功能：请求查询订单金额
 */
- (void)queryConsumeMoney;

/*
 *功能：请求查询订单号
 */
- (void)queryOrderNumber;

/*
 *功能：请求获取卡号
 */
- (void)reqCardNumber;

/*
 *功能：请求交易结束后的磁道加密数据
 */
- (void)requestBrushCardData;

/*
 *功能：请求注入密钥
 *参数：
 *keyInfo：密钥信息
 */
- (void)injectKeysWithInfo:(KeyInfo *)keyInfo;

/*
 *功能：查询密钥
 *参数：
 *keyType:密钥类型
 *keyIndex:密钥索引
 */
- (void)requestQueryKeyWithKeyType:(int)keyType andIndex:(int)keyIndex;

/*
 *功能：获取密钥KVC
 *参数：
 *keyType:密钥类型
 *keyIndex:密钥索引
 */
- (void)reqKvcWithKeyType:(int)keyType andIndex:(int)keyIndex;

/*
 * 功能：请求刷卡
 * 参数：
 * orderId：订单号 最大20字节
 * orderAmount：订单金额 最大金额“999999.99”
 * orderInfo：订单信息 最大100字节
 * pinIndex：PIN密钥索引 1个字节
 * packageIndex：数据包密钥索引 1个字节
 */
- (void)reqSwipeCardWithID:(NSString *)orderId amount:(NSString *)orderAmount info:(NSString *)orderInfo pinIndex:(int)pinIndex packageIndex:(int)packageIndex;

/*
 *功能：设置刷卡超时时间
 *参数：
 *operateTime:设置的超时时间 0表示默认时间：120s 最大超时时间255s。
 */
- (void)setTimeOutWithTime:(int)operateTime;

/*
 * 功能：获取本地kernel文件的版本号
 * 返回：返回得到的版本信息：
    客户代码范围：0000~9999， 适用的硬件版本范围：00~11，取值只有00、01、10、11，软件版本范围：00.00.00~99.99.99，软件版本发布时间：20121010，8位时间制，比如返回:"VERSION:0001-00-00.00.00-20121010"
 * 参数：
 * path:本地kernel文件的路径
 */
- (NSString *)getLocalKernelVersionWithData:(NSData *)fileData;

/*
 *功能：请求更新kernel
 *参数：
 *filePath:升级文件所在路径
 */
- (void)requestUpgradeWithData:(NSData *)fileData;

@end

@protocol PosRequestDelegate <NSObject>

@optional

/**
 * 请求查询读卡器序列号返回
 * 参数：
 * statusCode:返回的状态
 * serialNum:返回的读卡器序列号
 */
- (void)reqDeviceSNBackStatus:(StatusCode)statusCode andSerialNum:(NSString *)serialNum;

/**
 * 请求查询读卡器状态信息返回
 * 参数：
 * deviceStatus:返回查询到的状态
 * batteryIndicator:返回的电量指示
 */
- (void)reqDeviceStatusBackStatus:(DeviceStatus)deviceStatus andBatIndicator:(BatteryIndicator)batteryIndicator;

/*
 * 功能：请求读卡器版本信息返回
 * 参数：
 * statusCode:查询版本返回的状态
 * versionInfo:返回的版本信息，以格式“客户代码-硬件版本-软件版本-软件版本发布时间”返回
 */
- (void)reqQueryVersionBackStatus:(StatusCode)statusCode andVersionInfo:(NSString *)versionInfo;

/*
 * 功能：请求清空读卡器数据返回
 * 参数：
 * statusCode:请求清空读卡器数据返回的状态
 */
- (void)resetDeviceBackStatus:(StatusCode)statusCode;

/*
 *功能：请求清空刷卡失败标记，重置磁头返回
 * 参数：
 * statusCode:请求清空刷卡失败标记，重置磁头返回的状态
 */
- (void)clearBurshCardFaildNoteBackStatus:(StatusCode)statusCode;

/*
 *功能：请求查询订单金额返回
 * 参数：
 * statusCode:请求查询订单金额返回的状态
 * cunsumeMoney:返回的订单金额
 */
- (void)queryConsumeMoneyBackStatus:(StatusCode)statusCode money:(NSString *)cunsumeMoney;

/*
 *功能：请求查询订单号返回
 * 参数：
 * statusCode:请求查询订单号返回的状态
 * orderNum:返回的订单号
 */
- (void)queryOrderNumberBackStatus:(StatusCode)statusCode order:(NSString *)orderNum;

/*
 *功能：请求获取卡号返回
 * 参数：
 * statusCode:请求获取卡号返回的状态
 * cardNum:返回的卡号
 */
- (void)reqCardNumberBackStatus:(StatusCode)statusCode card:(NSString *)cardNum;

/*
 *功能：请求交易结束后的磁道加密数据返回
 * 参数：
 * statusCode:请求交易结束后的磁道加密数据返回的状态
 * encryptString:返回的加密数据
 “订单信息号|卡号|二磁道|三磁道|PIN码密文”，用传输密钥进行加密后输出。分割符为“|”。
 PIN密文为8字节；直接PIN DES加密，PIN不够八字节，补0x20。
 数据不足8字节，补零0x20
 */
- (void)requestBrushCardDataBackStatus:(StatusCode)statusCode encrypt:(NSString *)encryptString;

/*
 *功能：请求注入密钥返回
 * 参数：
 * statusCode:请求注入密钥返回的整体状态
 * status_A:密钥A注入状态
 * status_B:密钥B注入状态
 */
- (void)injectKeysBackStatus:(StatusCode)statusCode keyAStatus:(StatusCode)pinStatus keyBStatus:(StatusCode)packageStatus;

/*
 * 功能：查询密钥返回
 * 参数：
 * statusCode:查询密钥返回的状态
 * keytype:返回的密钥类型
 * keyIndex:返回的密钥索引
 * keyStatus:返回的密钥状态
 */
- (void)requestQueryKeyBackStatus:(StatusCode)statusCode type:(KeyType)keytype index:(int)keyIndex andKeyStatus:(KeyStatus)keyStatus;

/*
 * 功能：获取密钥KVC返回
 * 参数：
 * statusCode:查询密钥返回的状态
 * keytype:返回的密钥类型
 * keyIndex:返回的密钥索引
 * kvcString:返回的kvc数据
 */
- (void)reqKvcBackStatus:(StatusCode)statusCode type:(KeyType)keytype index:(int)keyIndex andKvc:(NSString *)kvcString;

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
- (void)reqSwipeCardBackActionS:(StatusCode)aStatus deviceS:(StatusCode)dStatus showAmtS:(StatusCode)sStatus reqBCS:(StatusCode)rStatus pinS:(StatusCode)pStatus packageS:(StatusCode)pacStatus orderInfoS:(StatusCode)oStatus;

/*
 * 功能：设置刷卡超时时间返回
 * 参数：
 * statusCode:设置刷卡超时时间返回的状态
 */
- (void)setTimeOutBackStatus:(StatusCode)statusCode;

/*
 * 功能：请求更新kernel返回
 * 参数：
 * statusCode:返回请求更新kernel的状态
 * showProgress:返回的升级百分比
 */
- (void)requestUpgradeBackStatus:(StatusCode)statusCode andProgress:(float)showProgress;

@end