//
//  BasicService.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"
#import "NSNotificationCenter+CP.h"
#import "ASIHTTPRequest.h"

@implementation BasicService

- (id)onRespondTarget:(id)_target{
    target = _target;
    return self;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

//ASIHTTPRequest failure callback
- (void) requestFailed:(ASIHTTPRequest *)req{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [req error];
    NSString *description = [error localizedDescription];
    NSLog(@"%@", description);
    
    NSLog(@"网络异常　url:%@", req.url);
    
    /*Add_S 启明 张翔 功能点:故障对应#0002517*/
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"网络连接失败"];
    /*Add_E 启明 张翔 功能点:故障对应#0002517*/
}

//默认提示超时
- (void) requestTimeOut:(ASIHTTPRequest *)req{
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请求超时!"];
}

//处理服务器返回的信息
//当返回状态码在客户端未定义,而返回的应答信息不为空
- (void) processMTPRespDesc:(PosMiniCPRequest *)req{
    //do nothing here
}

@end
