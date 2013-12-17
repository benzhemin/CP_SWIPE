//
//  DefaultOrderViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultOrderViewController.h"
#import "RefundViewController.h"
#import "OrderCell.h"

#import "SearchOrderViewController.h"

@interface DefaultOrderViewController ()
//响应UIButton事件
-(void) btnClick:(id)sender;

/**
 设置导航显示当前日期
 @param date 日期
 */
-(void) setCurrentDate:(NSDate *)date;
/**
 获取当期日期前day天日期
 @param date 当前日期
 @param day 日期偏差
 @returns 计算后的日期
 */
-(NSDate *)dateFromDate:(NSDate *)date withDay:(int)day;

/**
 根据事件，设置上一天和下一天按钮是否可用
 调用之前,一定要设置好curDate
 @param _nowDate 当前选择时间
 */
-(void) setNextBtnEnable;
@end

@implementation DefaultOrderViewController

@synthesize topNaviBg, preDayBtn, nextDayBtn, curDateBtn;
@synthesize orderTable;
@synthesize actionSheet, pickerView;

@synthesize orderList;
@synthesize orderService;
@synthesize curDate, mtpCurDate;

-(void)dealloc{
    [topNaviBg release];
    
    [preDayBtn release];
    [nextDayBtn release];
    [curDateBtn release];
    
    [orderTable release];
    
    [actionSheet release];
    [pickerView release];
    
    [orderList release];

    [orderService release];
    
    [curDate release];
    [mtpCurDate release];
    
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    /*Add_S 启明 费凯峰 功能点:增加阶段查询*/
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(230, 30, 80, 26)];
    [button setTitle:@"历史查询" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_query"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    /*Add_E 启明 费凯峰 功能点:增加阶段查询*/
    
	[self setNavigationTitle:@"订单查询"];
    
    self.orderList = [[[NSMutableArray alloc]init] autorelease];
    
    //选择时间背景色
    self.topNaviBg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 30)] autorelease];
    topNaviBg.userInteractionEnabled = YES;
    topNaviBg.image = [[UIImage imageNamed:@"snav-bg.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [contentView addSubview:topNaviBg];
    
    //前一天
    self.preDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preDayBtn setTitle:@"< 前一天" forState:UIControlStateNormal];
    preDayBtn.frame = CGRectMake(2, 5, 80, 20);
    [preDayBtn setExclusiveTouch:YES];
    preDayBtn.tag = PreDay;
    [preDayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    preDayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topNaviBg addSubview:preDayBtn];
    
    //显示时间
    self.curDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [curDateBtn setTitle:@"2012年8月21日" forState:UIControlStateNormal];
    curDateBtn.frame = CGRectMake(100, 5, 120, 20);
    [curDateBtn setExclusiveTouch:YES];
    curDateBtn.tag = CurDay;
    [curDateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    curDateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topNaviBg addSubview:curDateBtn];
    
    //后一天
    self.nextDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextDayBtn setTitle:@"后一天 >" forState:UIControlStateNormal];
    [nextDayBtn setExclusiveTouch:YES];
    nextDayBtn.frame = CGRectMake(238, 5, 80, 20);
    nextDayBtn.tag = NextDay;
    [nextDayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextDayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topNaviBg addSubview:nextDayBtn];
    nextDayBtn.hidden = YES;
    
    
    self.orderService = [[[OrderService alloc] init] autorelease];
    [orderService onRespondTarget:self selector:@selector(orderRecordDidFinished:)];
    
    //显示订单Table
    CGRect frame = CGRectMake(0, 30, contentView.frame.size.width, contentView.frame.size.height-30);
    self.orderTable = [[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain] autorelease];
    orderTable.delegate = self;
    orderTable.dataSource = self;
    [contentView addSubview:orderTable];
    
    isShowMore = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果进来时候设备已经连接，直接查询设备编号
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:@"YES"]) {
        [[PosMiniDevice sharedInstance].posReq reqDeviceSN];
    }
    
    if ([[Helper getValueByKey:POSMINI_ORDER_NEED_REFRESH] isEqualToString:NSSTRING_YES]) {
        pageIndex = 1;
        [orderList removeAllObjects];
        
        [self requestOrderRecordByDate:@""];
    }
}

