//
//  ConvenienceBusinessViewController.m
//  PosMini_Iphone
//
//  Created by FKF on 13-10-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ConvenienceBusinessViewController.h"
#import "LicenseViewController.h"
#import "Helper.h"

@interface ConvenienceBusinessViewController ()

@end

@implementation ConvenienceBusinessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果进来时候设备已经连接，直接查询设备编号
    if ([[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:@"YES"]) {
        [[PosMiniDevice sharedInstance].posReq reqDeviceSN];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHeight = statusBarFrame.size.height;
    
    self.webView = [[[UIWebView alloc]initWithFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width , self.view.frame.size.height-statusBarHeight)]autorelease];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    
    NSURL *url=[NSURL URLWithString:self.receivedURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[PosMini sharedInstance]showUIPromptMessage:@"载入中" animated:YES];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[PosMini sharedInstance]hideUIPromptMessage:YES];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[PosMini sharedInstance]hideUIPromptMessage:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    NSLog(@"requestString:%@",requestString);
	if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"hf"]) {
        //拦截返回按钮
		if([(NSString *)[components objectAtIndex:1] isEqualToString:@"//back"]){
            [self.navigationController popViewControllerAnimated:YES];
            
		}else{
            
            //拦截URL
            NSRange range = [requestString rangeOfString:@"pay?"];
            int location = range.location;
            
            if (location != NSNotFound) {
                // 截取后面的参数字符串
                NSString *paramStr = [requestString substringFromIndex:location];
                // 切割所有的参数
                NSArray *params = [paramStr componentsSeparatedByString:@"&"];
                
                NSString *orderId=nil;
                NSString *money=nil;
                for (NSString *param in params) {
                    NSRange orderIdRange =  [param rangeOfString:@"orderno"];
                    NSRange moneyRange =  [param rangeOfString:@"amount"];
                    if (orderIdRange.location != NSNotFound) {
                        orderId = [param substringFromIndex:orderIdRange.location + orderIdRange.length + 1];
                        //记录订单号
                        [[PosMiniDevice sharedInstance] setProviderOrdId:orderId];
                    }
                    if(moneyRange.location != NSNotFound) {
                        money = [param substringFromIndex:moneyRange.location + moneyRange.length + 1];
                        double tmp=[money doubleValue];
                        money=[NSString stringWithFormat:@"%.2f",tmp];
                    }
                }
                
                //获取当前设备状态
                if ([Helper getValueByKey:POSMINI_CONNECTION_STATUS]==nil ||[[Helper getValueByKey:POSMINI_CONNECTION_STATUS] isEqualToString:NSSTRING_NO]) {
                    
                    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请插入设备!"];
                }else{
                    if ([PosMiniDevice sharedInstance].isDeviceLegal){
                        //将收款金额放置到PosMiniDevice中
                        [PosMiniDevice sharedInstance].paySum = money;
                        //重置刷卡器
                        
                        [[PosMini sharedInstance] showUIPromptMessage:@"重置读卡器" animated:YES];
                        [[PosMiniDevice sharedInstance].posReq resetDevice];
                    }else{
                        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"不是合法设备!"];
                    }
                }

            }
            return NO;
        }
        
	}
	return YES;
    
}

/**
 返回用户行为跟踪Id号
 @returns 页面编号
 */
-(NSString *)getViewId{
    
    return @"pos00015";
}

#pragma mark - 内存清理
-(void)dealloc{
    [_receivedURL release];
    [_webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
