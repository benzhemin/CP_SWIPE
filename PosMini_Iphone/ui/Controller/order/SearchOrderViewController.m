//
//  SearchOrderViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "OrderListViewController.h"
#import "Helper.h"

@interface SearchOrderViewController ()
{
    UIButton *detailButton;
    UILabel *dateLabel;
    UIView *resultView;
}
@end

@implementation SearchOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    if (self=[super init]) {
        self.orderService = [[[OrderService alloc] init] autorelease];
        [_orderService onRespondTarget:self selector:@selector(orderSearchRecordRequestDidFinished:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"历史交易查询"];
    
    self.backScrollView=[[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)]autorelease];
    _backScrollView.contentSize=CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+80);
    [contentView addSubview:_backScrollView];
    //默认收款
    self.selectBusinessType=0;
    
//    self.showTableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 15, contentView.frame.size.width,contentView.frame.size.height*3/5.0) style:UITableViewStyleGrouped]autorelease];
    self.showTableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 15, contentView.frame.size.width,165) style:UITableViewStyleGrouped]autorelease];
    _showTableView.backgroundView=nil;
    _showTableView.scrollEnabled=NO;
    _showTableView.backgroundColor=[UIColor clearColor];
    _showTableView.delegate=self;
    _showTableView.dataSource=self;
    [_backScrollView addSubview:_showTableView];
    
    self.selectDateArray=[[[NSMutableArray alloc]init]autorelease];

    [_selectDateArray insertObject:self.mtpDate atIndex:0];
    [_selectDateArray insertObject:self.mtpDate atIndex:1];
    
    self.selectBusinessArray=[NSMutableArray arrayWithObjects:@"收款",@"付款",@"全部", nil];
    
    //查询按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
//    confirmButton.frame = CGRectMake(20, _showTableView.frame.origin.y+_showTableView.frame.size.height-45, contentView.frame.size.width-40, 47);
    confirmButton.frame = CGRectMake(20, _showTableView.frame.origin.y+_showTableView.frame.size.height+20, contentView.frame.size.width-40, 47);
    confirmButton.tag = 1;
    [confirmButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"查    询" forState:UIControlStateNormal];
    confirmButton.titleLabel.font=[UIFont boldSystemFontOfSize:22];
    [_backScrollView addSubview:confirmButton];
    
    UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, confirmButton.frame.origin.y+confirmButton.frame.size.height+20, contentView.frame.size.width, 1)];
    lineImageView.image=[UIImage imageNamed:@"query_line"];
    [_backScrollView addSubview:lineImageView];
    [lineImageView release];
    
}
#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 3;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回行高
    return 50;
}

