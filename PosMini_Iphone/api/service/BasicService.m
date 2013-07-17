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

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

//如果采用ASIHTTPRequest的原始方式请求,添加失败回调接口
- (void) requestFailed:(ASIHTTPRequest *)request{
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [request error];
    NSString *description = [error localizedDescription];
    NSLog(@"%@", description);
    
    NSLog(@"网络异常　url:%@", request.url);
}

@end
