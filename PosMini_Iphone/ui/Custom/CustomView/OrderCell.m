//
//  CustomShowOrderCell.m
//  CardReader
//
//  Created by songxiang on 13-1-5.
//  Copyright (c) 2013年 songxiang. All rights reserved.
//

#import "OrderCell.h"
#define TITLE_WIDTH 55
#define CONTENT_WIDTH 140
#define TITLE_HEIGHT 20
#define RIGHTCONTENT_WIDTH 77
#define CELL_MARGINTOP 5
#define CELL_PADDINGLEFT 10
#define CELL_PADDINGRIGHT 30
#define CELL_PADDINGTOP 7
#define CONTENT_MARGIN_LEFT 5

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题文字颜色
        UIColor *titleTextColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1.0];
        //标题文字大小
        UIFont *titleTextFont = [UIFont systemFontOfSize:12];
        
        //订单编号标题
        orderNumberTitleLabel = [[UILabel alloc]init];
        orderNumberTitleLabel.frame = CGRectMake(CELL_PADDINGLEFT, CELL_PADDINGTOP, TITLE_WIDTH, TITLE_HEIGHT);
        orderNumberTitleLabel.textColor = titleTextColor;
        orderNumberTitleLabel.font = titleTextFont;
        orderNumberTitleLabel.text = @"订单编号:";
        orderNumberTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderNumberTitleLabel];
        [orderNumberTitleLabel release];
        
        //显示订单号
        orderNumberContentLabel = [[UILabel alloc]init];
        orderNumberContentLabel.frame = CGRectMake(orderNumberTitleLabel.frame.size.width+orderNumberTitleLabel.frame.origin.x+CONTENT_MARGIN_LEFT, CELL_PADDINGTOP, CONTENT_WIDTH, TITLE_HEIGHT);
        orderNumberContentLabel.textColor = titleTextColor;
        orderNumberContentLabel.font = titleTextFont;
        //orderNumberContentLabel.text = @"30012021235";
        orderNumberContentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderNumberContentLabel];
        [orderNumberContentLabel release];
        
        //订单金额标题
        orderSumTitleLabel = [[UILabel alloc]init];
        orderSumTitleLabel.frame = CGRectMake(CELL_PADDINGLEFT, orderNumberTitleLabel.frame.origin.y+orderNumberTitleLabel.frame.size.height+CELL_MARGINTOP,TITLE_WIDTH, TITLE_HEIGHT);
        orderSumTitleLabel.textColor = titleTextColor;
        orderSumTitleLabel.font = titleTextFont;
        orderSumTitleLabel.text = @"订单金额:";
        orderSumTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderSumTitleLabel];
        [orderSumTitleLabel release];
        
        //订单金额
        orderSumCountLabel= [[UILabel alloc]init];
        orderSumCountLabel.frame = CGRectMake(orderSumTitleLabel.frame.size.width+orderSumTitleLabel.frame.origin.x+CONTENT_MARGIN_LEFT, orderSumTitleLabel.frame.origin.y, 80, TITLE_HEIGHT);
        orderSumCountLabel.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0];
        orderSumCountLabel.font = [UIFont systemFontOfSize:16];
        //orderSumCountLabel.text = @"999.00";
        orderSumCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderSumCountLabel];
        [orderSumCountLabel release];
        
        //显示订单金额单位
        showUnitLabel= [[UILabel alloc]init];
        showUnitLabel.frame = CGRectMake(orderSumCountLabel.frame.origin.x+orderSumCountLabel.frame.size.width, orderSumCountLabel.frame.origin.y,15, TITLE_HEIGHT);
        showUnitLabel.textColor = titleTextColor;
        showUnitLabel.font = titleTextFont;
        showUnitLabel.text = @"元";
        showUnitLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:showUnitLabel];
        [showUnitLabel release];
        
        //订单状态标题
        orderStatusTitleLabel = [[UILabel alloc]init];
        orderStatusTitleLabel.frame = CGRectMake(CELL_PADDINGLEFT, orderSumTitleLabel.frame.origin.y+orderSumTitleLabel.frame.size.height+CELL_MARGINTOP, TITLE_WIDTH, TITLE_HEIGHT);
        orderStatusTitleLabel.textColor = titleTextColor;
        orderStatusTitleLabel.font = titleTextFont;
        orderStatusTitleLabel.text = @"订单状态:";
        orderStatusTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderStatusTitleLabel];
        [orderStatusTitleLabel release];
        
        //订单状态
        orderStatusCountLabel = [[UILabel alloc]init];
        orderStatusCountLabel.frame = CGRectMake(orderStatusTitleLabel.frame.size.width+orderStatusTitleLabel.frame.origin.x+CONTENT_MARGIN_LEFT, orderStatusTitleLabel.frame.origin.y, CONTENT_WIDTH, TITLE_HEIGHT);
        orderStatusCountLabel.textColor = titleTextColor;
        orderStatusCountLabel.font = titleTextFont;
        //orderRefundSumCountLabel.text = @"1000.00元";
        orderStatusCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:orderStatusCountLabel];
        [orderStatusCountLabel release];
        
        //退款按钮
        refundButton = [[UILabel alloc]init];
        refundButton.frame = CGRectMake(self.frame.size.width-60, 0, 60, 30);
        refundButton.userInteractionEnabled = YES;
        refundButton.textColor = [UIColor colorWithRed:49/255.0 green:92/255.0 blue:137/255.0 alpha:1.0];
        refundButton.backgroundColor = [UIColor clearColor];
        refundButton.font = [UIFont boldSystemFontOfSize:16];
        refundButton.text = @"退款";
        [self addSubview:refundButton];
        [refundButton release];
        
        //右边箭头
        arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        arrowImageView.frame = CGRectMake(self.frame.size.width-20, 8, 10, 14);
        [self addSubview: arrowImageView];
        [arrowImageView release];
        
        
        //交易时间
        tradeTimeLabel = [[UILabel alloc]init];
        tradeTimeLabel.frame = CGRectMake(self.frame.size.width-RIGHTCONTENT_WIDTH-CELL_PADDINGRIGHT-TITLE_WIDTH+20, orderSumCountLabel.frame.origin.y, TITLE_WIDTH, TITLE_HEIGHT);
        tradeTimeLabel.textColor = titleTextColor;
        tradeTimeContentLabel.textAlignment = NSTextAlignmentRight;
        tradeTimeLabel.font = titleTextFont;
        tradeTimeLabel.text = @"交易时间:";
        tradeTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTimeLabel];
        [tradeTimeLabel release];
        
        //显示退款时间
        tradeTimeContentLabel = [[UILabel alloc]init];
        tradeTimeContentLabel.frame = CGRectMake(tradeTimeLabel.frame.origin.x+tradeTimeLabel.frame.size.width, orderSumCountLabel.frame.origin.y, RIGHTCONTENT_WIDTH, TITLE_HEIGHT);
        tradeTimeContentLabel.textAlignment = NSTextAlignmentRight;
        tradeTimeContentLabel.textColor = titleTextColor;
        tradeTimeContentLabel.font = titleTextFont;
        //tradeTimeContentLabel.text = @"13:00";
        tradeTimeContentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTimeContentLabel];
        [tradeTimeContentLabel release];
        
        //卡号末四位
        bankAccountLabel = [[UILabel alloc]init];
        bankAccountLabel.frame = CGRectMake(self.frame.size.width-CELL_PADDINGRIGHT-100+20, orderStatusCountLabel.frame.origin.y, 100, TITLE_HEIGHT);
        bankAccountLabel.textAlignment = NSTextAlignmentRight;
        bankAccountLabel.textColor = titleTextColor;
        bankAccountLabel.font = titleTextFont;
        //bankAccountLabel.text=@"卡号末四位:1987";
        bankAccountLabel.textAlignment = NSTextAlignmentRight;
        bankAccountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:bankAccountLabel];
        [bankAccountLabel release];
        
