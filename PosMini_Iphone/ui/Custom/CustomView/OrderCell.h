//
//  CustomShowOrderCell.h
//  自定义显示订单详细信息View
//
//  Created by songxiang on 13-1-5.
//  Copyright (c) 2013年 songxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"


@interface OrderCell : UITableViewCell
{
    UILabel *orderNumberTitleLabel;//订单编号标题
    UILabel *orderSumTitleLabel;//订单金额标题
    UILabel *orderStatusTitleLabel;//已退金额标题
    
    UILabel *orderNumberContentLabel;//显示订单编号
    UILabel *orderSumCountLabel;//显示订单金额
    UILabel *orderStatusCountLabel;//显示已退金额
    UILabel *showUnitLabel;//显示单位
    
    UILabel *tradeTimeLabel;//交易时间
    //UILabel *refundtimeLabel;//退款次数;
    UILabel *tradeTimeContentLabel;//显示交易时间内容
    //UILabel *refundtimeContentLabel;//显示退款次数内容
    
    UILabel *refundButton;//退款按钮
    UIImageView *arrowImageView;//可以退款项显示的箭头
    
    //显示卡号末四位
    UILabel *bankAccountLabel;
}

/**
 设置订单详细信息
 @param orderId 订单编号
 @param orderSum 订单金额
 @param orderStatus 订单状态
 @param tradetime 交易时间
 @param bankNum 银行卡后四位
 */
-(void) setOrderId:(NSString *)orderId setOrderSum:(float)orderSum setOrederState:(NSString *)orderStatus setTradeTime:(NSString *)tradetime setBankNum:(NSString *)bankNum;

/**
	是否显示右边箭头，退款选项
	@param showArrow 是否显示
 */
-(void) setShowArrow:(Boolean)isShowArrow;


/**
	处理退款点击事件
	@param sender 系统参数
 */
-(void) reFund:(id)sender;

@end
