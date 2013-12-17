//
//  OrderListViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderService.h"

typedef enum {
    OrderAccountDate = 0,
    OrderPosId,
    OrderAmount,
    OrderId,
    OrderStatus,
    OrderPayCard,
    OrderSysSeqId,
    OrderSysTimer
} OrderInfoSeq;

@interface OrderListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *  是否显示更多 
 */
@property (nonatomic, assign)BOOL isShowMore;
/**
 *  表格上边的背景
 */   
@property (nonatomic, retain) UIImageView *topNaviBg;
/**
 *  详细列表
 */
@property (nonatomic, retain) UITableView *orderTable;
/**
 *  交易明细数据集合
 */
@property (nonatomic, retain) NSMutableArray *orderList;
/**
 *  订单服务类 
 */
@property (nonatomic, retain) OrderService *orderService;
/**
 *  查询业务类型
 */
@property (nonatomic, retain) NSString *selectBusinessType;
/**
 *  查询开始日期
 */
@property (nonatomic, retain) NSDate *selectBeginDate;
/**
 *  查询开始日期
 */
@property (nonatomic, retain) NSDate *selectEndDate;
/**
 *  显示开始日期
 */
@property (nonatomic, retain) UILabel *beginDateLabel;
/**
 *  显示结束日期
 */
@property (nonatomic, retain) UILabel *endDateLabel;


@end
