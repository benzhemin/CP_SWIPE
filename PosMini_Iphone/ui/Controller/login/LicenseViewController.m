//
//  LicenseViewController.m
//  CardReader
//
//  Created by songxiang
//  Copyright (c) 2012年 songxiang. All rights reserved.
//

#import "LicenseViewController.h"
#define PADDING_BOTTOM 30
#define SCROLLVIEW_MARGINBOTTOM 50

@interface LicenseViewController ()

@end

@implementation LicenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"许可协议"];
    
    //显示协议的圆角背景
    UIImageView *showLicenseTextBg = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 292, contentView.frame.size.height-14-SCROLLVIEW_MARGINBOTTOM)];
    showLicenseTextBg.image = [[UIImage imageNamed:@"radius.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    showLicenseTextBg.userInteractionEnabled = YES;
    [contentView addSubview:showLicenseTextBg];
    [showLicenseTextBg release];
    
    //标题
    UILabel *showTitleLable = [[UILabel alloc] initWithFrame:CGRectMake((showLicenseTextBg.frame.size.width-200)/2, 15, 200, 30)];
    showTitleLable.text = @"POS mini使用协议";
    showTitleLable.backgroundColor = [UIColor clearColor];
    showTitleLable.textAlignment = NSTextAlignmentCenter;
    showTitleLable.font = [UIFont boldSystemFontOfSize:18];
    showTitleLable.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    [showLicenseTextBg addSubview:showTitleLable];
    [showTitleLable release];
    //显示注册协议文字TextView
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:CGRectMake(10, 50, showLicenseTextBg.frame.size.width-20, showLicenseTextBg.frame.size.height-70)];
    textView.scrollEnabled = YES;
    ((UIScrollView *)textView).delegate = self;
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
    
    //确认注册按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(10, contentView.frame.size.height-PADDING_BOTTOM, 300, 47);
    [confirmButton setBackgroundImage:[[UIImage imageNamed:@"reg-btn.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:47] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //[confirmButton setTitle:@"同意并确认注册" forState:UIControlStateNormal];
    
    [confirmButton setTitle:@"同意许可协议" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UIScrollViewDelegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height) {
        isReadAll = YES;
    }
}
/**
	处理注册按钮点击
	@param sender 系统参数
 */
-(void) registerClick:(id)sender

{
    if (isReadAll) {
        //阅读了所有的协议
        /*
        RegisterViewController *_registerViewController = [[RegisterViewController alloc]init];
        _registerViewController.isShowTabBar =NO;
        [self.navigationController pushViewController:_registerViewController animated:YES];
        [_registerViewController release];
        */
        
        //返回应用登录页面
        [Helper saveValues:@"YES" forKey:@"LICENSEAGREED"];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        //协议没有阅读完成
        [self showMessage:@"请下滑阅读完所有的许可协议!"];
    }

}
@end