//返回每个Table中的每行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        
        //显示标题
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(20,5, 85, cell.frame.size.height-5);
        title.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.tag = 1;
        [cell addSubview:title];
        [title release];
        
        //显示内容
        UILabel *content = [[UILabel alloc]init];
        content.frame = CGRectMake(105, 5, 180, cell.frame.size.height-5);
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentRight;
        content.font = [UIFont systemFontOfSize:16];
        content.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        content.tag = 2;
        [cell addSubview:content];
        [content release];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    UILabel *content = (UILabel *)[cell viewWithTag:2];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
 
    switch (indexPath.row) {
        case 0:
            title.text = @"起始日期:";
            content.text = [formatter stringFromDate:[_selectDateArray objectAtIndex:0]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            title.text = @"结束日期:";
            content.text = [formatter stringFromDate:[_selectDateArray objectAtIndex:1]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            title.text = @"业务类型:";
            content.text = [_selectBusinessArray objectAtIndex:_selectBusinessType];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    return cell;
}


-(void) setQueryDate:(NSDate *)beginDate endDate:(NSDate*)endDate
{

    if (beginDate!=nil) {
        [_selectDateArray replaceObjectAtIndex:0 withObject:beginDate];
    }else{
        [_selectDateArray replaceObjectAtIndex:0 withObject:_mtpDate];
    }
    
    if (endDate!=nil) {
        [_selectDateArray replaceObjectAtIndex:1 withObject:endDate];
    }else{
        [_selectDateArray replaceObjectAtIndex:1 withObject:_mtpDate];
    }
    
    [self.showTableView reloadData];
}
#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row==1) {
        self.selectDateRow=indexPath.row;
        //点击显示时间
        self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
        _actionSheet.tag=1;
        [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        //Date picker
        self.pickerView = [[[UIDatePicker alloc] init] autorelease];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        [_actionSheet addSubview:_pickerView];
        [_pickerView setDate:[_selectDateArray objectAtIndex:_selectDateRow]];
        
        CGRect pickerRect = _pickerView.bounds;
        pickerRect.origin.y = -45;
        _pickerView.bounds = pickerRect;
        
        //取消按钮
        UISegmentedControl *cancelBtn = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]] autorelease];
        cancelBtn.momentary = YES;
        cancelBtn.frame = CGRectMake(10.0f, 7.0f, 65.0f, 32.0f);
        cancelBtn.segmentedControlStyle = UISegmentedControlStyleBar;
        [cancelBtn addTarget:self action:@selector(datePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
        [_actionSheet addSubview:cancelBtn];
        cancelBtn.tag = 1;
        
        //确定按钮
        UISegmentedControl *confirmBtn =[[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]] autorelease];
        confirmBtn.momentary = YES;
        confirmBtn.frame = CGRectMake(245, 7.0f, 65.0f, 32.0f);
        confirmBtn.segmentedControlStyle = UISegmentedControlStyleBar;
        [confirmBtn addTarget:self action:@selector(datePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
        [_actionSheet addSubview:confirmBtn];
        confirmBtn.tag = 2;
        
        [_actionSheet showInView:self.view];
        [_actionSheet setBounds:CGRectMake(0,0, 320, 500)];
    }else{
        //点击业务类型
        self.actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
        _actionSheet.tag=2;
        [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        //picker
        
        CGRect pickerRect =CGRectMake(0, 45, 0, 0);
        self.businessPickerView = [[[UIPickerView alloc] initWithFrame:pickerRect] autorelease];
        _businessPickerView.showsSelectionIndicator=YES;
        _businessPickerView.dataSource=self;
        _businessPickerView.delegate=self;
        [_businessPickerView selectRow:_selectBusinessType inComponent:0 animated:YES];
        [_actionSheet addSubview:_businessPickerView];

        //取消按钮
        UISegmentedControl *cancelBtn = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]] autorelease];
        cancelBtn.momentary = YES;
        cancelBtn.frame = CGRectMake(10.0f, 7.0f, 65.0f, 32.0f);
        cancelBtn.segmentedControlStyle = UISegmentedControlStyleBar;
        [cancelBtn addTarget:self action:@selector(businessPickerDoneClick:) forControlEvents:UIControlEventValueChanged];
        [_actionSheet addSubview:cancelBtn];
        cancelBtn.tag = 1;
        
        //确定按钮
        UISegmentedControl *confirmBtn =[[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]] autorelease];
        confirmBtn.momentary = YES;
        confirmBtn.frame = CGRectMake(245, 7.0f, 65.0f, 32.0f);
        confirmBtn.segmentedControlStyle = UISegmentedControlStyleBar;
        [confirmBtn addTarget:self action:@selector(businessPickerDoneClick:) forControlEvents:UIControlEventValueChanged];
        [_actionSheet addSubview:confirmBtn];
        confirmBtn.tag = 2;
        
        [_actionSheet showInView:self.view];
        [_actionSheet setBounds:CGRectMake(0,0, 320, 500)];
    }
   
}
#pragma mark - UIActionSheetDelegate Method
/**
 响应UISegmentedControl点击
 @param sender 系统参数
 */
-(void)datePickerDoneClick:(id)sender
{
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    if (sc.tag==2) {
        if(_selectDateRow==0)
        //只获取当天去除小时分
        self.beginDate=[formatter dateFromString:[formatter stringFromDate:_pickerView.date]];
        else
        self.endDate = [formatter dateFromString:[formatter stringFromDate:_pickerView.date]];
    }
    [_actionSheet dismissWithClickedButtonIndex:sc.tag animated:YES];
}

-(void)businessPickerDoneClick:(id)sender{
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    if (sc.tag==2) {
        self.selectBusinessType=[_businessPickerView selectedRowInComponent:0];
    }
    [_actionSheet dismissWithClickedButtonIndex:sc.tag animated:YES];
}

#pragma mark - UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
        //查询指定日期
        if (buttonIndex==2) {
            [self setQueryDate:self.beginDate endDate:self.endDate];
        }
    }else{
        if (buttonIndex==2) {
            [self.showTableView reloadData];
        }
    }
    
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_selectBusinessArray count];
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_selectBusinessArray objectAtIndex:row];
}

