//
//  DefaultHelpViewController.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-15.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DefaultHelpViewController.h"
#import "QAHelpCell.h"

@interface DefaultHelpViewController ()

@end

@implementation DefaultHelpViewController

@synthesize helpTableView;

-(void)dealloc{
    [helpTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"使用帮助"];
    //初始化显示帮助信息Table
    helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, contentView.frame.size.width-20, contentView.frame.size.height) style:UITableViewStylePlain];
    helpTableView.delegate = self;
    helpTableView.dataSource = self;
    [contentView addSubview:helpTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果进来时候设备已经连接，直接查询设备编号
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:@"YES"]) {
        [[PosMiniDevice sharedInstance].posReq reqDeviceSN];
    }
}

-(NSString *)controllerName{
    return @"DefaultHelpViewController";
}

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

//返回Table每行的Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    QAHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[QAHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.row) {
        case 0:
            [cell setQuestion:@"使用POS mini产品前有哪些注意事项？" setAnswer:@"使用POS mini刷卡器前，请先仔细查看包装盒内的产品说明书，熟悉产品的功能与使用流程。"];
            break;
        case 1:
            [cell setQuestion:@"如何使用POS mini刷卡器进行收款？" setAnswer:@"账户登录成功后，插入POS mini刷卡器，点击进入商户收款模块即可开始收款。"];
            break;
        case 2:
            [cell setQuestion:@"如何更换POS mini刷卡器？" setAnswer:@"一个账户只可以与一台POS mini刷卡器绑定，如需更换请先联系客服人员解除绑定后再完成绑定。"];
            break;
        case 3:
            [cell setQuestion:@"交易失败的原因有哪些？" setAnswer:@"银行卡余额不足、密码输入错误等原因会导致交易失败。此外，超过交易限额也会导致交易失败。"];
            break;
        case 4:
            [cell setQuestion:@"如何进行退款操作？" setAnswer:@"当日支付成功的订单可以在APP上进行消费撤销，隔日的订单可以登陆商户控台进行退款操作。"];
            break;
        case 5:
            [cell setQuestion:@"APP提示交易失败，但是消费者已收到银行扣款通知时，商户该怎么处理？" setAnswer:@"商户可告知消费者，第二天银行会做退款处理。"];
            break;
    }
    return cell;
}

//返回每行Cell的高度
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00007";
}

@end
