//
//  DataPickerViewController.m
//  PosMini_Iphone
//
//  Created by ben on 13-8-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DataPickerViewController.h"
#import "AppDelegate.h"
#import "SQLiteOperation.h"

@interface DataPickerViewController ()

/**
 处理点击取消时候，移除选择数据ViewController
 @param sender 系统参数
 */
-(void)cancel:(id)sender;

@end

@implementation DataPickerViewController

@synthesize dataTable;
@synthesize dataType;
@synthesize delegate;
@synthesize keyWord;

-(void)dealloc{
    [keyWord release];
    [dataSource release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化Back按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:15]forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(259, 7, 51, 31);
    [naviBgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮上面的显示的文字
    UILabel *cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cancelButton.frame.size.width, cancelButton.frame.size.height)];
    cancelLabel.text = @"取消";
    cancelLabel.backgroundColor = [UIColor clearColor];
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addSubview:cancelLabel];
    [cancelLabel release];
    
    SQLiteOperation *operation = [[SQLiteOperation alloc] init];
    
    //根据不同的数据源类型，从sqlite数据库中选择不同的数据
	switch (self.dataType) {
        case ProvinceType:
            [self setNavigationTitle:@"请选择省份"];
            dataSource = [[operation selectData:@"SELECT distinct(ProvinceName) FROM areas order by Id asc" resultColumns:1]retain];
            break;
        case AreaType:
            [self setNavigationTitle:@"请选择地区"];
            dataSource = [[operation selectData:[NSString stringWithFormat:@"select areaName from areas where ProvinceName='%@'",keyWord] resultColumns:1]retain];
            break;
    }
    [operation release];
    
    //初始化显示数据Table
    self.dataTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width,contentView.frame.size.height) style:UITableViewStylePlain] autorelease];
    dataTable.backgroundView = nil;
    dataTable.delegate = self;
    dataTable.dataSource = self;
    [contentView addSubview:dataTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 处理点击取消时候，移除选择数据ViewController
 @param sender 系统参数
 */
-(void)cancel:(id)sender
{
    //重新显示下面Tab
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showTabBar];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource Method
//返回cell数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

//返回行高
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

//返回行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row]objectAtIndex:0];
    return cell;
}

#pragma mark UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self dismissModalViewControllerAnimated:YES];
    if (self.delegate!=nil) {
        [self.delegate setSelectedString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    
    //重新显示下面Tab
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showTabBar];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissModalViewControllerAnimated:YES];
}

@end