#pragma mark - 查询按钮
-(void)btnClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==1) {
        
        if ([[_selectDateArray objectAtIndex:1] timeIntervalSinceDate:[_selectDateArray objectAtIndex:0]]>=(31*24*3600)) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"查询天数不能超过31天!"];
            return;
        }
        
        if ([[_selectDateArray objectAtIndex:1] timeIntervalSinceDate:[_selectDateArray objectAtIndex:0]]<0) {
            [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"查询时间不合法!"];
            return;
        }
    
        NSString *busiType=[NSString stringWithFormat:@""];
        if ([[_selectBusinessArray objectAtIndex:_selectBusinessType] isEqualToString:@"收款"]) {
            busiType=@"R";
        }else if ([[_selectBusinessArray objectAtIndex:_selectBusinessType] isEqualToString:@"付款"]){
            busiType=@"P";
        }else{
            busiType=@"";
        }
        
        [[PosMiniDevice sharedInstance]setQueryPayOrderBusinessType:busiType];
        [[PosMiniDevice sharedInstance]setQueryPayOrderBeginDate:[_selectDateArray objectAtIndex:0]];
        [[PosMiniDevice sharedInstance]setQueryPayOrderEndDate:[_selectDateArray objectAtIndex:1]];
        
        NSMutableDictionary *param = [[[NSMutableDictionary alloc] init] autorelease];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
        [formatter setDateFormat:@"yyyyMMdd"];
        [param setObject:[formatter stringFromDate:[_selectDateArray objectAtIndex:0]] forKey:PARAM_ORDER_BEGIN_DATE];
        [param setObject:[formatter stringFromDate:[_selectDateArray objectAtIndex:1]] forKey:PARAM_ORDER_END_DATE];
        [param setObject:busiType forKey:PARAM_ORDER_BUSINESS_TYPE];
        
        [_orderService requestForOrderRecordStatistics:param];
    }
}
#pragma mark - 交易明细
-(void)moreInfo:(id)sender{

    OrderListViewController *ol=[[OrderListViewController alloc]init];
    ol.selectBusinessType = [PosMiniDevice sharedInstance].queryPayOrderBusinessType;
    ol.selectBeginDate = [PosMiniDevice sharedInstance].queryPayOrderBeginDate;
    ol.selectEndDate = [PosMiniDevice sharedInstance].queryPayOrderEndDate;
    [self.navigationController pushViewController:ol animated:YES];
    [ol release];
}
#pragma mark -
-(void)orderSearchRecordRequestDidFinished:(NSDictionary *)body{
    if (resultView && dateLabel && detailButton) {
        [resultView removeFromSuperview];
        resultView=nil;
        
        [dateLabel removeFromSuperview];
        dateLabel=nil;
        
        [detailButton removeFromSuperview];
        detailButton=nil;
    }

    //总交易数量
    int totalOrderCount = [[body objectForKey:@"TotalNum"] intValue];
    int refundCount=[[body objectForKey:@"RefundedNum"] intValue];
    int paymentOrderCount=totalOrderCount-refundCount;
    double totalAccountCount = [[body objectForKey:@"TotalAmount"] doubleValue] - [[body objectForKey:@"RefundedAmount"] doubleValue];
    resultView=[[UIView alloc]initWithFrame:CGRectMake(20,  _showTableView.frame.origin.y+_showTableView.frame.size.height+105, 180, 150)];
    resultView.backgroundColor=[UIColor clearColor];
    [_backScrollView addSubview:resultView];
    
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    dateLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width-40, 25)]autorelease];
    dateLabel.backgroundColor=[UIColor clearColor];
    dateLabel.textAlignment=NSTextAlignmentLeft;
    dateLabel.font=[UIFont systemFontOfSize:16];
    dateLabel.text=[NSString stringWithFormat:@"从%@  至%@",[formatter stringFromDate:[_selectDateArray objectAtIndex:0]],[formatter stringFromDate:[_selectDateArray objectAtIndex:1]]];
    [resultView addSubview:dateLabel];
    
    
    UILabel *totalLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0,25,40,25)]autorelease];
    totalLabel.backgroundColor=[UIColor clearColor];
    totalLabel.textAlignment=NSTextAlignmentLeft;
    totalLabel.font=[UIFont systemFontOfSize:15];
    totalLabel.text=[NSString stringWithFormat:@"共计:"];
    [resultView addSubview:totalLabel];
    
    double t=[[_selectDateArray objectAtIndex:1] timeIntervalSinceDate:[_selectDateArray objectAtIndex:0]];
    NSString *dayNum=[NSString stringWithFormat:@"%.0f",t/24/60/60+1];
    UILabel *redDateLabel=[[[UILabel alloc]init]autorelease];
    redDateLabel.text=dayNum;
    redDateLabel.backgroundColor=[UIColor clearColor];
    redDateLabel.font=[UIFont systemFontOfSize:15];
    redDateLabel.textColor=[UIColor redColor];
    float labelWidth = [Helper getLabelWidth:redDateLabel.text  setFont:redDateLabel.font setHeight:redDateLabel.frame.size.height];
    redDateLabel.frame=CGRectMake(totalLabel.frame.size.width+totalLabel.frame.origin.x,totalLabel.frame.origin.y,labelWidth, 25);
    [resultView addSubview:redDateLabel];
    
    UILabel *dateLabel2=[[[UILabel alloc]init]autorelease];
    dateLabel2.text=@"天,完成";
    dateLabel2.font=[UIFont systemFontOfSize:15];
    dateLabel2.backgroundColor=[UIColor clearColor];
    dateLabel2.frame=CGRectMake(redDateLabel.frame.size.width+redDateLabel.frame.origin.x,totalLabel.frame.origin.y,50, 25);
    [resultView addSubview:dateLabel2];
    
    UILabel *redTotalLabel=[[[UILabel alloc]init]autorelease];
    redTotalLabel.text=[NSString stringWithFormat:@"%d",totalOrderCount];
    redTotalLabel.backgroundColor=[UIColor clearColor];
    redTotalLabel.font=[UIFont systemFontOfSize:15];
    redTotalLabel.textColor=[UIColor redColor];
    float redTotalWidth=[Helper getLabelWidth:redTotalLabel.text setFont:redTotalLabel.font setHeight:redTotalLabel.frame.size.height];
    redTotalLabel.frame=CGRectMake(dateLabel2.frame.size.width+dateLabel2.frame.origin.x,totalLabel.frame.origin.y, redTotalWidth,25);
    [resultView addSubview:redTotalLabel];

    UILabel *dateLabel3=[[[UILabel alloc]init]autorelease];
    dateLabel3.text=@"笔交易";
    dateLabel3.font=[UIFont systemFontOfSize:15];
    dateLabel3.backgroundColor=[UIColor clearColor];
    dateLabel3.frame=CGRectMake(redTotalLabel.frame.size.width+redTotalLabel.frame.origin.x, totalLabel.frame.origin.y, 50, 25);
    [resultView addSubview:dateLabel3];
    
    UILabel *paymentLabel=[[[UILabel alloc]initWithFrame:CGRectMake(40,50,45,25)]autorelease];
    paymentLabel.backgroundColor=[UIColor clearColor];
    paymentLabel.textAlignment=NSTextAlignmentLeft;
    paymentLabel.font=[UIFont systemFontOfSize:15];
    paymentLabel.text=[NSString stringWithFormat:@"已支付"];
    [resultView addSubview:paymentLabel];
    
    UILabel *paymentLabel2=[[[UILabel alloc]init]autorelease];
    paymentLabel2.text=[NSString stringWithFormat:@"%d",paymentOrderCount];
    float paymentWidth=[Helper getLabelWidth:paymentLabel2.text setFont:paymentLabel2.font setHeight:paymentLabel2.frame.size.height];
    paymentLabel2.backgroundColor=[UIColor clearColor];
    paymentLabel2.textColor=[UIColor redColor];
    paymentLabel2.font=[UIFont systemFontOfSize:15];
    paymentLabel2.frame=CGRectMake(paymentLabel.frame.size.width+paymentLabel.frame.origin.x, paymentLabel.frame.origin.y, paymentWidth, 25);
    [resultView addSubview:paymentLabel2];
    
    UILabel *paymentLabel3=[[[UILabel alloc]init]autorelease];
    paymentLabel3.text=@"笔";
    paymentLabel3.font=[UIFont systemFontOfSize:15];
    paymentLabel3.backgroundColor=[UIColor clearColor];
    paymentLabel3.frame=CGRectMake(paymentLabel2.frame.size.width+paymentLabel2.frame.origin.x, paymentLabel.frame.origin.y, 15, 25);
    [resultView addSubview:paymentLabel3];
    
    UILabel *refundLabel=[[[UILabel alloc]initWithFrame:CGRectMake(40,75,45,25)]autorelease];
    refundLabel.backgroundColor=[UIColor clearColor];
    refundLabel.textAlignment=NSTextAlignmentLeft;
    refundLabel.font=[UIFont systemFontOfSize:15];
    refundLabel.text=[NSString stringWithFormat:@"已退款"];
    [resultView addSubview:refundLabel];
    
    UILabel *refundLabel2=[[[UILabel alloc]init]autorelease];
    refundLabel2.text=[NSString stringWithFormat:@"%d",refundCount];
    float refundWidth=[Helper getLabelWidth:refundLabel2.text setFont:refundLabel2.font setHeight:refundLabel2.frame.size.height];
    refundLabel2.backgroundColor=[UIColor clearColor];
    refundLabel2.textColor=[UIColor redColor];
    refundLabel2.font=[UIFont systemFontOfSize:15];
    refundLabel2.frame=CGRectMake(refundLabel.frame.size.width+refundLabel.frame.origin.x, refundLabel.frame.origin.y, refundWidth, 25);
    [resultView addSubview:refundLabel2];
    
    UILabel *refundLabel3=[[[UILabel alloc]init]autorelease];
    refundLabel3.text=@"笔";
    refundLabel3.font=[UIFont systemFontOfSize:15];
    refundLabel3.backgroundColor=[UIColor clearColor];
    refundLabel3.frame=CGRectMake(refundLabel2.frame.size.width+refundLabel2.frame.origin.x, refundLabel.frame.origin.y, 15, 25);
    [resultView addSubview:refundLabel3];
    
    UILabel *totalAccountLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0,100,40,25)]autorelease];
    totalAccountLabel.backgroundColor=[UIColor clearColor];
    totalAccountLabel.textAlignment=NSTextAlignmentLeft;
    totalAccountLabel.font=[UIFont systemFontOfSize:15];
    totalAccountLabel.text=[NSString stringWithFormat:@"合计:"];
    [resultView addSubview:totalAccountLabel];
    
    UILabel *totalAccountLabel2=[[[UILabel alloc]init]autorelease];
    totalAccountLabel2.text=[NSString stringWithFormat:@"%.2f",totalAccountCount];
    float totalAccountWidth=[Helper getLabelWidth:totalAccountLabel2.text setFont:totalAccountLabel2.font setHeight:totalAccountLabel2.frame.size.height];
    totalAccountLabel2.backgroundColor=[UIColor clearColor];
    totalAccountLabel2.textColor=[UIColor redColor];
    totalAccountLabel2.font=[UIFont systemFontOfSize:15];
    totalAccountLabel2.frame=CGRectMake(totalAccountLabel.frame.size.width+totalAccountLabel.frame.origin.x, totalAccountLabel.frame.origin.y, totalAccountWidth, 25);
    [resultView addSubview:totalAccountLabel2];
    
    UILabel *totalAccountLabel3=[[[UILabel alloc]init]autorelease];
    totalAccountLabel3.text=@"元";
    totalAccountLabel3.font=[UIFont systemFontOfSize:15];
    totalAccountLabel3.backgroundColor=[UIColor clearColor];
    totalAccountLabel3.frame=CGRectMake(totalAccountLabel2.frame.size.width+totalAccountLabel2.frame.origin.x, totalAccountLabel.frame.origin.y, 15, 25);
    [resultView addSubview:totalAccountLabel3];
    
    detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame=CGRectMake(200, resultView.frame.origin.y+75, 100, 35);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detail_red_btn"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setTitle:@"交易明细" forState:UIControlStateNormal];
    totalOrderCount<1?detailButton.hidden=YES:NO;
    [_backScrollView addSubview:detailButton];

}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00016";
}

#pragma mark - 内存清理
-(void)dealloc{
    [_backScrollView release];
    [_orderService release];
    [_beginDate release];
    [_endDate release];
    [_mtpDate release];
    [_actionSheet release];
    [_businessPickerView release];
    [_pickerView release];
    [_selectDateArray release];
    [_showTableView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
