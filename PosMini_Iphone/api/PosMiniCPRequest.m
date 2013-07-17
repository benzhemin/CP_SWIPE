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

BOOL NotNil(id dict, NSString *k){
    if (dict!=nil && [dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:k]!=nil) {
        return YES;
    }
    return NO;
}

BOOL NotNilAndEqualsTo(id dict, NSString *k, NSString *value){
    if (dict!=nil && [dict isKindOfClass:[NSDictionary class]] && [dict valueForKey:k]!=nil && [[NSString stringWithFormat:@"%@", [dict valueForKey:k]] isEqualToString:value]) {
        return YES;
    }
    return NO;
}

@implementation PosMiniCPRequest

@synthesize userInfo;

-(void)dealloc{
    [userInfo release];
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
    
    //统一判断状态码返回
    //状态码返回成功
    if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"000"))
    {
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
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUIRE_USER_LOGIN object:nil];
    }
    //返回出错,打印出错信息
    else if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"881"))
    {
        //当然用户尚未绑定设备
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"当前用户未绑定设备", NOTIFICATION_MESSAGE, nil];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_SYS_AUTO_PROMPT object:nil userInfo:dict];
    }
    else if (NotNil(body, @"RespDesc"))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[body objectForKey:@"RespDesc"], NOTIFICATION_MESSAGE, nil];
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_SYS_AUTO_PROMPT object:nil userInfo:dict];
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