//        //注册点击事件
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reFund:)];
//        [refundButton addGestureRecognizer:tapGesture];
//        [tapGesture release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 设置订单详细信息
 @param orderId 订单编号
 @param orderSum 订单金额
 @param orderStatus 订单状态
 @param tradetime 交易时间
 @param bankNum 银行卡后四位
 */
-(void) setOrderId:(NSString *)orderId setOrderSum:(float)orderSum setOrederState:(NSString *)orderStatus setTradeTime:(NSString *)tradetime setBankNum:(NSString *)bankNum
{
    orderNumberContentLabel.text = orderId;
    
    //计算订单金额长度，重设位置
    orderSumCountLabel.text = [NSString stringWithFormat:@"%0.2f",orderSum];
    float labelWidth = [Helper getLabelWidth:orderSumCountLabel.text  setFont:orderSumCountLabel.font setHeight:orderSumCountLabel.frame.size.height];
    orderSumCountLabel.frame = CGRectMake(orderSumCountLabel.frame.origin.x, orderSumCountLabel.frame.origin.y, labelWidth, orderSumCountLabel.frame.size.height);
    
    //重设单位位置
    showUnitLabel.frame = CGRectMake(orderSumCountLabel.frame.origin.x+orderSumCountLabel.frame.size.width+5, showUnitLabel.frame.origin.y, showUnitLabel.frame.size.width, showUnitLabel.frame.size.height);
    
    if([orderStatus isEqualToString:@"R"]) {
        orderStatusCountLabel.text = @"已退款";
    }
    else{
        orderStatusCountLabel.text =@"已支付";
    }
    
    tradeTimeContentLabel.text = [NSString stringWithFormat:@"%@时%@分%@秒",[tradetime substringWithRange:NSMakeRange(0, 2)],[tradetime substringWithRange:NSMakeRange(2, 2)],[tradetime substringWithRange:NSMakeRange(4, 2)]];
    
    bankAccountLabel.text = [NSString stringWithFormat:@"卡号末四位:%@",bankNum];
}

/**
 是否显示右边箭头，退款选项
 @param showArrow 是否显示
 */
-(void) setShowArrow:(Boolean)isShowArrow;
{
    if (isShowArrow) {
        refundButton.hidden = NO;
        arrowImageView.hidden = NO;
    }
    else
    {
        refundButton.hidden = YES;
        arrowImageView.hidden = YES;
    }
}


@end