-(void) requestOrderRecordByDate:(NSString *)dateStr
{
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] init] autorelease];
    [param setObject:dateStr forKey:PARAM_ORDER_BEGIN_DATE];
    [param setObject:dateStr forKey:PARAM_ORDER_END_DATE];
    [param setObject:@"S" forKey:PARAM_ORDER_TRANS_STATUS];
    [param setObject:@"" forKey:PARAM_ORDER_BUSINESS_TYPE];
    [param setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:PARAM_ORDER_PAGE_NUMBER];
    
    [orderService requestForOrderRecord:param];
}

-(void)orderRecordDidFinished:(NSDictionary *)body{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];

    self.mtpCurDate = [formatter dateFromString:[body valueForKey:@"CurrentDate"]];

    if (curDate == nil) {
        self.curDate = [[mtpCurDate copy] autorelease];
        [self setCurrentDate:curDate];
    }
    
    int totalOrderCount = [[body objectForKey:@"TotalNum"] intValue];
    id orderInfo = [body objectForKey:@"OrdersInfo"];
    /*Mod_S 启明 费凯峰 功能点:订单查询，便民付款不能退款*/
    if (orderInfo!=nil && [orderInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in [body objectForKey:@"OrdersInfo"]) {
            NSArray *orderInfo = [NSArray arrayWithObjects:
                                  [dict valueForKey:@"AcctDate"],
                                  [dict valueForKey:@"MtId"],
                                  [dict valueForKey:@"OrdAmt"],
                                  [dict valueForKey:@"OrdId"],
                                  [dict valueForKey:@"OrdStat"],
                                  [dict valueForKey:@"PayCard"],
                                  [dict valueForKey:@"SysSeqId"],
                                  [dict valueForKey:@"SysTime"],
                                  [dict valueForKey:@"BusiType"],
                                  [dict valueForKey:@"TransType"],
                                  nil];
            [orderList addObject:orderInfo];
        }
    }
    /*Mod_S 启明 费凯峰 功能点:订单查询，便民付款不能退款*/
    if (totalOrderCount > orderList.count) {
        isShowMore = YES;
    }else{
        isShowMore = NO;
    }
    
    //刷新数据
    [orderTable reloadData];
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (orderList.count==0) {
        return 1;
    } else{
        //显示更多
        if (isShowMore) {
            return orderList.count+1;
        }
        return orderList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Order_Identifier";
    static NSString *identifierNoData = @"noData";
    static NSString *identifierMore = @"more";
    if (orderList.count!=0) {
        //显示更多
        if (isShowMore && indexPath.row==orderList.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMore];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMore]autorelease];
                
                //显示更多
                moreLabel = [[UILabel alloc]init];
                moreLabel.frame = CGRectMake(0, 0, 320, 45);
                moreLabel.textAlignment = NSTextAlignmentCenter;
                moreLabel.font = [UIFont systemFontOfSize:16];
                moreLabel.tag = 1;
                [cell addSubview:moreLabel];
                [moreLabel release];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //提示数据载入框
                activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityView.center = CGPointMake(100, 22);
                [cell addSubview:activityView];
                [activityView release];
                
                [activityView stopAnimating];
            }
            UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
            tempLabel.text = @"更多";
            return cell;
        }
        else{
            OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil) {
                cell = [[[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSArray *orderInfo = [orderList objectAtIndex:indexPath.row];
            
            
            //只有退款OrderStatus状态为s且当天交易的订单可以退款
            /*
                S   成功
                R   已成功退款
                F   失败
                I   初始化
             */
            [cell setShowArrow:NO];
            /*Mod_S 启明 费凯峰 功能点:增加阶段查询*/
            if ([[orderInfo objectAtIndex:OrderStatus] isEqualToString:@"S"] && [mtpCurDate compare:curDate]==NSOrderedSame && [[orderInfo objectAtIndex:OrderBusiType] isEqualToString:@"R"])
            {
                [cell setShowArrow:YES];
            }
            
            /*Mod_S 启明 费凯峰 功能点:增加阶段查询*/
            [cell setOrderId:[orderInfo objectAtIndex:OrderId] setOrderSum:[[orderInfo objectAtIndex:OrderAmount] floatValue] setOrederState:[orderInfo objectAtIndex:OrderStatus] setTradeTime:[orderInfo objectAtIndex:OrderSysTimer] setBankNum:[orderInfo objectAtIndex:OrderPayCard]];
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNoData];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierNoData]autorelease];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"没有记录";
        return cell;
    }
    
}

