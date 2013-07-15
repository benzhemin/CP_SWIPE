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
        
        userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)execute{
    //set CHINAPNR json post
    if ([self.request.requestMethod isEqualToString:@"POST"]) {
        if ([self.request respondsToSelector:@selector(setPostBodyFormat:)]) {
            [(ASIFormDataRequest *)self.request setPostBodyFormat:ASIURLEncodedPostJSONFormat];
        }
    }
    
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
    
	if (target && selector)
	{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:self];
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
