//
//  DefaultOrderViewController.h
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderService.h"

typedef enum _OrderInfoSeq{
    OrderAccountDate = 0,
    OrderPosId,
    OrderAmount,
    OrderId,
    OrderStatus,
    OrderPayCard,
    OrderSysSeqId,
    OrderSysTimer
} OrderInfoSeq;

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
    //所有记录条数
    int totalOrderCount;
    
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

@property (nonatomic, retain) NSMutableArray *orderList;

@property (nonatomic, retain) NSDate *curDate;
@property (nonatomic, retain) NSDate *mtpCurDate;

@property (nonatomic, retain) OrderService *orderService;


-(void) setNextBtnEnable:(NSDate *)date;
/**
 响应UISegmentedControl点击
 @param sender 系统参数
 */
-(void)DatePickerDoneClick:(id)sender;

/**
 通过日期查询当天订单
 @param date 日期
 */
-(void) searchByDate:(NSDate *)date;

@end
