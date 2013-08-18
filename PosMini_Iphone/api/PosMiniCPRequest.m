//
//  PosMiniCPRequest.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PosMiniCPRequest.h"
#import "NSNotificationCenter+CP.h"
#import "PosMini.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Helper.h"
#import "PayService.h"
#import "RefundService.h"

//防止服务端返回空值,客户端解析异常而退出
BOOL NotNil(id dict, NSString *k){
    if (dict!=nil && [dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:k]!=nil) {
        return YES;
    }
    return NO;
}

//防止服务端返回空值,客户端解析异常而退出
BOOL NotNilAndEqualsTo(id dict, NSString *k, NSString *value){
    if (dict!=nil && [dict isKindOfClass:[NSDictionary class]] && [dict valueForKey:k]!=nil && [[NSString stringWithFormat:@"%@", [dict valueForKey:k]] isEqualToString:value]) {
        return YES;
    }
    return NO;
}

@implementation PosMiniCPRequest

@synthesize reqtype, userInfo;
@synthesize respDesc;

-(void)dealloc{
    [userInfo release];
    [respDesc release];
    [super dealloc];
}

-(id)initWithTarget:(id)_target{
    self = [super init];
    if (self) {
        target = _target;
        selector = @selector(requestFinished:);
    }
    return self;
}

-(void)execute{
    
    [self onRespondJSON:self];
    
    [[PosMini sharedInstance] performRequest:self.request];
    
    [super execute];
}


- (void)onResponseText:(NSString *)body withResponseCode:(unsigned int)responseCode
{
    [self onRespondText:nil];
    
    if (target && selector)
	{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:self];
        }
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode
{
    [self onRespondJSON:nil];
    
    NSLog(@"%@", body);
    //统一判断状态码返回
    //状态码返回成功
    if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"000"))
    {
        //如果返回sessionId就做存储
        if (NotNil(body, @"SessionId")) {
            [Helper saveValue:[body valueForKey:@"SessionId"] forKey:POSMINI_LOCAL_SESSION];
        }
        
        if (target && selector)
        {
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:self];
            }
        }
    }
    //需要重新登录建立session
    else if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"899"))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUIRE_USER_LOGIN object:nil];
        
        //[[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"长时间未使用，请重新登录!"];
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回出错,打印出错信息
    else if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"881"))
    {
        //当然用户尚未绑定设备
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"当前用户未绑定设备"];
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回未定义状态码,提示服务器返回信息
    else if (NotNil(body, @"RespDesc"))
    {
        self.respDesc = [body objectForKey:@"RespDesc"];
        if (target!=nil && [target respondsToSelector:@selector(processMTPRespDesc:)]) {
            [target performSelector:@selector(processMTPRespDesc:) withObject:self];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:[body objectForKey:@"RespDesc"]];
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回内容非JSON格式
    else{
        [[PosMini sharedInstance] hideUIPromptMessage:YES];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"服务端返回数据异常"];
    }
}

//处理失败消息分发
- (void) requestFailed:(ASIHTTPRequest *)request{
    //取消loading显示效果
    [[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType) {
        if ([target respondsToSelector:@selector(requestTimeOut:)]) {
            [target performSelector:@selector(requestTimeOut:) withObject:self];
        }
    }
}

-(void)setDidFinishSelector:(SEL)_selector{
    selector = _selector;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

@end
