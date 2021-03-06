//
//  DefaultOrderViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderService.h"
/*Mod_S 启明 费凯峰 功能点:订单查询，便民付款不能退款*/
typedef enum {
    OrderAccountDate = 0,
    OrderPosId,
    OrderAmount,
    OrderId,
    OrderStatus,
    OrderPayCard,
    OrderSysSeqId,
    OrderSysTimer,
    OrderBusiType,
    OrderTransType,
} OrderInfoSeq;
/*Mod_S 启明 费凯峰 功能点:订单查询，便民付款不能退款*/
typedef enum {
    PreDay = 1,
    CurDay,
    NextDay
} BtnType;

@interface DefaultOrderViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIImageView *topNaviBg;
    UIButton *preDayBtn;//上一天
    UIButton *nextDayBtn;//后一天
    UIButton *curDateBtn;//显示时间
    
    UITableView *orderTable;//显示订单信息Table
    
    UIDatePicker *pickerView;//时间选择器
    UIActionSheet *actionSheet;
    
    //交易记录数据
    NSMutableArray *orderList;
    
    //显示订单日期时间
    NSDate *curDate;
    //MTP服务器返回当前时间
    NSDate *mtpCurDate;
    
    
    //当前页
    int pageIndex;
    
    //是否显示更多
    Boolean isShowMore;
    
    //进度条
    UIActivityIndicatorView *activityView;
    //显示更多Label
    UILabel *moreLabel;
    
    //选中行
    int selectedIndex;
    
    OrderService *orderService;
}

@property (nonatomic, retain) UIImageView *topNaviBg;
@property (nonatomic, retain) UIButton *preDayBtn;
@property (nonatomic, retain) UIButton *nextDayBtn;
@property (nonatomic, retain) UIButton *curDateBtn;
@property (nonatomic, retain) UITableView *orderTable;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *pickerView;

@property (nonatomic, retain) NSMutableArray *orderList;

@property (nonatomic, retain) NSDate *curDate;
@property (nonatomic, retain) NSDate *mtpCurDate;

@property (nonatomic, retain) OrderService *orderService;


/**
 响应UISegmentedControl点击
 @param sender 系统参数
 */
-(void)datePickerDoneClick:(id)sender;

/**
 通过日期查询当天订单
 @param date 日期
 */
-(void) requestOrderRecordByDate:(NSString *)dateStr;

@end
