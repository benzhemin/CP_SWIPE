//
//  DefaultOrderViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultOrderViewController.h"
#import "OrderCell.h"

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
-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day;

/**
 根据事件，设置上一天和下一天按钮是否可用
 @param _nowDate 当前选择时间
 */
-(void) setButtonEnable:(NSDate *)_nowDate;
@end

@implementation DefaultOrderViewController

@synthesize topNaviBg, preDayBtn, nextDayBtn, curDateBtn;
@synthesize orderTable;
@synthesize orderList;
@synthesize orderService;
@synthesize curDate, mtpCurDate;

-(void)dealloc{
    [topNaviBg release];
    
    [preDayBtn release];
    [nextDayBtn release];
    [curDateBtn release];
    
    [orderTable release];
    
    [orderList release];

    [orderService release];
    
    [curDate release];
    [mtpCurDate release];
    
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
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
    preDayBtn.tag = 1;
    [preDayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    preDayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topNaviBg addSubview:preDayBtn];
    
    //显示时间
    self.curDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [curDateBtn setTitle:@"2012年8月21日" forState:UIControlStateNormal];
    curDateBtn.frame = CGRectMake(100, 5, 120, 20);
    [curDateBtn setExclusiveTouch:YES];
    curDateBtn.tag = 2;
    [curDateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    curDateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topNaviBg addSubview:curDateBtn];
    
    //后一天
    self.nextDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextDayBtn setTitle:@"后一天 >" forState:UIControlStateNormal];
    [nextDayBtn setExclusiveTouch:YES];
    nextDayBtn.frame = CGRectMake(238, 5, 80, 20);
    nextDayBtn.tag = 3;
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
    
    //设置上一天，下一天按钮是否可用(如果当前日期跟系统日期不一样)
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    if ([[Helper getValueByKey:POSMINI_ORDER_NEED_REFRESH] isEqualToString:NSSTRING_YES]) {
        pageIndex = 1;
        [orderList removeAllObjects];
        
        NSMutableDictionary *param = [[[NSMutableDictionary alloc] init] autorelease];
        [param setObject:@"S" forKey:PARAM_ORDER_TRANS_STATUS];
        [param setObject:@"" forKey:PARAM_ORDER_BEGIN_DATE];
        [param setObject:@"" forKey:PARAM_ORDER_END_DATE];
        [param setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:PARAM_ORDER_PAGE_NUMBER];
        [orderService requestForOrderRecord:param];
    }
}

-(void)orderRecordDidFinished:(NSDictionary *)body{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    self.mtpCurDate = [formatter dateFromString:[body valueForKey:@"CurrentDate"]];
    if (curDate == nil) {
        self.curDate = [[mtpCurDate copy] autorelease];
        [self setCurrentDate:curDate];
    }
    
    totalOrderCount = [[body objectForKey:@"TotalNum"] intValue];
    for (NSDictionary *dict in [body objectForKey:@"OrdersInfo"]) {
        NSArray *orderInfo = [NSArray arrayWithObjects:
                              [dict valueForKey:@"AcctDate"],
                              [dict valueForKey:@"MtId"],
                              [dict valueForKey:@"OrdAmt"],
                              [dict valueForKey:@"OrdId"],
                              [dict valueForKey:@"OrdStat"],
                              [dict valueForKey:@"PayCard"],
                              [dict valueForKey:@"SysSeqId"],
                              [dict valueForKey:@"SysTime"], nil];
        [orderList addObject:orderInfo];
    }
    //刷新数据
    [orderTable reloadData];
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (orderList.count==0) {
        return 1;
    } else
    {
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
                cell = [[[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSArray *orderInfo = [orderList objectAtIndex:indexPath.row];
            if ([[orderInfo objectAtIndex:OrderStatus] isEqualToString:@"R"]||[mtpCurDate compare:curDate]!=NSOrderedSame)
            {
                [cell setShowArrow:NO];
            }
            //已成功或未结算都可以退款
            else
            {
                [cell setShowArrow:YES];
            }
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
        if (isShowMore&&indexPath.row==orderList.count) {
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
            //通过时间，查询指定日期的订单
            //[self searchByDate:nowDate];
            return;
        }
        
        NSArray *orderInfo = [orderList objectAtIndex:indexPath.row];
        if (!([[orderInfo objectAtIndex:4] isEqualToString:@"R"]||[systemDate compare:nowDate]!=NSOrderedSame))
        {
            selectedIndex = indexPath.row;
            
            //退款前，先判断账户是否已经绑定设备
            if ([[Helper getValueByKey:@"deviceId"] isEqualToString:@"#"]) {
                [self showMessage:@"未绑定设备，请先绑定设备!"];
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


-(void) setNextBtnEnable:(NSDate *)date{
    if (mtpCurDate!=nil && [mtpCurDate compare:curDate]==NSOrderedDescending) {
        nextDayBtn.hidden = NO;
    }else{
        nextDayBtn.hidden = YES;
    }
}

@end



















