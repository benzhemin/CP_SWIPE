//
//  HelpLicenseViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "HelpLicenseViewController.h"
#import "CustomTextView.h"
#define PADDING_BOTTOM 30
#define SCROLLVIEW_MARGINBOTTOM 50

@interface HelpLicenseViewController ()

@end

@implementation HelpLicenseViewController

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
	// Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"使用协议"];
    
    //显示协议的圆角背景
    UIImageView *showLicenseTextBg = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 292, contentView.frame.size.height-28)];
    showLicenseTextBg.image = [[UIImage imageNamed:@"radius.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    showLicenseTextBg.userInteractionEnabled = YES;
    [contentView addSubview:showLicenseTextBg];
    [showLicenseTextBg release];
    
    //标题
    UILabel *showTitleLable = [[UILabel alloc] initWithFrame:CGRectMake((showLicenseTextBg.frame.size.width-200)/2, 15, 200, 30)];
    showTitleLable.text = @"POSmini使用协议";
    showTitleLable.backgroundColor = [UIColor clearColor];
    showTitleLable.textAlignment = NSTextAlignmentCenter;
    showTitleLable.font = [UIFont boldSystemFontOfSize:18];
    showTitleLable.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    [showLicenseTextBg addSubview:showTitleLable];
    [showTitleLable release];
    
    //显示注册协议文字TextView
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:CGRectMake(10, 50, showLicenseTextBg.frame.size.width-20, showLicenseTextBg.frame.size.height-70)];
    textView.scrollEnabled = YES;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    textView.text = content;
    
    CGSize size = [textView.text sizeWithFont: textView.font
                            constrainedToSize: CGSizeMake(textView.frame.size.width,INT32_MAX) lineBreakMode: UILineBreakModeClip];
    
    [textView setContentSize:size];
    [showLicenseTextBg addSubview:textView];
    [textView release];
    
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00019";
}

#pragma mark - 内存清理
-(void)dealloc{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