#define ORDERDETAIL_CELLHEIGHT 85
//返回Cell高度
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (orderList.count==0) {
        return 45;
    }
    else{
        if (isShowMore && indexPath.row==orderList.count) {
            return 45;
        }
        return ORDERDETAIL_CELLHEIGHT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (orderList.count!=0) {
        if (isShowMore && indexPath.row==orderList.count) {
            //处理点击下一页事件
            
            moreLabel.text = @"载入中";
            [activityView startAnimating];
            
            pageIndex++;
            
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            [self requestOrderRecordByDate:[dateFormatter stringFromDate:curDate]];
            return;
        }
        
        
        NSArray *orderInfo = [orderList objectAtIndex:indexPath.row];
        if ([[orderInfo objectAtIndex:OrderStatus] isEqualToString:@"S"] &&
            [mtpCurDate compare:curDate]==NSOrderedSame &&
            [[orderInfo objectAtIndex:OrderBusiType] isEqualToString:@"R"])
        {
            selectedIndex = indexPath.row;
            
            //退款前，先判断账户是否已经绑定设备
            //绑定设备才能退款
            if ([[Helper getValueByKey:POSMINI_MTP_BINDED_DEVICE_ID] isEqualToString:@"#"]) {
                [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"未绑定设备，请先绑定设备!"];
                return;
            }
            else
            {
                //处理退款事件
                UIAlertView *noticeView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确认退款" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [noticeView show];
                [noticeView release];
                return ;
            }
        }
    }
}
#pragma mark - 历史查询
-(void)searchRecord:(id)sender{
    SearchOrderViewController *so=[[SearchOrderViewController alloc]init];
    so.mtpDate=self.mtpCurDate;
    [self.navigationController pushViewController:so animated:YES];
    [so release];
}
#pragma mark -
//响应UIButton事件
-(void) btnClick:(id)sender
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    UIButton *btn = (UIButton *)sender;
    pageIndex = 1;
    switch (btn.tag) {
        case PreDay:
            //清空订单数组
            [orderList removeAllObjects];
            //点击上一天
            self.curDate = [self dateFromDate:curDate withDay:-1];
            //更新显示日期
            [self setCurrentDate:curDate];
            //重新查询
            [self requestOrderRecordByDate:[dateFormatter stringFromDate:curDate]];
            //设置上一天，下一天按钮是否可用
            [self setNextBtnEnable];
            break;
        case CurDay:
            //点击显示时间
            self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
            
            [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            
            //Date picker
            self.pickerView = [[[UIDatePicker alloc] init] autorelease];
            pickerView.datePickerMode = UIDatePickerModeDate;
            [actionSheet addSubview:pickerView];
            [pickerView setDate:curDate];
            [pickerView setMaximumDate:mtpCurDate];
            
            CGRect pickerRect = pickerView.bounds;
            pickerRect.origin.y = -50;
            pickerView.bounds = pickerRect;
            
            //取消按钮
            UISegmentedControl *cancelBtn = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]] autorelease];
            cancelBtn.momentary = YES;
            cancelBtn.frame = CGRectMake(10.0f, 7.0f, 65.0f, 32.0f);
            cancelBtn.segmentedControlStyle = UISegmentedControlStyleBar;
            [cancelBtn addTarget:self action:@selector(datePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
            [actionSheet addSubview:cancelBtn];
            cancelBtn.tag = 1;
            
            //确定按钮
            UISegmentedControl *confirmBtn =[[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]] autorelease];
            confirmBtn.momentary = YES;
            confirmBtn.frame = CGRectMake(245, 7.0f, 65.0f, 32.0f);
            confirmBtn.segmentedControlStyle = UISegmentedControlStyleBar;
            [confirmBtn addTarget:self action:@selector(datePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
            [actionSheet addSubview:confirmBtn];
            confirmBtn.tag = 2;
            
            [actionSheet showInView:self.view];
            [actionSheet setBounds:CGRectMake(0,0, 320, 500)];
            break;
        case NextDay:
            //点击显示下一天
            self.curDate = [self dateFromDate:curDate withDay:1];
            [self setCurrentDate:curDate];
            //清空订单数组
            [orderList removeAllObjects];
            //重新查询
            [self requestOrderRecordByDate:[dateFormatter stringFromDate:curDate]];
            //设置上一天，下一天按钮是否可用
            [self setNextBtnEnable];
            break;
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //开始退款流程
        NSArray *orderInfo = [orderList objectAtIndex:selectedIndex];
        //[cell setOrderId:[orderInfo objectAtIndex:3] setOrderSum:[[orderInfo objectAtIndex:2] floatValue] setOrederState:[orderInfo objectAtIndex:4] setTradeTime:[orderInfo objectAtIndex:7] setBankNum:[orderInfo objectAtIndex:5]];
        
        //设置全局退款
        PosMiniDevice *pos = [PosMiniDevice sharedInstance];
        pos.refundOrderId = [orderInfo objectAtIndex:OrderId];
        pos.paySum = [orderInfo objectAtIndex:OrderAmount];
        
        
        RefundViewController *rf = [[RefundViewController alloc]init];
        rf.orderId = [orderInfo objectAtIndex:OrderId];
        rf.paySum = [orderInfo objectAtIndex:OrderAmount];
        rf.tradeTime = [orderInfo objectAtIndex:OrderSysTimer];
        [self.navigationController pushViewController:rf animated:YES];
        [rf release];
    }
}

#pragma mark UIActionSheetDelegate Method
/**
 响应UISegmentedControl点击
 @param sender 系统参数
 */
-(void)datePickerDoneClick:(id)sender
{
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    if (sc.tag==2) {
        
        self.curDate = pickerView.date;
        //设置上一天，下一天按钮是否可用
        [self setNextBtnEnable];
    }
    [actionSheet dismissWithClickedButtonIndex:sc.tag animated:YES];
}

#pragma mark UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    //查询指定日期
    if (buttonIndex==2) {
        [self setCurrentDate:curDate];
        
        //清空订单数组
        [orderList removeAllObjects];
        
        //重新查询指定日期订单信息
        [self requestOrderRecordByDate:[dateFormatter stringFromDate:curDate]];
    }
}

/**
 获取当期日期前day天日期
 @param date 当前日期
 @param day 日期偏差
 @returns 计算后的日期
 */
-(NSDate *)dateFromDate:(NSDate *)date withDay:(int)day
{
    //avoid memory leak
    return [[[NSDate alloc] initWithTimeInterval:24*60*60*day sinceDate:date] autorelease];
}

/**
 设置导航显示当前日期
 @param date 日期
 */
-(void) setCurrentDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    [curDateBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}


-(void) setNextBtnEnable{
    if (mtpCurDate!=nil && [mtpCurDate compare:curDate]==NSOrderedDescending) {
        nextDayBtn.hidden = NO;
    }else{
        nextDayBtn.hidden = YES;
    }
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00006";
}

@end
