//
//  OrderListViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCell.h"
#import "RefundViewController.h"


@interface OrderListViewController ()
{
    //当前页
    int pageIndex;
    //选中行
    int selectedIndex;
    //显示更多Label
    UILabel *moreLabel;
    //活动指示器
    UIActivityIndicatorView *activityView;
}
@end

@implementation OrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavigationTitle:@"交易明细"];
    
    self.orderList = [[[NSMutableArray alloc]init] autorelease];
    //选择时间背景色
    self.topNaviBg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 30)] autorelease];
    _topNaviBg.userInteractionEnabled = YES;
    _topNaviBg.image = [[UIImage imageNamed:@"snav-bg.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [contentView addSubview:_topNaviBg];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    self.beginDateLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)]autorelease];
    _beginDateLabel.textAlignment = NSTextAlignmentLeft;
    _beginDateLabel.textColor = [UIColor whiteColor];
    _beginDateLabel.backgroundColor=[UIColor clearColor];
    _beginDateLabel.text = [NSString stringWithFormat:@"从%@",[formatter stringFromDate:_selectBeginDate]];
    [_topNaviBg addSubview:_beginDateLabel];
    
    self.endDateLabel = [[[UILabel alloc]initWithFrame:CGRectMake(160, 5, 150, 20)]autorelease];
    _endDateLabel.textAlignment = NSTextAlignmentRight;
    _endDateLabel.textColor = [UIColor whiteColor];
    _endDateLabel.backgroundColor=[UIColor clearColor];
    _endDateLabel.text = [NSString stringWithFormat:@"至%@",[formatter stringFromDate:_selectEndDate]];
    [_topNaviBg addSubview:_endDateLabel];
    
    self.orderService = [[[OrderService alloc] init] autorelease];
    [_orderService onRespondTarget:self selector:@selector(orderRecordDidFinished:)];
    
    //显示订单Table
    CGRect frame = CGRectMake(0, 30, contentView.frame.size.width, contentView.frame.size.height-30);
    self.orderTable = [[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain] autorelease];
    _orderTable.delegate = self;
    _orderTable.dataSource = self;
    [contentView addSubview:_orderTable];
    
    _isShowMore = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果进来时候设备已经连接，直接查询设备编号
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:@"YES"]) {
        [[PosMiniDevice sharedInstance].posReq reqDeviceSN];
    }
    pageIndex=1;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    [self requestOrderRecordByDate:[dateFormatter stringFromDate:_selectBeginDate] endDate:[dateFormatter stringFromDate:_selectEndDate] businessType:_selectBusinessType];
}

-(void) requestOrderRecordByDate:(NSString *)beginDate endDate:(NSString *)endDate businessType:(NSString *)businessType
{
    NSMutableDictionary *param = [[[NSMutableDictionary alloc] init] autorelease];
    [param setObject:beginDate forKey:PARAM_ORDER_BEGIN_DATE];
    [param setObject:endDate forKey:PARAM_ORDER_END_DATE];
    [param setObject:@"S" forKey:PARAM_ORDER_TRANS_STATUS];
    [param setObject:businessType forKey:PARAM_ORDER_BUSINESS_TYPE];
    [param setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:PARAM_ORDER_PAGE_NUMBER];
    
    [_orderService requestForOrderRecord:param];
}

-(void)orderRecordDidFinished:(NSDictionary *)body{
    
    int totalOrderCount = [[body objectForKey:@"TotalNum"] intValue];
    id orderInfo = [body objectForKey:@"OrdersInfo"];
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
                                  [dict valueForKey:@"SysTime"], nil];
            [_orderList addObject:orderInfo];
        }
    }
    if (totalOrderCount > _orderList.count) {
        _isShowMore = YES;
    }else{
        _isShowMore = NO;
    }

    //刷新数据
    [_orderTable reloadData];
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_orderList.count==0) {
        return 1;
    } else{
        //显示更多
        if (_isShowMore) {
            return _orderList.count+1;
        }
        return _orderList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Order_Identifier";
    static NSString *identifierNoData = @"noData";
    static NSString *identifierMore = @"more";
    if (_orderList.count!=0) {
        //显示更多
        if (_isShowMore && indexPath.row==_orderList.count) {
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
            NSArray *orderInfo = [_orderList objectAtIndex:indexPath.row];
            
            
            [cell setShowArrow:NO];
            [cell setOrderId:[orderInfo objectAtIndex:OrderId]
                 setOrderSum:[[orderInfo objectAtIndex:OrderAmount] floatValue]
              setOrederState:[orderInfo objectAtIndex:OrderStatus]
                setTradeData:[orderInfo objectAtIndex:OrderAccountDate]
                setTradeTime:[orderInfo objectAtIndex:OrderSysTimer]
                  setBankNum:[orderInfo objectAtIndex:OrderPayCard]];
            
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
    if (_orderList.count==0) {
        return 45;
    }
    else{
        if (_isShowMore && indexPath.row==_orderList.count) {
            return 45;
        }
        return ORDERDETAIL_CELLHEIGHT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_orderList.count!=0) {
        if (_isShowMore && indexPath.row==_orderList.count) {
            //处理点击下一页事件
            
            moreLabel.text = @"载入中";
            [activityView startAnimating];
            
            pageIndex++;
            
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            [self requestOrderRecordByDate:[dateFormatter stringFromDate:_selectBeginDate]
                                   endDate:[dateFormatter stringFromDate:_selectEndDate]
                                 businessType:_selectBusinessType];
            return;
        }
    }
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00017";
}

#pragma mark -

-(void)dealloc{
    [_selectBusinessType release];
    [_selectBeginDate release];
    [_selectEndDate release];
    [_orderList release];
    [_orderService release];
    [_orderTable release];
    [_topNaviBg release];
    [_beginDateLabel release];
    [_endDateLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
