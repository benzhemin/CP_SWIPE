//
//  ConvenienceBusinessViewController.h
//  PosMini_Iphone
//
//  Created by FKF on 13-10-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface ConvenienceBusinessViewController : BaseViewController <UIWebViewDelegate>
/**
 *  接收的URL
 */
@property(nonatomic,copy)NSString *receivedURL;
/**
 *  HTML页面
 */
@property(nonatomic,retain)UIWebView *webView;

@end
