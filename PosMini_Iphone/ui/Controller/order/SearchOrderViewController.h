//
//  SearchOrderViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderService.h"

@interface SearchOrderViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  滑动视图
 */
@property(nonatomic,retain)UIScrollView *backScrollView;
/**
 *  订单查询服务类
 */
@property (nonatomic, retain) OrderService *orderService;
/**
 *  查询日期
 */
@property (nonatomic, retain) NSMutableArray *selectDateArray;
/**
 *  查询业务类型
 */
@property (nonatomic ,retain) NSMutableArray *selectBusinessArray;
/**
 *  显示列表
 */
@property (nonatomic, retain) UITableView *showTableView;
/**
 *  从服务器获取的时间
 */
@property (nonatomic, retain) NSDate *mtpDate;
/**
 *  起始时间
 */
@property (nonatomic, retain) NSDate *beginDate;
/**
 *  结束时间
 */
@property (nonatomic, retain) NSDate *endDate;
/**
 *  记住选择的是起始时间或者是结束时间
 */
@property (nonatomic, assign) NSInteger selectDateRow;
/**
 *  记住选择的业务类型
 */
@property (nonatomic, assign) NSInteger selectBusinessType;
/**
 *  弹出框
 */
@property (nonatomic, retain) UIActionSheet *actionSheet;
/**
 *  日期选择器
 */
@property (nonatomic, retain) UIDatePicker *pickerView;
/**
 *  业务类型选择器
 */
@property (nonatomic ,retain) UIPickerView *businessPickerView;
/**
 *  完成的交易数量 
 */
@property (nonatomic, assign) NSInteger totalNum;
@end
